import 'package:moviestore/domain/entities/movie.dart';
import 'package:moviestore/domain/repositories/movieRepo.dart';

class GetMoviesUseCase {
  final MovieRepository repository;

  GetMoviesUseCase(this.repository);

  Future<List<Movie>> execute(int categoryId) {
    return repository.getMoviesByCategory(categoryId);
  }
}
