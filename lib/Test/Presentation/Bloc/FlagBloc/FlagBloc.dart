import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Test/Data/test_repo.dart';
import 'package:study_mate/Test/Presentation/Bloc/FlagBloc/FlagEvents.dart';
import 'package:study_mate/Test/Presentation/Bloc/FlagBloc/FlagStates.dart';

class FlagBloc extends Bloc<FlagEvents, FlagStates> {
  final TestRepo testRepo;

  FlagBloc(this.testRepo) : super(FlagInitialState()) {
    on<FlagQuestionEvent>(_onFlagQuestion);
  }

  Future<void> _onFlagQuestion(FlagQuestionEvent event, Emitter<FlagStates> emit) async {
    // Prevent multiple requests if already loading for the same question
    if (state is FlagLoadingState) {
      return;
    }

    emit(FlagLoadingState(questionId: event.question.id));

    final res = await testRepo.flagQuestion(event.question.id);
    if (res.statusCode == 200) {
      emit(FlagSuccessState(questionId: event.question.id));
    } else {
      emit(FlagErrorState(
        questionId: event.question.id, 
        message: res.error ?? "Failed to flag question"
      ));
    }
  }
}
