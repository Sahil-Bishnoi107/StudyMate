import 'package:study_mate/Test/Domain/Entities/test.dart';

sealed class Submitstates {}

class InitialSubmitState extends Submitstates{}


class TestSubmitting extends Submitstates{}

class FailedToSubmitTest extends Submitstates{}

class TestSubmitted extends Submitstates{
  Test test;
  Map<String,int> questionsPerSubject;
  Map<String,int> correctQuestionsPerSubject;
  Map<String,int> questionsSkippedPerSubject;
  List<String> subjects;
  int timeTaken;

  TestSubmitted({required this.test,required this.correctQuestionsPerSubject,required this.questionsPerSubject,required this.timeTaken,required this.questionsSkippedPerSubject,required this.subjects});

}