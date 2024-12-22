import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviestore/domain/use_cases/getMovies.dart';
import 'package:moviestore/presentation/blocs/categoryBloc/category_event.dart';
import 'package:moviestore/presentation/blocs/categoryBloc/category_state.dart';

class CategoryMoviesBloc extends Bloc<CategoryMovieEvent, CategoryMovieState> {
  final GetMoviesUseCase getMoviesUseCase;

  CategoryMoviesBloc({required this.getMoviesUseCase}) : super(CategoryMoviesInitial()) {
    on<LoadCategoryMoviesEvent>((event, emit) async {
      emit(CategoryMoviesLoading());
      try {
        final movies = await getMoviesUseCase.execute(event.categoryId);
        emit(CategoryMoviesLoaded(movies: movies));
      } catch (error) {
        emit(CategoryMoviesError(error: error.toString()));
      }
    });
  }
}
