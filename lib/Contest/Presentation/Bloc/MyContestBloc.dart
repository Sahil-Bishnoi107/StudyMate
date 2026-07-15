import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Contest/Data/ContestRepo.dart';
import 'package:study_mate/Contest/Domain/ContestResult.dart';
import 'package:study_mate/Contest/Domain/ContestResultQuestion.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestEvents.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestStates.dart';

class MyContestBloc extends Bloc<MyContestEvents, MyContestStates> {
  final ContestRepo contestRepo;

  MyContestBloc(this.contestRepo) : super(MyContestInitial()) {
    on<LoadMyContestsEvent>(_onLoadMyContests);
    on<LoadContestResultEvent>(_onLoadContestResult);
  }

  Future<void> _onLoadMyContests(LoadMyContestsEvent event, Emitter<MyContestStates> emit) async {
    emit(MyContestLoading());
    var res = await contestRepo.getMyContests();
    if (res.statusCode == 200) {
      List<MyContest> contests = res.data as List<MyContest>;
      emit(MyContestLoaded(myContests: contests));
    } else {
      emit(MyContestError(message: "Failed to load my contests."));
    }
  }

  Future<void> _onLoadContestResult(LoadContestResultEvent event, Emitter<MyContestStates> emit) async {
    emit(ContestResultLoading());
    var res = await contestRepo.GetContestResult(event.contestId);
    var qRes = await contestRepo.GetContestResultQuestions(event.contestId);

    if (res.statusCode == 200 && qRes.statusCode == 200) {
      ContestResult result = res.data as ContestResult;
      List<ContestResultQuestion> questions = qRes.data as List<ContestResultQuestion>;
      emit(ContestResultLoaded(result: result, questions: questions));
    } else {
      emit(ContestResultError(message: "Failed to load contest result."));
    }
  }
}
