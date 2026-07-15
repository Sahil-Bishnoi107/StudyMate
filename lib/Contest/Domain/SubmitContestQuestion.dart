class Submitcontestquestion {
  String questionId;
  int Answer;

  Submitcontestquestion({required this.questionId,required this.Answer});

  factory Submitcontestquestion.fromJson(Map<String,dynamic> mp){
    String id = mp['question_id'];
    int ans = mp['answer'];
    return Submitcontestquestion(questionId: id, Answer: ans);
  }

  Map<String,dynamic> toJson(){
    return {
      'question_id' : questionId,
      'answer' : Answer
    };
  }
}