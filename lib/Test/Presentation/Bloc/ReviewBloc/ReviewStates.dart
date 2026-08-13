import 'package:study_mate/Test/Domain/Entities/test.dart';

sealed class ReviewStates {}

class ReviewInitialState extends ReviewStates {}

class ReviewLoadedState extends ReviewStates {
  Test test;
  ReviewLoadedState({required this.test});
}
