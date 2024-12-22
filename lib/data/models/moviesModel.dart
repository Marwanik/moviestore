import 'package:moviestore/data/models/actorModel.dart';

class MovieModel{
  final int id;
  final int categoryId;
  final String title;
  final String summary;
  final List<actorModel> actors;
  final String director;
  final List<String> writers;
  final double rating;
  final String youtubeVideoId;
  final String year;


  MovieModel({
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

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      summary: json['summary'],
      actors: (json['actors'] as List)
          .map((actorJson) => actorModel.fromJson(actorJson))
          .toList(),
      director: json['director'],
      writers: List<String>.from(json['writers']),
      rating: json['rating'].toDouble(),
      youtubeVideoId: json['youtube_video_id'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'summary': summary,
      'actors': actors.map((actor) => actor.toJson()).toList(),
      'director': director,
      'writers': writers,
      'rating': rating,
      'youtube_video_id': youtubeVideoId,
      'year': year,
    };
  }
}

