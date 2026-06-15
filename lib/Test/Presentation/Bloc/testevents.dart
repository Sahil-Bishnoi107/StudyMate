import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/Test/Domain/Entities/test.dart';

class Testevents {}

class TestLoadingComplete extends Testevents{
  String id;
  String name;
  String subject;
  String difficulty;
  int totalQuestions;
  int time;
  TestLoadingComplete({required this.id,required this.difficulty,required this.name,required this.subject,required this.time,required this.totalQuestions});
}

class TestOptionSelected extends Testevents{
  Question que;
  String optionSelected;
  TestOptionSelected({required this.que,required this.optionSelected});
}

class TestOptionCleared extends Testevents {
  Question que;
  TestOptionCleared({required this.que});
}

class TestSubmittedEvent extends Testevents{

}
class TimerTicked extends Testevents{}

class TestTimeUp extends Testevents{}

class RetakeTest extends Testevents{
  Test test;
  RetakeTest({required this.test});
}

class LoadTestReview extends Testevents{

}