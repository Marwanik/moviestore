import 'package:equatable/equatable.dart';

abstract class CategoryMovieEvent extends Equatable {
  const CategoryMovieEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategoryMoviesEvent extends CategoryMovieEvent {
  final int categoryId;

  const LoadCategoryMoviesEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
