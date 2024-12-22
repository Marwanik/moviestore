import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviestore/domain/use_cases/getMovies.dart';
import 'package:moviestore/domain/entities/movie.dart';
import 'package:moviestore/presentation/blocs/movieBloc/movie_event.dart';
import 'package:moviestore/presentation/blocs/movieBloc/movie_state.dart';

class MoviesBloc extends Bloc<MovieEvent, MovieState> {
  final GetMoviesUseCase getMoviesUseCase;

  MoviesBloc({required this.getMoviesUseCase}) : super(MoviesInitial()) {
    on<LoadMoviesEvent>((event, emit) async {
      emit(MoviesLoading());
      try {
        final movies = await getMoviesUseCase.execute(event.categoryId);
        emit(MoviesLoaded(movies: movies));
      } catch (e) {
        emit(MoviesError(error: e.toString()));
      }
    });
  }
}
