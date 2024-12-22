import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:moviestore/data/repositories/movieRepoImp.dart';
import 'package:moviestore/domain/use_cases/getMovies.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:moviestore/data/data_sources/movieRemoteData.dart';
import 'package:moviestore/domain/repositories/movieRepo.dart';

GetIt core = GetIt.instance;

class UserSession {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _emailKey = 'userEmail';
  final SharedPreferences _prefs;

  UserSession(this._prefs);

  bool get isLoggedIn => _prefs.getBool(_isLoggedInKey) ?? false;

  String? get userEmail => _prefs.getString(_emailKey);

  Future<void> login(String email) async {
    await _prefs.setBool(_isLoggedInKey, true);
    await _prefs.setString(_emailKey, email);
  }

  Future<void> logout() async {
    await _prefs.setBool(_isLoggedInKey, false);
    await _prefs.remove(_emailKey);
  }
}

class WatchlistSession {
  static const String _watchlistKey = 'watchlist';
  final SharedPreferences _prefs;

  WatchlistSession(this._prefs);

  List<Map<String, dynamic>> get watchlist {
    final jsonString = _prefs.getString(_watchlistKey) ?? '[]';
    return List<Map<String, dynamic>>.from(json.decode(jsonString));
  }

  Future<void> addToWatchlist(Map<String, dynamic> movie) async {
    final currentWatchlist = watchlist;
    currentWatchlist.add(movie);
    await _prefs.setString(_watchlistKey, json.encode(currentWatchlist));
  }

  Future<void> removeFromWatchlist(int movieId) async {
    final currentWatchlist =
    watchlist.where((movie) => movie['id'] != movieId).toList();
    await _prefs.setString(_watchlistKey, json.encode(currentWatchlist));
  }

  Future<void> clearWatchlist() async {
    await _prefs.remove(_watchlistKey);
  }
}

// Initialize all dependencies
Future<void> init() async {
  // SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  core.registerSingleton<SharedPreferences>(prefs);

  // Register UserSession
  core.registerSingleton<UserSession>(UserSession(prefs));

  // Register WatchlistSession
  core.registerSingleton<WatchlistSession>(WatchlistSession(prefs));

  // Dio for HTTP requests
  core.registerLazySingleton(() => Dio());

  // Register Movie Remote Data Source
  core.registerLazySingleton<MovieRemoteDataSource>(
          () => MovieRemoteDataSource(core()));

  // Register Movie Repository
  core.registerLazySingleton<MovieRepository>(
          () => MovieRepositoryImpl(remoteDataSource: core()));

  // Register Use Cases
  core.registerLazySingleton(() => GetMoviesUseCase(core()));
}

// Clear all SharedPreferences data
Future<void> clearSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  GetIt.I.reset(); // Clear all registered GetIt instances
}
