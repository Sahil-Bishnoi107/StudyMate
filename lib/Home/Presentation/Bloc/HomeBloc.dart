import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Home/Data/HomeData.dart';
import 'package:study_mate/Home/Presentation/Bloc/homeEvents.dart';
import 'package:study_mate/Home/Presentation/Bloc/homeStates.dart';

class Homebloc extends Bloc<Homeevents,Homestates> {
   final Homedata homeData;

   Homebloc(this.homeData) : super(HomeInitial()){
    

    // from next time try writin the event responses in seprate function to keep the constructor clean
    on<HomeProfileRequested>((event, emit) async { 
      ApiResponse response = await homeData.getStudentInfo();
      if(response.statusCode == 200){
        emit(HomeDataRecieved(student: response.data));
        return;
      }
      emit(HomeDataFailure());
    },);

    add(HomeProfileRequested()); // fires whenevr the bloc is created bcs its inside a fucking constructor, obviously
   }
}