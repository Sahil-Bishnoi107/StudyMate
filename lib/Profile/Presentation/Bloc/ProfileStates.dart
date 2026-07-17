import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/Profile/Domain/practiceQuestion.dart';
import 'package:study_mate/Profile/Domain/student.dart';

class Profilestates {}

class LoadedProfileState extends Profilestates{
  List<MyContest> contest;
  Student student;
  List<PracticeUserQuestion> questions;
  LoadedProfileState({required this.student,required this.contest,required this.questions});
  
}

class InitialProfileState extends Profilestates{}

class LoadingProfileState extends Profilestates{}

class ErrorProfileState extends Profilestates{}