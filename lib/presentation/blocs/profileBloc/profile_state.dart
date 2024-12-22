abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String email;

  ProfileLoaded({required this.email});
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError({required this.error});
}

class ProfileLoggedOut extends ProfileState {}