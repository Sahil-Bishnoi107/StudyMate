
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/QuestionsSection/Data/QuestionsRepo.dart';
import 'package:study_mate/QuestionsSection/Domain/QuestionFilters.dart';
import 'package:study_mate/QuestionsSection/Presentation/FiltersBloc/FilterEvents.dart';
import 'package:study_mate/QuestionsSection/Presentation/FiltersBloc/FilterStates.dart';

class FilterBloc extends Bloc<FilterEVents, FilterStates> {
  final QuestionsRepo repo;
  FilterBloc(this.repo) : super(InitialFiltersState(filters: Questionfilters.initalize())){
    on<FilterSelectEvent>(_filterSelected);
  }

  Future<void> _filterSelected(FilterSelectEvent event, Emitter<FilterStates> emit) async{
    
      final st = state as InitialFiltersState;
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
       
        emit(InitialFiltersState(filters: filters));
  }
}