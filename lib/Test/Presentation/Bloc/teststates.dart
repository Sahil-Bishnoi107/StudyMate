

import 'package:study_mate/Test/Domain/Entities/test.dart';


class Teststates {}

class TestLoading extends Teststates{}

class TestLoaded extends Teststates{
  Test test;
  int timeLeft;
 
  TestLoaded({required this.test,required this.timeLeft});
}

class FailedTestLoading extends Teststates{}

class TestSubmitState extends Teststates{
  Test test;
  int timeLeft;
  TestSubmitState({required this.test,required this.timeLeft});
}


