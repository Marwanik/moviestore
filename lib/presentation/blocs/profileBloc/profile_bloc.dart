import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:moviestore/presentation/blocs/profileBloc/profile_event.dart';
import 'package:moviestore/presentation/blocs/profileBloc/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<LogoutUser>(_onLogoutUser);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final SharedPreferences prefs = GetIt.instance<SharedPreferences>();
      final String? email = prefs.getString('email');
      if (email != null) {
        emit(ProfileLoaded(email: email));
      } else {
        emit(ProfileError(error: "Email not found."));
      }
    } catch (e) {
      emit(ProfileError(error: e.toString()));
    }
  }

  Future<void> _onLogoutUser(LogoutUser event, Emitter<ProfileState> emit) async {
    try {
      final SharedPreferences prefs = GetIt.instance<SharedPreferences>();
      await prefs.clear();
      GetIt.I.reset(); // Clear all registered services
      emit(ProfileLoggedOut());
    } catch (e) {
      emit(ProfileError(error: e.toString()));
    }
  }
}
