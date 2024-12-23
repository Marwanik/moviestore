import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviestore/presentation/blocs/watchlistBloc/watchlist_bloc.dart';
import 'package:moviestore/presentation/blocs/watchlistBloc/watchlist_event.dart';
import 'package:moviestore/presentation/blocs/watchlistBloc/watchlist_state.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:moviestore/data/models/moviesModel.dart';
import 'package:moviestore/domain/entities/actor.dart';
import 'package:moviestore/presentation/blocs/movieBloc/movie_bloc.dart';
import 'package:moviestore/presentation/blocs/movieBloc/movie_event.dart';
import 'package:moviestore/presentation/blocs/movieBloc/movie_state.dart';
import 'package:moviestore/presentation/constans/colors.dart';
import 'package:moviestore/presentation/constans/icons.dart';
import 'package:moviestore/presentation/constans/string.dart';
import 'package:moviestore/presentation/constans/textStyle.dart';

class MovieDetailsScreen extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late YoutubePlayerController _youtubeController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _youtubeController = YoutubePlayerController(
      initialVideoId: widget.movie.youtubeVideoId,
      flags: const YoutubePlayerFlags(
        loop: true,
        hideControls: true,
        autoPlay: true,
        mute: false,
      ),
    );

    context.read<MoviesBloc>().add(LoadMoviesEvent(widget.movie.categoryId));
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        surfaceTintColor: mainColor,
        backgroundColor: mainColor,
        elevation: 0,
        title: Text(
          widget.movie.title,
          style: appBar,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: YoutubePlayer(
                  controller: _youtubeController,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: selectColor,
                ),
              ),
            ),
            const SizedBox(height: 30),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://darsoft.b-cdn.net/assets/movies/${widget.movie.id}.jpg',
                    width: 108,
                    height: 127,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const FlutterLogo(size: 100);
                    },
                  ),
                ),
                const SizedBox(width: 30),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movie.title,
                        style: movieName1,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            widget.movie.year,
                            style: movieYear1,
                          ),
                          const SizedBox(width: 50),
                          BIGRATE,
                          const SizedBox(width: 10),
                          Text(
                            "${widget.movie.rating}/10",
                            style: movieRate1,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      BlocBuilder<WatchlistBloc, WatchlistState>(
                        builder: (context, state) {
                          bool isInWatchlist = false;

                          if (state is WatchlistLoaded) {
                            isInWatchlist = state.watchlist.any((movie) => movie.id == widget.movie.id);
                          }

                          if (!isInWatchlist) {
                            return ElevatedButton(
                              onPressed: () {
                                context.read<WatchlistBloc>().add(AddToWatchlist(widget.movie));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              child: Text(
                                ADDTOWATCHLIST,
                                style: addWatchlist,
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text(
              SUMMARY,
              style: movieTitle,
            ),
            const SizedBox(height: 10),
            Text(
              widget.movie.summary,
              style: moviedis,
            ),
            const SizedBox(height: 20),

            RichText(
              text: TextSpan(
                style: moviedis,
                children: [
                  TextSpan(
                    text: DIRECTOR,
                    style: moviebold,
                  ),
                  TextSpan(
                    text: widget.movie.director,
                    style: movienotbold,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: moviedis,
                children: [
                  TextSpan(
                    text: WRITERS,
                    style: moviebold,
                  ),
                  TextSpan(
                    text: widget.movie.writers.join(" - "),
                    style: movienotbold,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              CAST,
              style: movieTitle,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: _scrollLeft,
                  icon: Icon(Icons.arrow_back_ios, color: selectColor),
                ),
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: BlocBuilder<MoviesBloc, MovieState>(
                      builder: (context, state) {
                        if (state is MoviesLoading) {
                          return _buildShimmerActors();
                        } else if (state is MoviesLoaded) {
                          return _buildActorList(state.movies.first.actors);
                        } else if (state is MoviesError) {
                          return Center(
                            child: Text(
                              'Error loading actors',
                              style: movieActor,
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _scrollRight,
                  icon: Icon(Icons.arrow_forward_ios, color: selectColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerActors() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 20, top: 20),
          child: Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ClipOval(
                  child: Container(
                    width: 72,
                    height: 72,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 50,
                  height: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActorList(List<Actor> actors) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: actors.length,
      itemBuilder: (context, index) {
        final actor = actors[index];
        final actorImageUrl =
            'https://darsoft.b-cdn.net/assets/artists/${actor.id}.jpg';

        return Padding(
          padding: const EdgeInsets.only(right: 20, top: 20),
          child: Column(
            children: [
              ClipOval(
                child: Image.network(
                  actorImageUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const FlutterLogo(size: 60);
                  },
                ),
              ),
              const SizedBox(height: 5),
              Text(
                actor.name,
                style: movieActor,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        );
      },
    );
  }
}
