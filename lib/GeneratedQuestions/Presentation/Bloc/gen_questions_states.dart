import 'package:study_mate/GeneratedQuestions/Domain/Entities/gen_question.dart';

abstract class GenQuestionsStates {}

/// Before any data has been requested.
class GenQuestionsInitial extends GenQuestionsStates {}

/// Full-page loading (initial load or subject change).
class GenQuestionsLoading extends GenQuestionsStates {}

/// Questions are available. Carries all browsing state.
class GenQuestionsLoaded extends GenQuestionsStates {
  final List<GenQuestion> questions;
  final int currentIndex;
  final List<String> selectedQuestionIds;
  final int currentPage;
  final bool hasMore;
  final bool isFetchingNextPage;
  final String selectedSubject;

  GenQuestionsLoaded({
    required this.questions,
    required this.currentIndex,
    required this.selectedQuestionIds,
    required this.currentPage,
    required this.hasMore,
    required this.selectedSubject,
    this.isFetchingNextPage = false,
  });

  GenQuestionsLoaded copyWith({
    List<GenQuestion>? questions,
    int? currentIndex,
    List<String>? selectedQuestionIds,
    int? currentPage,
    bool? hasMore,
    bool? isFetchingNextPage,
    String? selectedSubject,
  }) {
    return GenQuestionsLoaded(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedQuestionIds: selectedQuestionIds ?? this.selectedQuestionIds,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isFetchingNextPage: isFetchingNextPage ?? this.isFetchingNextPage,
      selectedSubject: selectedSubject ?? this.selectedSubject,
    );
  }
}

/// Initial fetch or next-page fetch failed.
class GenQuestionsError extends GenQuestionsStates {
  final String message;
  /// Previous questions are kept so the user can still navigate.
  final GenQuestionsLoaded? previousState;
  GenQuestionsError({required this.message, this.previousState});
}

/// Removal request is in flight.
class GenQuestionsRemoveLoading extends GenQuestionsStates {
  final GenQuestionsLoaded previousState;
  GenQuestionsRemoveLoading({required this.previousState});
}

/// Removal succeeded.
class GenQuestionsRemoveSuccess extends GenQuestionsStates {
  final GenQuestionsLoaded updatedState;
  GenQuestionsRemoveSuccess({required this.updatedState});
}

/// Removal failed — IDs and list remain unchanged.
class GenQuestionsRemoveError extends GenQuestionsStates {
  final String message;
  final GenQuestionsLoaded previousState;
  GenQuestionsRemoveError({required this.message, required this.previousState});
}
