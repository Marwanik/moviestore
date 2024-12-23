import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviestore/core/config/observerBloc.dart';
import 'package:moviestore/core/config/service_locator.dart';
import 'package:moviestore/data/data_sources/categoryRemoteData.dart';
import 'package:moviestore/domain/use_cases/getMovies.dart';
import 'package:moviestore/presentation/blocs/categoryBloc/category_bloc.dart';
import 'package:moviestore/presentation/blocs/homeBloc/home_bloc.dart';
import 'package:moviestore/presentation/blocs/loginBloc/login_bloc.dart';
import 'package:moviestore/presentation/blocs/movieBloc/movie_bloc.dart';
import 'package:moviestore/presentation/blocs/splashBloc/splash_bloc.dart';
import 'package:moviestore/presentation/blocs/watchlistBloc/watchlist_bloc.dart';
import 'package:moviestore/presentation/blocs/watchlistBloc/watchlist_event.dart';
import 'package:moviestore/presentation/pages/splashScreen.dart';

import 'presentation/blocs/profileBloc/profile_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(
          create: (_) => SplashBloc(),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(
            categoryRemoteDataSource: CategoryRemoteDataSource(Dio()),
          ),
        ),
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(),
        ),
        BlocProvider<CategoryMoviesBloc>(
          create: (_) => CategoryMoviesBloc(
            getMoviesUseCase: core<GetMoviesUseCase>(),
          ),
        ),
        BlocProvider<MoviesBloc>(
          create: (_) => MoviesBloc(
            getMoviesUseCase: core<GetMoviesUseCase>(),
          ),
        ),
        BlocProvider(create: (_) => WatchlistBloc()..add(LoadWatchlist())),
        BlocProvider(create: (context) => ProfileBloc()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
