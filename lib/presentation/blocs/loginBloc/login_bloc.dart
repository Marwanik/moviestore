import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SharedPreferences _prefs;

  LoginBloc()
      : _prefs = GetIt.instance<SharedPreferences>(),
        super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        await Future.delayed(Duration(seconds: 2));

        await _prefs.setString('userEmail', event.email);
        await _prefs.setBool('isLoggedIn', true);

        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(error: 'An error occurred. Please try again.'));
      }
    });
  }
}
