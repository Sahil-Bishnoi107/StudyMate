import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Authentication/Data/AuthRepo.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_events.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_states.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState> {
  AuthBloc() : super(AuthAutoInitial()) {

   on<AuthLoginStart>((event, emit) async{
     emit(AuthLoading());
     final email = event.email;
     final password = event.password;
     ApiResponse response = await AuthRepo().loginWithEmail(email, password);
     if(response.statusCode != 200){
      emit(AuthFailure(message: "Please enter correct password"));
      return;
     }
     emit(AuthSuccess());
   },);

   on<AutoLogin>((event, emit) async {
     String token = event.refreshToken;
     ApiResponse response = await AuthRepo().autoLogin(token);
     if(response.statusCode == 200){
      emit(AuthSuccess());
      return;
     }
       emit(AuthInitial());
   },);
  }
  
}