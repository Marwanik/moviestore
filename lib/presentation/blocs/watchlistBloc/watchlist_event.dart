import 'package:equatable/equatable.dart';
import 'package:moviestore/data/models/moviesModel.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlist extends WatchlistEvent {}

class AddToWatchlist extends WatchlistEvent {
  final MovieModel movie;

  const AddToWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveFromWatchlist extends WatchlistEvent {
  final MovieModel movie;

  const RemoveFromWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}
