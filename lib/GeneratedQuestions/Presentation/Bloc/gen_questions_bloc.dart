import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/GeneratedQuestions/Data/gen_questions_repo.dart';
import 'package:study_mate/GeneratedQuestions/Domain/Entities/gen_question.dart';
import 'package:study_mate/GeneratedQuestions/Presentation/Bloc/gen_questions_events.dart';
import 'package:study_mate/GeneratedQuestions/Presentation/Bloc/gen_questions_states.dart';

class GenQuestionsBloc extends Bloc<GenQuestionsEvents, GenQuestionsStates> {
  final GenQuestionsRepo repo;

  static const int _pageSize = 20;

  GenQuestionsBloc(this.repo) : super(GenQuestionsInitial()) {
    on<GenQuestionsLoadEvent>(_onLoad);
    on<GenQuestionsChangeSubjectEvent>(_onChangeSubject);
    on<GenQuestionsNavigateNextEvent>(_onNavigateNext);
    on<GenQuestionsNavigatePrevEvent>(_onNavigatePrev);
    on<GenQuestionsNextPageEvent>(_onNextPage);
    on<GenQuestionsToggleSelectEvent>(_onToggleSelect);
    on<GenQuestionsRemoveEvent>(_onRemove);
    on<GenQuestionsRestoreEvent>((event, emit) => emit(event.state));
  }

  // ---------------------------------------------------------------------------
  // Load (initial / subject-reset)
  // ---------------------------------------------------------------------------
  Future<void> _onLoad(
    GenQuestionsLoadEvent event,
    Emitter<GenQuestionsStates> emit,
  ) async {
    emit(GenQuestionsLoading());
    final res = await repo.getGeneratedQuestions(
      event.subject,
      event.page,
      event.size,
    );
    if (res.statusCode != 200) {
      emit(GenQuestionsError(
        message: res.error ?? 'Failed to load questions (${res.statusCode})',
      ));
      return;
    }
    final questions = (res.data as List<GenQuestion>?) ?? [];
    if (questions.isEmpty) {
      emit(GenQuestionsError(
        message: 'No questions found for ${event.subject}.',
      ));
      return;
    }
    emit(GenQuestionsLoaded(
      questions: questions,
      currentIndex: 0,
      selectedQuestionIds: [],
      currentPage: event.page,
      hasMore: questions.length >= _pageSize,
      selectedSubject: event.subject,
    ));
  }

  // ---------------------------------------------------------------------------
  // Change subject — full reset
  // ---------------------------------------------------------------------------
  Future<void> _onChangeSubject(
    GenQuestionsChangeSubjectEvent event,
    Emitter<GenQuestionsStates> emit,
  ) async {
    emit(GenQuestionsLoading());
    final res = await repo.getGeneratedQuestions(event.subject, 1, _pageSize);
    if (res.statusCode != 200) {
      emit(GenQuestionsError(
        message: res.error ?? 'Failed to load questions (${res.statusCode})',
      ));
      return;
    }
    final questions = (res.data as List<GenQuestion>?) ?? [];
    if (questions.isEmpty) {
      emit(GenQuestionsError(
        message: 'No questions found for ${event.subject}.',
      ));
      return;
    }
    emit(GenQuestionsLoaded(
      questions: questions,
      currentIndex: 0,
      selectedQuestionIds: [],
      currentPage: 1,
      hasMore: questions.length >= _pageSize,
      selectedSubject: event.subject,
    ));
  }

  // ---------------------------------------------------------------------------
  // Navigate next question — auto-fetches next page at boundary
  // ---------------------------------------------------------------------------
  Future<void> _onNavigateNext(
    GenQuestionsNavigateNextEvent event,
    Emitter<GenQuestionsStates> emit,
  ) async {
    if (state is! GenQuestionsLoaded) return;
    final current = state as GenQuestionsLoaded;

    final nextIndex = current.currentIndex + 1;

    // We are not yet at the end of the loaded list — just move forward.
    if (nextIndex < current.questions.length) {
      emit(current.copyWith(currentIndex: nextIndex));
      return;
    }

    // At the end — check if more pages exist.
    if (!current.hasMore) return; // already at the very last question

    // Prevent duplicate fetches
    if (current.isFetchingNextPage) return;

    // Show in-progress indicator
    emit(current.copyWith(isFetchingNextPage: true));

    final nextPage = current.currentPage + 1;
    final res = await repo.getGeneratedQuestions(
      current.selectedSubject,
      nextPage,
      _pageSize,
    );

    if (res.statusCode != 200) {
      // Keep existing questions; revert fetching flag and show error feedback
      emit(GenQuestionsError(
        message: res.error ?? 'Failed to load next page (${res.statusCode})',
        previousState: current,
      ));
      return;
    }

    final newQuestions = (res.data as List<GenQuestion>?) ?? [];
    final allQuestions = [...current.questions, ...newQuestions];

    emit(current.copyWith(
      questions: allQuestions,
      currentIndex: nextIndex,
      currentPage: nextPage,
      hasMore: newQuestions.length >= _pageSize,
      isFetchingNextPage: false,
    ));
  }

