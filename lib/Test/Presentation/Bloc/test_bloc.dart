import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';

import 'package:study_mate/Test/Data/test_repo.dart';
import 'package:study_mate/Test/Domain/Entities/test.dart';
import 'package:study_mate/Test/Presentation/Bloc/testevents.dart';
import 'package:study_mate/Test/Presentation/Bloc/teststates.dart';


class TestBloc extends Bloc<Testevents,Teststates> {
  
  Timer? _timer;

  TestBloc() : super(TestLoading()){

    on<TestLoadingComplete>((event, emit) async{
      
      ApiResponse res = await TestRepo().getQuestions(event.id);
      if(res.statusCode != 200){
        emit(FailedTestLoading());
      }
      Test test = Test(id: event.id, name: event.name, totalQuestions: event.totalQuestions, time: event.time, subject: event.subject, diffiucluty: event.difficulty, questions: res.data);
      emit(TestLoaded(test: test,timeLeft: test.time*60));

      _timer?.cancel();

      _timer = Timer.periodic(const Duration(seconds: 1), (_){
          add(TimerTicked());
      });
    },);


    on<TimerTicked>((event, emit) {
       if (state is! TestLoaded) return;
       final mystate = state as TestLoaded;
       if(mystate.timeLeft <= 1){
        _timer?.cancel();
        add(TestSubmittedEvent());
        return;
       }
       emit(TestLoaded(test: mystate.test, timeLeft: mystate.timeLeft - 1));
    },);


    on<TestOptionSelected>((event, emit) {
      
      final mystate = state as TestLoaded;
      
      final updatedQuestions = mystate.test.questions.map((q){
        if(q.id == event.que.id){
          return q.selectOption(event.optionSelected);
        }
        return q;
      }).toList();

      emit(TestLoaded(test: mystate.test.copyWith(updatedQuestions),timeLeft: mystate.timeLeft));
    },);


    on<TestOptionCleared>((event, emit) {
      final mystate = state as TestLoaded;
      
      final updatedQuestion = mystate.test.questions.map((q){
        if(q.id == event.que.id){
          return q.unselectOption();
        }
        return q;
      }).toList();

      emit(
        TestLoaded(test: mystate.test.copyWith(updatedQuestion),timeLeft: mystate.timeLeft)
      );
    },);


    on<TestSubmittedEvent>((event, emit) async{
      final mystate = state as TestLoaded;
      final Test test = mystate.test;
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
      int timeTaken = test.time*60 - mystate.timeLeft;
      emit(TestSubmitting());
      
      final res = await TestRepo().uploadTest(test);
      if(res.statusCode != 200){
        emit(FailedToSubmitTest());
      }
      emit(TestSubmitted(test: test,correctQuestionsPerSubject: correctQues,questionsPerSubject: totalQues,timeTaken: timeTaken,questionsSkippedPerSubject: skipped,subjects: subjects));
    },);


    on<RetakeTest>((event, emit) {
      emit(TestLoading());
       Test test = event.test;
       for(int i = 0;i < test.questions.length;i++){
        test.questions[i].selectedOption = null;
       }
       emit(TestLoaded(test: test, timeLeft: test.time*60));
    },);


    on<LoadTestReview>((event, emit) {
      final mystate = state as TestSubmitted;
      emit(TestLoaded(test: mystate.test, timeLeft: 10));
    },);
  }

  @override
  Future<void> close(){
   print("TestBloc closed");
   _timer?.cancel();
   return super.close();
  } 

  
}