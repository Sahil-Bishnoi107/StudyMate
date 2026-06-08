import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Test/Presentation/Bloc/testevents.dart';
import 'package:study_mate/Test/Presentation/Bloc/teststates.dart';

class TestBloc extends Bloc<Testevents,Teststates> {
  TestBloc() : super(TestLoading()){
    on<TestLoadingComplete>((event, emit) {
      
    },);


    on<TestOptionSelected>((event, emit) {
      
    },);


    on<TestOptionCleared>((event, emit) {
      
    },);


    on<TestSubmittedEvent>((event, emit) {
      
    },);


    on<TestTimeUp>((event, emit) {
      
    },);
  } 
}