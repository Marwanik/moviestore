import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviestore/data/models/moviesModel.dart';
import 'package:moviestore/presentation/pages/movieScreen.dart';
import 'package:moviestore/presentation/constans/colors.dart';
import 'package:moviestore/presentation/constans/icons.dart';
import 'package:moviestore/presentation/constans/string.dart';
import 'package:moviestore/presentation/constans/textStyle.dart';
import 'package:moviestore/presentation/blocs/watchlistBloc/watchlist_bloc.dart';
import 'package:moviestore/presentation/blocs/watchlistBloc/watchlist_event.dart';
import 'package:moviestore/presentation/blocs/watchlistBloc/watchlist_state.dart';

class WatchListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: BlocProvider(
        create: (context) => WatchlistBloc()..add(LoadWatchlist()),
        child: WatchlistView(),
      ),
    );
  }
}


class WatchlistView extends StatelessWidget {
  void _navigateToDetails(BuildContext context, MovieModel movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<WatchlistBloc>(context),
          child: MovieDetailsScreen(movie: movie),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: secondColor,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: TextField(
              style: search,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                suffixIcon: SEARCHICON,
                hintText: SEARCH,
                hintStyle: search,
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Watchlist Section Title
          Text(
            WATCHLIST,
            style: categoryFirst,
          ),
          const SizedBox(height: 30),

          // Watchlist Content
          Expanded(
            child: BlocBuilder<WatchlistBloc, WatchlistState>(
              builder: (context, state) {
                if (state is WatchlistLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is WatchlistLoaded) {
                  final watchlist = state.watchlist;
                  if (watchlist.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.movie,
                            size: 80,
                            color: secondColor,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "No Data View",
                            style: moviedis,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: watchlist.length,
                      itemBuilder: (context, index) {
                        final movie = watchlist[index];
                        final movieImageUrl =
                            'https://darsoft.b-cdn.net/assets/movies/${movie.id}.jpg';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () => _navigateToDetails(context, movie),
                            child: Row(
                              children: [
                                // Movie Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    movieImageUrl,
                                    width: 90,
                                    height: 96,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const FlutterLogo(size: 80);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 5),

                                // Movie Details
                                Expanded(
                                  child: Container(
                                    width: 225,
                                    height: 96,
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      top: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: categoryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie.title,
                                          style: movieName,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          movie.year,
                                          style: movieYear,
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            SMALLRATE,
                                            const SizedBox(width: 5),
                                            Text(
                                              "${movie.rating}/10",
                                              style: movieRate,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                } else if (state is WatchlistError) {
                  return Center(
                    child: Text('Error: ${state.error}'),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
