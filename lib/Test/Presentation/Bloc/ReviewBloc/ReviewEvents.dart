import 'package:study_mate/Test/Domain/Entities/test.dart';

sealed class ReviewEvents {}

class LoadReviewEvent extends ReviewEvents {
  Test test;
  LoadReviewEvent({required this.test});
}
