import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Contest/Data/ContestRepo.dart';
import 'package:study_mate/Contest/Domain/ContestResult.dart';
import 'package:study_mate/Contest/Domain/ContestResultQuestion.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestResult/MyContestResultEvents.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestResult/MyContestResultState.dart';

class MyContestResultBloc  extends Bloc<MyContestResultEvents,MyContestResultState>{
  final ContestRepo contestRepo;
  MyContestResultBloc(this.contestRepo) : super(InitialMyContestResultState()){
    on<LoadContestResultEvent>(_onLoadContestResult);
  }

  Future<void> _onLoadContestResult(LoadContestResultEvent event, Emitter<MyContestResultState> emit) async {
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