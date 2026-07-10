class Questionfilters {
    List<Option> subjects;
    List<Option> difficulty;
    List<Option> examType;

    Questionfilters({required this.difficulty, required this.subjects, required this.examType});

    factory Questionfilters.initalize(){
      List<Option> subjects = [];
      List<Option> difficulty = [];
      List<Option> examType = [];

      List<String> sub = ["physics", "chemistry", "mathematics", "biology", "english", "geography"];
      List<String> diff = ["easy", "medium", "hard"];
      List<String> exam = ["Jee Mains", "Jee Advanced", "BITSAT", "VIEEE", "IISER SAT"];

      for(String s in sub){subjects.add(Option(s));}
      for(String s in diff){difficulty.add(Option(s));}
      for(String s in exam){examType.add(Option(s));}

      return Questionfilters(difficulty: difficulty, subjects: subjects, examType: examType);

    }
    
}

class Option {
   String filterName;
   bool isSelected = false;
   Option(this.filterName);

   void select(){isSelected = true;}
   void unselect(){isSelected = false;}
}