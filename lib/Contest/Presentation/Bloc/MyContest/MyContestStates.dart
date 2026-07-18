
import 'package:study_mate/Contest/Domain/MyContest.dart';

abstract class MyContestStates {}

class MyContestInitial extends MyContestStates {}

class MyContestLoading extends MyContestStates {}

class MyContestLoaded extends MyContestStates {
  final List<MyContest> myContests;
  MyContestLoaded({required this.myContests});
}

class MyContestError extends MyContestStates {
  final String message;
  MyContestError({required this.message});
}


