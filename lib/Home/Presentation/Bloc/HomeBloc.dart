import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Home/Data/HomeData.dart';
import 'package:study_mate/Home/Presentation/Bloc/homeEvents.dart';
import 'package:study_mate/Home/Presentation/Bloc/homeStates.dart';

class Homebloc extends Bloc<Homeevents,Homestates> {
   Homebloc() : super(HomeInitial()){
    on<HomeProfileRequested>((event, emit) async {
      
      ApiResponse response = await Homedata().getStudentInfo();
      if(response.statusCode == 200){
        emit(HomeDataRecieved(student: response.data));
        return;
      }
      emit(HomeDataFailure());
    },);
   }
}