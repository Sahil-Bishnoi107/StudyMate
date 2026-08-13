import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/Test/Data/test_repo.dart';
import 'package:study_mate/Test/Domain/Entities/test.dart';
import 'package:study_mate/Test/Presentation/Bloc/SubmitBloc/SubmitEvents.dart';
import 'package:study_mate/Test/Presentation/Bloc/SubmitBloc/SubmitStates.dart';

class Submitbloc extends Bloc<SubmitEvents,Submitstates> {
  final TestRepo testRepo;
  Submitbloc(this.testRepo) : super(InitialSubmitState()){
    on<TestSubmittedEvent>(_testSubmitted);
  }

  Future<void> _testSubmitted(TestSubmittedEvent event, Emitter<Submitstates> emit) async{
       



      final Test test = event.test;
      Map<String,int> correctQues = {};
      Map<String,int> totalQues = {};
      Map<String,int> skipped = {};
      Set<String> subjs = {};
      for(Question que in test.questions){
        print(que.selectedOption);
        if(que.selectedOption == null){skipped[que.subject] = (skipped[que.subject] ?? 0) + 1;}
        else if(que.correctOption == que.selectedOption){
          correctQues[que.subject] = (correctQues[que.subject] ?? 0) + 1;
          }
          totalQues[que.subject] = (totalQues[que.subject] ?? 0) + 1;
          subjs.add(que.subject);
      }
      List<String> subjects = subjs.toList();
      int timeTaken = test.time*60 - event.timeLeft;
      emit(TestSubmitting());
      
      final res = await testRepo.uploadTest(test);
      if(res.statusCode != 200){
        emit(FailedToSubmitTest());
      }
      emit(TestSubmitted(test: test,correctQuestionsPerSubject: correctQues,questionsPerSubject: totalQues,timeTaken: timeTaken,questionsSkippedPerSubject: skipped,subjects: subjects));
  }
}