class Question{
  String id;
  String description;
  String subject;
  List<String> options;
  String correctOption;
  String? selectedOption;
  String difficulty;

  Question({required this.id,required this.description,required this.subject,required this.correctOption,required this.difficulty,required this.options});

  factory Question.fromJson(Map<String,dynamic> mp){
    List<String> options = [];
    if(mp.containsKey('options')){
      for(var x in mp['options'] as List<String>){
        options.add(x);
      }
    }
    String id = mp['id'] ?? "id not found";
    String description = mp['description'] ?? "Question not found";
    String subject = mp['subject'] ?? "No Subject";
    String correctOption = mp['correct_option'] ?? "Unknown Option";
    String difficulty = mp['difficulty'] ?? "not known";
    return Question(id: id, description: description, subject: subject, correctOption: correctOption, difficulty: difficulty, options: options);
  }


  Question selectOption(String selectedOption)
  {
    return Question(id: id, description: description, subject: subject, correctOption: correctOption, difficulty: difficulty, options: options)
                   ..selectedOption = selectedOption;
  }

  Question unselectOption(){
    return Question(id: id, description: description, subject: subject, correctOption: correctOption, difficulty: difficulty, options: options)
                    ..selectedOption = null;
  }
}