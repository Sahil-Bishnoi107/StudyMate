import 'package:study_mate/QuestionsSection/Domain/QuestionFilters.dart';

sealed class FilterStates {}

class InitialFiltersState extends FilterStates{
  Questionfilters filters;
  InitialFiltersState({required this.filters});

  
}