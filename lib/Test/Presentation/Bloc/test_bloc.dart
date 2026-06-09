import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/Test/Data/test_repo.dart';
import 'package:study_mate/Test/Domain/Entities/test.dart';
import 'package:study_mate/Test/Presentation/Bloc/testevents.dart';
import 'package:study_mate/Test/Presentation/Bloc/teststates.dart';


class TestBloc extends Bloc<Testevents,Teststates> {
  
  TestBloc() : super(TestLoading()){
    on<TestLoadingComplete>((event, emit) async{
      
      ApiResponse res = await TestRepo().getQuestions(event.id);
      if(res.statusCode != 200){
        emit(FailedTestLoading());
      }
      Test test = Test(id: event.id, name: event.name, totalQuestions: event.totalQuestions, time: event.time, subject: event.subject, diffiucluty: event.difficulty, questions: res.data);
      emit(TestLoaded(test: test));
    },);


    on<TestOptionSelected>((event, emit) {
      
      final mystate = state as TestLoaded;
      
      final updatedQuestions = mystate.test.questions.map((q){
        if(q.id == event.que.id){
          return q.selectOption(event.optionSelected);
        }
        return q;
      }).toList();

      emit(TestLoaded(test: mystate.test.copyWith(updatedQuestions)));
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
        TestLoaded(test: mystate.test.copyWith(updatedQuestion))
      );
    },);


    on<TestSubmittedEvent>((event, emit) async{
      emit(TestSubmitting());
      final mystate = state as TestLoaded;
      final res = await TestRepo().uploadTest(mystate.test);
      if(res.statusCode != 200){
        emit(FailedToSubmitTest());
      }
      emit(TestSubmitted());
    },);


    on<TestTimeUp>((event, emit) {
       
    },);
  } 
}