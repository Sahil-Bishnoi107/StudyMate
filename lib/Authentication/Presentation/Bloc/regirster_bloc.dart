import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Authentication/Data/AuthRepo.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/register_events.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/register_states.dart';

class RegisterBloc extends Bloc<RegisterEvents,RegisterStates> {
  final AuthRepo authRepo;
  RegisterBloc(this.authRepo) : super(InitialRegisterState()){
    on<AttemptedRegisterEvent>((event, emit) async{
      if(event.password != event.confirmPassword){
        emit(PasswordMismatchState());
        return;
      }
      ApiResponse res  = await authRepo.registerWithEmail(event.name, event.email, event.password);
      if(res.statusCode == 200){
        emit(SuccessfullRegisterState());
      }
      else{
        emit(FailureRegisterState());
      }
    },);
  }
}