import 'package:equatable/equatable.dart';
import 'package:moviestore/domain/entities/movie.dart';

abstract class CategoryMovieState extends Equatable {
  const CategoryMovieState();

  @override
  List<Object?> get props => [];
}

class CategoryMoviesInitial extends CategoryMovieState {}

class CategoryMoviesLoading extends CategoryMovieState {}

class CategoryMoviesLoaded extends CategoryMovieState {
  final List<Movie> movies;

  const CategoryMoviesLoaded({required this.movies});

  @override
  List<Object?> get props => [movies];
}

class CategoryMoviesError extends CategoryMovieState {
  final String error;

  const CategoryMoviesError({required this.error});

  @override
  List<Object?> get props => [error];
}
