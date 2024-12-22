import 'package:equatable/equatable.dart';
import 'package:moviestore/data/models/moviesModel.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object> get props => [];
}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<MovieModel> watchlist;

  const WatchlistLoaded(this.watchlist);

  @override
  List<Object> get props => [watchlist];
}

class WatchlistError extends WatchlistState {
  final String error;

  const WatchlistError(this.error);

  @override
  List<Object> get props => [error];
}
