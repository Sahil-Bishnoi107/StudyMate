class AuthState {}

class AuthSuccess extends AuthState{
}
class AuthFailure extends AuthState{
  String message;
  AuthFailure({required this.message});
}
class AuthLoading extends AuthState{}
class AuthInitial extends AuthState{}
class AuthAutoInitial extends AuthState{}


