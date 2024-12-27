import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';

abstract class ProfileStates {
  get profileUser => null;
}

class ProfileInitial extends ProfileStates {}

class ProfileLoading extends ProfileStates {}

class ProfileLoaded extends ProfileStates {
  @override
  final ProfileUser profileUser;
  ProfileLoaded(this.profileUser);
}

class ProfileError extends ProfileStates {
  final String message;
  ProfileError(this.message);
}
