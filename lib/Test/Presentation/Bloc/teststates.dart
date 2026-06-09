

import 'package:study_mate/Test/Domain/Entities/test.dart';

class Teststates {}

class TestLoading extends Teststates{}

class TestLoaded extends Teststates{
  Test test;
  TestLoaded({required this.test});
}

class FailedTestLoading extends Teststates{}

class TestSubmitting extends Teststates{}

class FailedToSubmitTest extends Teststates{}

class TestSubmitted extends Teststates{}