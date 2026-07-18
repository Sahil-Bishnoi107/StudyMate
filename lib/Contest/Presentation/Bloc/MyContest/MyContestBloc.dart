import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Contest/Data/ContestRepo.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContest/MyContestEvents.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContest/MyContestStates.dart';

class MyContestBloc extends Bloc<MyContestEvents, MyContestStates> {
  final ContestRepo contestRepo;

  MyContestBloc(this.contestRepo) : super(MyContestInitial()) {
    on<LoadMyContestsEvent>(_onLoadMyContests);
    
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

  
}
