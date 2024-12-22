import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviestore/presentation/blocs/splashBloc/splash_event.dart';
import 'package:moviestore/presentation/blocs/splashBloc/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<StartSplash>(_onStartSplash);
    on<CompleteSplash>(_onCompleteSplash);
  }

  Future<void> _onStartSplash(StartSplash event, Emitter<SplashState> emit) async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 5)); // Simulate delay
    emit(SplashCompleted());
  }

  void _onCompleteSplash(CompleteSplash event, Emitter<SplashState> emit) {
    emit(SplashCompleted());
  }
}
