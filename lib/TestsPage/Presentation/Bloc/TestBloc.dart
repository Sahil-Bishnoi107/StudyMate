import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/TestsPage/Data/testdata.dart';
import 'package:study_mate/TestsPage/Domain/entities/Test.dart';
import 'package:study_mate/TestsPage/Presentation/Bloc/TestEvents.dart';
import 'package:study_mate/TestsPage/Presentation/Bloc/TestStates.dart';

class TestPageBloc extends Bloc<TestPageevents,TestPagestates>{
  final TestPageData testPageRepo;
  TestPageBloc(this.testPageRepo) : super(LoadingTestPageState()){
    


    on<TestsDataLoaded>((event, emit) async{
      ApiResponse res = await testPageRepo.testPageData();
      if(res.statusCode != 200){emit(FailureTestPageState(error: "Could Not Load Tests"));}
      emit(LoadedTestPageState(tests: res.data, filteredTests: res.data,slectedFilter: 0));
    },);

    on<FilterTests>((event, emit) {
      List<TestInfo> ourList = [];
      final currState = state as LoadedTestPageState;
      if(event.filter == 0){
        ourList = currState.tests;
      }
     else{ for(var test in currState.tests){
        if(test.subject.toLowerCase() == currState.filters[event.filter]){
          ourList.add(test);
        }
      }}
      emit(LoadedTestPageState(tests: currState.tests, filteredTests: ourList,slectedFilter: event.filter));
    },);

    add(TestsDataLoaded());
  }
}