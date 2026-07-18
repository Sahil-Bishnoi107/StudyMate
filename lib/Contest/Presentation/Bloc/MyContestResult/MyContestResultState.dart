import 'package:study_mate/Contest/Domain/ContestResult.dart';
import 'package:study_mate/Contest/Domain/ContestResultQuestion.dart';

class MyContestResultState {}

class InitialMyContestResultState extends MyContestResultState {}

class ContestResultLoading extends MyContestResultState {}

class ContestResultLoaded extends MyContestResultState {
  final ContestResult result;
  final List<ContestResultQuestion> questions;
  ContestResultLoaded({required this.result, required this.questions});
}

class ContestResultError extends MyContestResultState {
  final String message;
  ContestResultError({required this.message});
}