import 'package:study_mate/QuestionsSection/Domain/QuestionFilters.dart';

class Questionsevents {}


class SearchQuestions extends Questionsevents{
  final Questionfilters? filters;
  SearchQuestions({this.filters});
}

class AnswerQuestion extends Questionsevents {
  String option;
  AnswerQuestion({required this.option});
}

class ResetFiltersEvent extends Questionsevents {}

class NextQuestionEvent extends Questionsevents {}

class SubmitQuestionEvent extends Questionsevents{
  bool isTrue;
  String id;
  String difficulty;
  String Subject;
  SubmitQuestionEvent({required this.id,required this.Subject,required this.difficulty,required this.isTrue});
}

class UpdateCollectionsEvent extends Questionsevents{}