import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/QuestionsSection/Domain/Collection.dart';

class MyQuestionsStates {}

class MyQuestionsInitialState extends MyQuestionsStates {}

class MyQuestionsLoadingState extends MyQuestionsStates {}

class MyQuestionsLoadedState extends MyQuestionsStates {
  final List<Collection> collections;
  final List<Question> collectionQuestions;

  MyQuestionsLoadedState({
    required this.collections,
    required this.collectionQuestions,
  });
}

class MyQuestionsErrorState extends MyQuestionsStates {
  final String error;
  MyQuestionsErrorState(this.error);
}

class MyQuestionsActionSuccessState extends MyQuestionsStates {
  final String message;
  MyQuestionsActionSuccessState(this.message);
}
