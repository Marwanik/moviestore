import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviestore/core/config/service_locator.dart';
import 'package:moviestore/data/models/moviesModel.dart';
import 'package:moviestore/presentation/blocs/watchlistBloc/watchlist_event.dart';
import 'package:moviestore/presentation/blocs/watchlistBloc/watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistSession _watchlistSession;

  WatchlistBloc()
      : _watchlistSession = core<WatchlistSession>(),
        super(WatchlistLoading()) {
    on<LoadWatchlist>(_onLoadWatchlist);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
  }

  void _onLoadWatchlist(LoadWatchlist event, Emitter<WatchlistState> emit) {
    final watchlist = _watchlistSession.watchlist.map((movie) => MovieModel.fromJson(movie)).toList();
    emit(WatchlistLoaded(watchlist));
  }

  void _onAddToWatchlist(AddToWatchlist event, Emitter<WatchlistState> emit) async {
    await _watchlistSession.addToWatchlist(event.movie.toJson());
    add(LoadWatchlist());
  }

  void _onRemoveFromWatchlist(RemoveFromWatchlist event, Emitter<WatchlistState> emit) async {
    await _watchlistSession.removeFromWatchlist(event.movie.id);
    add(LoadWatchlist());
  }
}
