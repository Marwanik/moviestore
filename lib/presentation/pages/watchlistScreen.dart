import 'package:flutter/material.dart';
import 'package:moviestore/data/models/moviesModel.dart';
import 'package:moviestore/presentation/constans/colors.dart';
import 'package:moviestore/presentation/constans/icons.dart';
import 'package:moviestore/presentation/constans/textStyle.dart';

class WatchListScreen extends StatefulWidget {
  final List<movieModel> watchlist;

  WatchListScreen({required this.watchlist});

  @override
  _WatchListScreenState createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  List<movieModel> _watchlist = [];

  @override
  void initState() {
    super.initState();
    // Initialize watchlist from passed data
    _watchlist = widget.watchlist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      
      body: Padding(
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
                  hintText: "Search",
                  hintStyle: search,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Watchlist Section Title
            Text(
              "Watchlist",
              style: movieTitle,
            ),
            const SizedBox(height: 30),

            // Watchlist Content
            Expanded(
              child: _watchlist.isEmpty
                  ? Center(
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
                      "No Movies Added Yet",
                      style: moviedis,
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: _watchlist.length,
                itemBuilder: (context, index) {
                  final movie = _watchlist[index];
                  final movieImageUrl =
                      'https://darsoft.b-cdn.net/assets/movies/${movie.id}.jpg';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        // Movie Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            movieImageUrl,
                            width: 70,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const FlutterLogo(size: 70);
                            },
                          ),
                        ),
                        const SizedBox(width: 15),

                        // Movie Details
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: categoryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: movieName1,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      movie.year,
                                      style: movieYear1,
                                    ),
                                    const SizedBox(width: 20),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}
