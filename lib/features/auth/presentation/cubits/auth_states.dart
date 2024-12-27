import 'package:social_media_app/features/auth/domain/entities/app_user.dart';

abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthLoading extends AuthStates {}

class Authenticated extends AuthStates {
  final AppUser user;
  Authenticated(this.user);
}

class UnAuthentiacted extends AuthStates {}

class AuthErrors extends AuthStates {
  final String error;
  AuthErrors(this.error);
}