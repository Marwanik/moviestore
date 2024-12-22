import 'actor.dart';

class Movie {
  final int id;
  final int categoryId;
  final String title;
  final String summary;
  final List<Actor> actors;
  final String director;
  final List<String> writers;
  final double rating;
  final String youtubeVideoId;
  final String year;

  Movie({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.summary,
    required this.actors,
    required this.director,
    required this.writers,
    required this.rating,
    required this.youtubeVideoId,
    required this.year,
  });
}
