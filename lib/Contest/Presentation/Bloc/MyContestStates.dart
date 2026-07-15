import 'package:study_mate/Contest/Domain/ContestResult.dart';
import 'package:study_mate/Contest/Domain/ContestResultQuestion.dart';
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

class ContestResultLoading extends MyContestStates {}

class ContestResultLoaded extends MyContestStates {
  final ContestResult result;
  final List<ContestResultQuestion> questions;
  ContestResultLoaded({required this.result, required this.questions});
}

class ContestResultError extends MyContestStates {
  final String message;
  ContestResultError({required this.message});
}
