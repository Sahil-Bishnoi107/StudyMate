import 'package:study_mate/Contest/Domain/ContestQuestion.dart';

class ContestQuestionEvents {}

class LoadContestQuestions extends ContestQuestionEvents {
  final String contestId;
  LoadContestQuestions({required this.contestId});
}

class SelectContestOption extends ContestQuestionEvents {
  final ContestQuestion question;
  final int optionIndex;
  SelectContestOption({required this.question, required this.optionIndex});
}

class ClearContestOption extends ContestQuestionEvents {
  final ContestQuestion question;
  ClearContestOption({required this.question});
}

class SubmitContestEvent extends ContestQuestionEvents {}
