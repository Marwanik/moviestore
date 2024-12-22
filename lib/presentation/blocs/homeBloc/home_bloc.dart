import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moviestore/data/models/categoriesModel.dart';
import 'package:moviestore/data/data_sources/categoryRemoteData.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CategoryRemoteDataSource categoryRemoteDataSource;

  HomeBloc({required this.categoryRemoteDataSource}) : super(HomeInitial()) {
    on<LoadCategoriesEvent>((event, emit) async {
      emit(CategoriesLoading());
      try {
        final categories = await categoryRemoteDataSource.getCategories();
        emit(CategoriesLoaded(categories: categories));
      } catch (error) {
        emit(CategoriesError(error: error.toString()));
      }
    });
  }
}
