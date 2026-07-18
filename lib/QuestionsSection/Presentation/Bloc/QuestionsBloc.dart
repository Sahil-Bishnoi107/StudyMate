import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/QuestionsSection/Data/QuestionsRepo.dart';
import 'package:study_mate/QuestionsSection/Domain/Collection.dart';
import 'package:study_mate/QuestionsSection/Domain/QuestionFilters.dart';
import 'package:study_mate/QuestionsSection/Domain/SubmitPracticeQuestion.dart';

import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsEvents.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsStates.dart';

class Questionsbloc extends Bloc<Questionsevents,Questionsstates> {
  final QuestionsRepo questionsRepo;
  Questionsbloc (this.questionsRepo) : super (QuestionsInitialState(filters: Questionfilters.initalize())){

    on<FilterSelectEvent>(_onFilterSelectEvent);
    on<SearchQuestions> (_onSearchQuestions);
    on<ResetFiltersEvent>(_onResetFilters);
    on<NextQuestionEvent>(_onNextQuestion);
    on<AnswerQuestion>(_onAnswerQuestion);
    on<SubmitQuestionEvent>(_submitQuestion);
    on<UpdateCollectionsEvent>(_onUpdateCollectionsEvent);
  }




  void _onFilterSelectEvent(FilterSelectEvent event, Emitter<Questionsstates> emit){
           if(state is! QuestionsInitialState){print("State in not correct for picking filters");return;}
      final st = state as QuestionsInitialState;
      Questionfilters filters = st.filters;

      if(event.filterNumber == 0){
        bool isSelected =filters.subjects[event.selectedIndex].isSelected ;
        if(isSelected) {filters.subjects[event.selectedIndex].unselect();}
        else{filters.subjects[event.selectedIndex].select();}
        }
      if(event.filterNumber == 1){
        bool isSelected =filters.examType[event.selectedIndex].isSelected ;
        if(isSelected) {filters.examType[event.selectedIndex].unselect();}
        else{filters.examType[event.selectedIndex].select();}
        }
       if(event.filterNumber == 2){
        bool isSelected = filters.difficulty[event.selectedIndex].isSelected ;
        if(isSelected) {filters.difficulty[event.selectedIndex].unselect();}
        else{filters.difficulty[event.selectedIndex].select();}
        }
       
        emit(QuestionsInitialState(filters: filters));
  }

  void _onSearchQuestions(SearchQuestions event, Emitter<Questionsstates> emit) async{
    Questionfilters questionfilters;
    List<Collection> collections = [];
    bool loadCollections = false;
    if(state is QuestionsInitialState){final st = state as QuestionsInitialState; questionfilters = st.filters; loadCollections = true;}
    else {final st = state as LoadQuestionsState; questionfilters = st.filters; collections = st.collections;}

    if(loadCollections){emit(FetchingQuestionsState());}
    List<String> subjects = []; List<String> exams = []; List<String> difficulties = [];
    for(Option op in questionfilters.subjects){if(op.isSelected){subjects.add(op.filterName);}}
    for(Option op in questionfilters.difficulty){if(op.isSelected){difficulties.add(op.filterName);}}
    for(Option op in questionfilters.examType){if(op.isSelected){exams.add(op.filterName);}}

    if(subjects.isEmpty || exams.isEmpty || difficulties.isEmpty){
      emit(QuestionFetchFailed("Select One option at least in each filter"));
       emit(QuestionsInitialState(filters: questionfilters));
       return;
       }
    
    ApiResponse quesRes = await questionsRepo.GetQuestions(subjects, difficulties, exams);
    if(quesRes.statusCode != 200){
      emit(QuestionFetchFailed("Questions could not be loaded from API"));
      emit(QuestionsInitialState(filters: questionfilters));
      return;
    }
    
    
    if(loadCollections){
    ApiResponse collectionsRes = await questionsRepo.LoadMyCollections();
    if(collectionsRes.statusCode != 200){
      emit(QuestionFetchFailed("Collections could not be loaded from API"));
      emit(QuestionsInitialState(filters: questionfilters));
      return;
    }
    collections = collectionsRes.data;
    }
    emit(LoadQuestionsState(collections: collections, filters: questionfilters, questions: quesRes.data, currInd: 0));
      
  }

  void _onResetFilters(ResetFiltersEvent event, Emitter<Questionsstates> emit) {
    emit(QuestionsInitialState(filters: Questionfilters.initalize()));
  }

  void _onNextQuestion(NextQuestionEvent event, Emitter<Questionsstates> emit) {
    if (state is LoadQuestionsState) {
      final st = state as LoadQuestionsState;
      if (st.currInd < st.questions.length - 1) {
        emit(LoadQuestionsState(
            collections: st.collections,
            filters: st.filters,
            questions: st.questions,
            currInd: st.currInd + 1));
      } else {
        add(SearchQuestions());
      }
    }
  }

  void _onAnswerQuestion(AnswerQuestion event, Emitter<Questionsstates> emit) async {
    if (state is LoadQuestionsState) {
      final st = state as LoadQuestionsState;
      try {
        ApiResponse res = await questionsRepo.SumbitQuestion(st.questions[st.currInd]);
        if (res.statusCode != 200) {
          emit(QuestionSubmitFailedState("Failed to submit question."));
          emit(LoadQuestionsState(
              collections: st.collections,
              filters: st.filters,
              questions: st.questions,
              currInd: st.currInd));
        }
      } catch (e) {
        emit(QuestionSubmitFailedState("Failed to submit question."));
        emit(LoadQuestionsState(
            collections: st.collections,
            filters: st.filters,
            questions: st.questions,
            currInd: st.currInd));
      }
    }
  }

  void _submitQuestion(SubmitQuestionEvent event , Emitter<Questionsstates> emit)async{
    Submitpracticequestion que =  Submitpracticequestion(Id: event.id, Subject: event.Subject, difficulty: event.difficulty, isCorrect: event.isTrue);
     await questionsRepo.SaveQuestion(que);
  }

  void _onUpdateCollectionsEvent(UpdateCollectionsEvent event, Emitter<Questionsstates> emit)async{
    var res = await questionsRepo.LoadMyCollections();
    if(res.statusCode != 200)return;
    if(state is! LoadQuestionsState)return;
    final mystate = state as LoadQuestionsState;
    List<Collection> cols = res.data;
    emit(LoadQuestionsState(collections: cols, filters: mystate.filters, questions: mystate.questions, currInd: mystate.currInd));
  }
}
