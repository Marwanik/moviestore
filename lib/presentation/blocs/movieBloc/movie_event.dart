import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class LoadMoviesEvent extends MovieEvent {
  final int categoryId;

  LoadMoviesEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
