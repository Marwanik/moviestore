import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:moviestore/data/models/moviesModel.dart';
import 'package:moviestore/presentation/constans/colors.dart';
import 'package:moviestore/presentation/constans/icons.dart';
import 'package:moviestore/presentation/constans/string.dart';
import 'package:moviestore/presentation/constans/textStyle.dart';

class MovieDetailsScreen extends StatefulWidget {
  final movieModel movie;

  MovieDetailsScreen({required this.movie});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late YoutubePlayerController _youtubeController;
  bool _isInWatchlist = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initialize YouTube Player Controller
    _youtubeController = YoutubePlayerController(
      initialVideoId: widget.movie.youtubeVideoId,
      flags: YoutubePlayerFlags(
        loop: true,
        hideControls: true,
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleWatchlist() {
    setState(() {
      _isInWatchlist = !_isInWatchlist;
    });
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
            // YouTube Player Section
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

            // Movie Details Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Poster
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

                // Movie Info
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

                      // Add to Watchlist Button
                      if (!_isInWatchlist)
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: ElevatedButton(
                            onPressed: _toggleWatchlist,
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
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Summary Section
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

            // Director and Writers Section
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

            // Cast Section
            Text(
              CAST,
              style: movieTitle,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Left Arrow
                IconButton(
                  onPressed: _scrollLeft,
                  icon: Icon(Icons.arrow_back_ios, color: selectColor),
                ),
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.movie.actors.length,
                      itemBuilder: (context, index) {
                        final actor = widget.movie.actors[index];
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
                    ),
                  ),
                ),
                // Right Arrow
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
}
