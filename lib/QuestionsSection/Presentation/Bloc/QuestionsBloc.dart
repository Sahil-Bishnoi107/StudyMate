import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/QuestionsSection/Data/QuestionsRepo.dart';
import 'package:study_mate/QuestionsSection/Domain/QuestionFilters.dart';

import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsEvents.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsStates.dart';

class Questionsbloc extends Bloc<Questionsevents,Questionsstates> {
  final QuestionsRepo questionsRepo;
  Questionsbloc (this.questionsRepo) : super (QuestionsInitialState(filters: Questionfilters.initalize())){
    
  }
}