import 'package:study_mate/Home/Domain/Entities/Question.dart';

class Testevents {}

class TestLoadingComplete extends Testevents{
  String id;
  TestLoadingComplete({required this.id});
}

class TestOptionSelected extends Testevents{
  Question ques;
  int optionSelected;
  TestOptionSelected({required this.ques,required this.optionSelected});
}

class TestOptionCleared extends Testevents {
  Question ques;
  int optionSelected;
  TestOptionCleared({required this.ques,required this.optionSelected});
}

class TestSubmittedEvent extends Testevents{

}

class TestTimeUp extends Testevents{}
