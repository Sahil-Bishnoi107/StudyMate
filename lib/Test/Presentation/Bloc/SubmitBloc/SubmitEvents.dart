import 'package:study_mate/Test/Domain/Entities/test.dart';

sealed class SubmitEvents {}



class TestSubmittedEvent extends SubmitEvents{
 Test test;
 int timeLeft;
 TestSubmittedEvent({required this.test,required this.timeLeft});
}