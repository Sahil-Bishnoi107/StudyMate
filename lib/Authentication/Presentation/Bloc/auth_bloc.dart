import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:study_mate/Authentication/Data/AuthRepo.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_events.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_states.dart';
import 'package:study_mate/secure_storage.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState> {
  final AuthRepo authRepo;
  AuthBloc(this.authRepo) : super(AuthAutoInitial()) {

   on<AuthLoginStart>((event, emit) async{
     emit(AuthLoading());
     final email = event.email;
     final password = event.password;
     ApiResponse response = await authRepo.loginWithEmail(email, password);
     if(response.statusCode != 200){
      emit(AuthFailure(message: "Login Failed"));
      return;
     }
     emit(AuthSuccess());
   },);

   on<AutoLogin>((event, emit) async {
     String? token = await SecureTokens().getRefreshToken();
     token = null;
     if(token == null){
      emit(NewUserState());
      return;
     }
     ApiResponse response = await authRepo.autoLogin(token);
     if(response.statusCode == 200){
      emit(AuthSuccess());
      return;
     }
       emit(AuthInitial());
   },);

   on<GoogleLoginStarted>((event, emit) async {
   const String googleClientId ="708380993884-drr1pe57o46dp8qveea4ceuoinc6ndt0.apps.googleusercontent.com";
  // const String googleClientId =   "708380993884-hftlp2la6vi3tcalldhoii2epm5r5qjn.apps.googleusercontent.com";   both are fine

  try {
    final GoogleSignIn signIn = GoogleSignIn.instance;

    await signIn.initialize(serverClientId: googleClientId);

    final account = await signIn.authenticate();

    emit(AuthLoading());

    ApiResponse response = await authRepo.GoogleSignin(account);

    if (response.statusCode != 200) {
      emit(AuthFailure(
        message: response.error ?? "Google Sign In Failed",
      ));
      return;
    }

    emit(AuthSuccess());
  } catch (e, st) {
    print("Google Sign-In Exception: $e");
    print("Stack Trace:\n$st");

    emit(AuthFailure(
      message: e.toString(),
    ));
  }
});
  }
  
}