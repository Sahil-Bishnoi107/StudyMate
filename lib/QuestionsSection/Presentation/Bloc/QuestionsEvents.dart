class Questionsevents {}

class FilterSelectEvent extends Questionsevents{
  int filterNumber;
  int selectedIndex;
  FilterSelectEvent({required this.filterNumber,required this.selectedIndex});
}

class SearchQuestions extends Questionsevents{}

class AnswerQuestion extends Questionsevents {
  String option;
  AnswerQuestion({required this.option});
}

class ResetFiltersEvent extends Questionsevents {}

class NextQuestionEvent extends Questionsevents {}