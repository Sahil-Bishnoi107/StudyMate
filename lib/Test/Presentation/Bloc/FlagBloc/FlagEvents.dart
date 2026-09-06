import 'package:study_mate/Home/Domain/Entities/Question.dart';

abstract class FlagEvents {}

class FlagQuestionEvent extends FlagEvents {
  final Question question;
  FlagQuestionEvent({required this.question});
}
