import 'package:study_mate/GeneratedQuestions/Presentation/Bloc/gen_questions_states.dart';

abstract class GenQuestionsEvents {}

/// Load the first page for a given subject (or reset + reload when subject changes).
class GenQuestionsLoadEvent extends GenQuestionsEvents {
  final String subject;
  final int page;
  final int size;
  GenQuestionsLoadEvent({
    required this.subject,
    this.page = 1,
    this.size = 20,
  });
}

/// Fetch the next backend page and append its results.
class GenQuestionsNextPageEvent extends GenQuestionsEvents {}

/// Change the active subject — resets list, page and index, then fetches page 1.
class GenQuestionsChangeSubjectEvent extends GenQuestionsEvents {
  final String subject;
  GenQuestionsChangeSubjectEvent({required this.subject});
}

/// Navigate to the next question. Triggers a page fetch if at the list boundary.
class GenQuestionsNavigateNextEvent extends GenQuestionsEvents {}

/// Navigate to the previous question. No-op if already at index 0.
class GenQuestionsNavigatePrevEvent extends GenQuestionsEvents {}

/// Toggle whether a question ID is in the selectedQuestionIds list.
class GenQuestionsToggleSelectEvent extends GenQuestionsEvents {
  final String questionId;
  GenQuestionsToggleSelectEvent({required this.questionId});
}

/// POST the selected question IDs to the remove endpoint and update local state.
class GenQuestionsRemoveEvent extends GenQuestionsEvents {}

/// Restores a known-good GenQuestionsLoaded state. Used by the UI listener
/// to restore state after transient errors without calling bloc.emit() directly.
class GenQuestionsRestoreEvent extends GenQuestionsEvents {
  final GenQuestionsLoaded state;
  GenQuestionsRestoreEvent({required this.state});
}
