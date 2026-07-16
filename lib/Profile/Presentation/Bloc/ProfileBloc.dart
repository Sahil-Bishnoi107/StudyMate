import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/Profile/Data/ProfileRepo.dart';
import 'package:study_mate/Profile/Domain/practiceQuestion.dart';
import 'package:study_mate/Profile/Domain/student.dart';
import 'package:study_mate/Profile/Presentation/Bloc/ProfileEvents.dart';
import 'package:study_mate/Profile/Presentation/Bloc/ProfileStates.dart';

class Profilebloc extends Bloc<Profileevents,Profilestates>{
  ProfileRepo profileRepo;
  Profilebloc(this.profileRepo) : super(InitialProfileState()){
    on<LoadProfileEvent>((event, emit) async {
      emit(LoadingProfileState());

      final results = await Future.wait(
        [
         profileRepo.getStudentInfo(),
         profileRepo.getMyContests(),
        profileRepo.getMyQuestions(),]
      );
      if(results[0].statusCode != 200 || results[1].statusCode != 200 || results[2].statusCode != 200){
        emit(ErrorProfileState()); return;
      }
      final Student student = results[0].data;
      final List<MyContest> contests = results[1].data;
      final List<PracticeUserQuestion> questions = results[2].data;
      emit(LoadedProfileState(student: student, contest: contests, questions: questions));
    },);
  }
}