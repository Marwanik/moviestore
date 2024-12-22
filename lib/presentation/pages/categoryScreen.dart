import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package
import 'package:moviestore/data/models/moviesModel.dart';
import 'package:moviestore/presentation/pages/movieScreen.dart';
import 'package:moviestore/presentation/constans/colors.dart';
import 'package:moviestore/presentation/constans/icons.dart';
import 'package:moviestore/presentation/constans/string.dart';
import 'package:moviestore/presentation/constans/textStyle.dart';

class MoviesListScreen extends StatefulWidget {
  final int categoryId;
  final String categoryTitle;

  MoviesListScreen({required this.categoryId, required this.categoryTitle});

  @override
  _MoviesListScreenState createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen>
    with SingleTickerProviderStateMixin {
  final Dio _dio = Dio();
  List<MovieModel> _movies = [];
  bool _isLoading = true;
  String? _errorMessage;

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _fetchMovies() async {
    try {
      final response = await _dio.get('https://darsoft.b-cdn.net/movies.json');
      final List<dynamic> moviesJson = response.data['movies'];

      setState(() {
        // Map JSON to movieModel and filter by category ID
        _movies = moviesJson
            .map((json) => MovieModel.fromJson(json))
            .where((movie) => movie.categoryId == widget.categoryId)
            .toList();
        _isLoading = false;

        // If no movies, trigger animation
        if (_movies.isEmpty) {
          _animationController.forward();
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToDetails(MovieModel movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
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
          widget.categoryTitle,
          style: appBar,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
        ),
        actions: [
          IconButton(
            icon: BELL,
            onPressed: () {},
          ),
        ],
      ),
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
                  hintText: SEARCH,
                  hintStyle: search,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Section Title
            Text(
              widget.categoryTitle,
              style: categoryFirst,
            ),
            const SizedBox(height: 30),

            Expanded(
              child: _isLoading
                  ? _buildShimmerLoading() // Replace CircularProgressIndicator with shimmer
                  : _errorMessage != null
                  ? Center(
                child: Text(
                  'Error: $_errorMessage',
                  style: homeCategory,
                ),
              )
                  : _movies.isEmpty
                  ? FadeTransition(
                opacity: _opacityAnimation,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: secondColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Coming Soon",
                      style: splash,
                    ),
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  final movieImageUrl =
                      'https://darsoft.b-cdn.net/assets/movies/${movie.id}.jpg';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => _navigateToDetails(movie),
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
                              errorBuilder: (context, error,
                                  stackTrace) {
                                return const FlutterLogo(
                                  size: 80,
                                );
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
                                borderRadius:
                                BorderRadius.circular(8),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Shimmer Loading Widget
  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: categoryColor,
          highlightColor: textColor,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 96,
            decoration: BoxDecoration(
              color: categoryColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}
