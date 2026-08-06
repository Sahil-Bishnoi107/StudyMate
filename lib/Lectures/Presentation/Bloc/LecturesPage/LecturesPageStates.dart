import 'package:study_mate/Lectures/Domain/VideoModel.dart';

abstract class LecturesPageStates {}

class InitialLecturesState extends LecturesPageStates {}

class LoadingLecturesState extends LecturesPageStates {}

class SuccessLecturesState extends LecturesPageStates {
  final List<VideoModel> videos;

  SuccessLecturesState({required this.videos});
}

class ErrorLecturesState extends LecturesPageStates {
  final String message;

  ErrorLecturesState({required this.message});
}
