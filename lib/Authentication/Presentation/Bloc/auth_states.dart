import 'package:study_mate/Role.dart';

class AuthState {}

class AuthSuccess extends AuthState{
  UserRole role;

  AuthSuccess({required this.role});
}
class AuthFailure extends AuthState{
  String message;
  AuthFailure({required this.message});
}
class AuthLoading extends AuthState{}
class AuthInitial extends AuthState{}
class AuthAutoInitial extends AuthState{}

class NewUserState extends AuthState {}


