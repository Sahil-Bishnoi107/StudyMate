import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Test/Presentation/Bloc/ReviewBloc/ReviewEvents.dart';
import 'package:study_mate/Test/Presentation/Bloc/ReviewBloc/ReviewStates.dart';

class ReviewBloc extends Bloc<ReviewEvents, ReviewStates> {
  ReviewBloc() : super(ReviewInitialState()) {
    on<LoadReviewEvent>(_loadReview);
  }

  Future<void> _loadReview(LoadReviewEvent event, Emitter<ReviewStates> emit) async {
    emit(ReviewLoadedState(test: event.test));
  }
}
