import 'package:moviestore/data/data_sources/movieRemoteData.dart';
import 'package:moviestore/domain/entities/category.dart';
import 'package:moviestore/domain/entities/movie.dart';
import 'package:moviestore/domain/repositories/movieRepo.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Movie>> getMoviesByCategory(int categoryId) async {
    try {
      final movieModels = await remoteDataSource.getMovies();
      return movieModels
          .where((movieModel) => movieModel.categoryId == categoryId)
          .map((movieModel) => Movie(
        id: movieModel.id,
        categoryId: movieModel.categoryId,
        title: movieModel.title,
        summary: movieModel.summary,
        actors: movieModel.actors.map((actor) => actor.toEntity()).toList(),
        director: movieModel.director,
        writers: movieModel.writers,
        rating: movieModel.rating,
        youtubeVideoId: movieModel.youtubeVideoId,
        year: movieModel.year,
      ))
          .toList();
    } catch (e) {
      throw Exception("Error fetching movies: $e");
    }
  }

  @override
  Future<List<Category>> getCategories() {
    // Throw an unimplemented error if you don't need this method.
    throw UnimplementedError("getCategories is not implemented in MovieRepositoryImpl.");
  }
}
