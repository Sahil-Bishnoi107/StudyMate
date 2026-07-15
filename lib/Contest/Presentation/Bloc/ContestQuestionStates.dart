import 'package:study_mate/Contest/Domain/Contest.dart';
import 'package:study_mate/Contest/Domain/ContestQuestion.dart';

class ContestQuestionStates {}

class ContestQuestionInitial extends ContestQuestionStates {}

class ContestQuestionLoading extends ContestQuestionStates {}

class ContestQuestionLoaded extends ContestQuestionStates {
  final Contest contest;
  final List<ContestQuestion> questions;
  final DateTime serverEndTime;

  ContestQuestionLoaded({
    required this.contest,
    required this.questions,
    required this.serverEndTime,
  });
}

class ContestQuestionSubmitting extends ContestQuestionStates {}

class ContestQuestionSubmitted extends ContestQuestionStates {}

class ContestQuestionError extends ContestQuestionStates {
  final String message;
  ContestQuestionError({required this.message});
}
