import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/QuestionsSection/Domain/Collection.dart';
import 'package:study_mate/QuestionsSection/Domain/QuestionFilters.dart';

class Questionsstates {}

class LoadQuestionsState extends Questionsstates{
  List<Collection> collections;
  Questionfilters filters;
  List<Question> questions;
  int currInd;

  LoadQuestionsState({required this.collections, required this.filters, required this.questions, required this.currInd});
}

class QuestionsInitialState extends Questionsstates{
  Questionfilters filters;
  QuestionsInitialState({required this.filters});
}

class QuestionFetchFailed extends Questionsstates{
  String message;
  QuestionFetchFailed(this.message);
}

class FetchingQuestionsState extends Questionsstates{}