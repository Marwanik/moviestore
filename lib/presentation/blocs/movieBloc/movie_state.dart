import 'package:equatable/equatable.dart';
import 'package:moviestore/domain/entities/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MoviesInitial extends MovieState {}

class MoviesLoading extends MovieState {}

class MoviesLoaded extends MovieState {
  final List<Movie> movies;

  MoviesLoaded({required this.movies});

  @override
  List<Object?> get props => [movies];
}

class MoviesError extends MovieState {
  final String error;

  MoviesError({required this.error});

  @override
  List<Object?> get props => [error];
}
