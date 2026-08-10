class AuthEvent {}

class AuthLoginStart extends AuthEvent{
   String email;
   String password;
   AuthLoginStart({required this.email,required this.password});
}

class AutoLogin extends AuthEvent{
}

class GoogleLoginStarted extends AuthEvent{}