  // ---------------------------------------------------------------------------
  // Navigate previous question
  // ---------------------------------------------------------------------------
  void _onNavigatePrev(
    GenQuestionsNavigatePrevEvent event,
    Emitter<GenQuestionsStates> emit,
  ) {
    if (state is! GenQuestionsLoaded) return;
    final current = state as GenQuestionsLoaded;
    if (current.currentIndex <= 0) return;
    emit(current.copyWith(currentIndex: current.currentIndex - 1));
  }

  // ---------------------------------------------------------------------------
  // Fetch next page explicitly (used internally via navigate; kept for purity)
  // ---------------------------------------------------------------------------
  Future<void> _onNextPage(
    GenQuestionsNextPageEvent event,
    Emitter<GenQuestionsStates> emit,
  ) async {
    if (state is! GenQuestionsLoaded) return;
    final current = state as GenQuestionsLoaded;
    if (!current.hasMore || current.isFetchingNextPage) return;

    emit(current.copyWith(isFetchingNextPage: true));
    final nextPage = current.currentPage + 1;
    final res = await repo.getGeneratedQuestions(
      current.selectedSubject,
      nextPage,
      _pageSize,
    );
    if (res.statusCode != 200) {
      emit(GenQuestionsError(
        message: res.error ?? 'Failed to load next page',
        previousState: current,
      ));
      return;
    }
    final newQuestions = (res.data as List<GenQuestion>?) ?? [];
    emit(current.copyWith(
      questions: [...current.questions, ...newQuestions],
      currentPage: nextPage,
      hasMore: newQuestions.length >= _pageSize,
      isFetchingNextPage: false,
    ));
  }

  // ---------------------------------------------------------------------------
  // Toggle question selection
  // ---------------------------------------------------------------------------
  void _onToggleSelect(
    GenQuestionsToggleSelectEvent event,
    Emitter<GenQuestionsStates> emit,
  ) {
    if (state is! GenQuestionsLoaded) return;
    final current = state as GenQuestionsLoaded;
    final ids = List<String>.from(current.selectedQuestionIds);
    if (ids.contains(event.questionId)) {
      ids.remove(event.questionId);
    } else {
      ids.add(event.questionId);
    }
    emit(current.copyWith(selectedQuestionIds: ids));
  }

  // ---------------------------------------------------------------------------
  // Remove selected questions
  // ---------------------------------------------------------------------------
  Future<void> _onRemove(
    GenQuestionsRemoveEvent event,
    Emitter<GenQuestionsStates> emit,
  ) async {
    if (state is! GenQuestionsLoaded) return;
    final current = state as GenQuestionsLoaded;
    if (current.selectedQuestionIds.isEmpty) return;

    emit(GenQuestionsRemoveLoading(previousState: current));

    final res = await repo.removeQuestions(current.selectedQuestionIds);

    if (res.statusCode != 200) {
      emit(GenQuestionsRemoveError(
        message: res.error ?? 'Failed to remove questions (${res.statusCode})',
        previousState: current,
      ));
      return;
    }

    // Filter out removed questions from local list
    final removedIds = Set<String>.from(current.selectedQuestionIds);
    final remaining = current.questions
        .where((q) => !removedIds.contains(q.id))
        .toList();

    // Keep index valid
    int newIndex = current.currentIndex;
    if (remaining.isEmpty) {
      newIndex = 0;
    } else if (newIndex >= remaining.length) {
      newIndex = remaining.length - 1;
    }

    final updatedState = current.copyWith(
      questions: remaining,
      currentIndex: newIndex,
      selectedQuestionIds: [],
    );

    emit(GenQuestionsRemoveSuccess(updatedState: updatedState));
  }
}
