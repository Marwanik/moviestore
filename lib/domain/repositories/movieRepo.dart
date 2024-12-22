import 'package:moviestore/domain/entities/movie.dart';
import 'package:moviestore/domain/entities/category.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMoviesByCategory(int categoryId);
  Future<List<Category>> getCategories();
}
