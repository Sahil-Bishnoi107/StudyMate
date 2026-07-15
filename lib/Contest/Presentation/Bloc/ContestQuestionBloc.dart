import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Contest/Data/ContestRepo.dart';
import 'package:study_mate/Contest/Domain/Contest.dart';
import 'package:study_mate/Contest/Domain/ContestQuestion.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestQuestionEvents.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestQuestionStates.dart';

class ContestQuestionBloc extends Bloc<ContestQuestionEvents, ContestQuestionStates> {
  final ContestRepo contestRepo;
  final Contest contest;

  ContestQuestionBloc(this.contestRepo, this.contest) : super(ContestQuestionInitial()) {
    on<LoadContestQuestions>(_onLoadContestQuestions);
    on<SelectContestOption>(_onSelectContestOption);
    on<ClearContestOption>(_onClearContestOption);
    on<SubmitContestEvent>(_onSubmitContest);
  }

  Future<void> _onLoadContestQuestions(LoadContestQuestions event, Emitter<ContestQuestionStates> emit) async {
    emit(ContestQuestionLoading());
    var res = await contestRepo.FetchContestQuestions(event.contestId);
    if (res.statusCode == 200) {
      List<ContestQuestion> questions = res.data as List<ContestQuestion>;
      // Ensure contest time is computed
      DateTime endTime = contest.startTime.add(Duration(minutes: contest.duration));
      emit(ContestQuestionLoaded(
        contest: contest,
        questions: questions,
        serverEndTime: endTime,
      ));
    } else {
      emit(ContestQuestionError(message: "Failed to load contest questions."));
    }
  }

  void _onSelectContestOption(SelectContestOption event, Emitter<ContestQuestionStates> emit) {
    if (state is ContestQuestionLoaded) {
      final currentState = state as ContestQuestionLoaded;
      List<ContestQuestion> updatedQuestions = List.from(currentState.questions);
      
      int index = updatedQuestions.indexWhere((q) => q.questionId == event.question.questionId);
      if (index != -1) {
        updatedQuestions[index].ans = event.optionIndex;
        emit(ContestQuestionLoaded(
          contest: currentState.contest,
          questions: updatedQuestions,
          serverEndTime: currentState.serverEndTime,
        ));
      }
    }
  }

  void _onClearContestOption(ClearContestOption event, Emitter<ContestQuestionStates> emit) {
    if (state is ContestQuestionLoaded) {
      final currentState = state as ContestQuestionLoaded;
      List<ContestQuestion> updatedQuestions = List.from(currentState.questions);
      
      int index = updatedQuestions.indexWhere((q) => q.questionId == event.question.questionId);
      if (index != -1) {
        updatedQuestions[index].ans = null;
        emit(ContestQuestionLoaded(
          contest: currentState.contest,
          questions: updatedQuestions,
          serverEndTime: currentState.serverEndTime,
        ));
      }
    }
  }

  Future<void> _onSubmitContest(SubmitContestEvent event, Emitter<ContestQuestionStates> emit) async {
    if (state is ContestQuestionLoaded) {
      final currentState = state as ContestQuestionLoaded;
      emit(ContestQuestionSubmitting());
      await contestRepo.submitContest(currentState.questions, contest.contestId);
      emit(ContestQuestionSubmitted());
    }
  }
}
