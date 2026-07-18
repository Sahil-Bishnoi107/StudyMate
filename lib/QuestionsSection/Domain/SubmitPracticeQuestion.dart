class Submitpracticequestion {
  String Id;
  String Subject;
  String difficulty;
  bool isCorrect;

  Submitpracticequestion({required this.Id,required this.Subject,required this.difficulty,required this.isCorrect});

  Map<String,dynamic> toJson(){
    return {
      "question_id" : Id,
      "subject" : Subject,
      "difficulty" : difficulty,
      "is_correct" : isCorrect
    };
  }
}