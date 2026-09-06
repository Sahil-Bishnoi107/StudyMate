abstract class FlagStates {}

class FlagInitialState extends FlagStates {}

class FlagLoadingState extends FlagStates {
  final String questionId;
  FlagLoadingState({required this.questionId});
}

class FlagSuccessState extends FlagStates {
  final String questionId;
  FlagSuccessState({required this.questionId});
}

class FlagErrorState extends FlagStates {
  final String questionId;
  final String message;
  FlagErrorState({required this.questionId, required this.message});
}
