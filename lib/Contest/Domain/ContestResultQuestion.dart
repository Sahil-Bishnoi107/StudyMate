class ContestResultQuestion {
  String questionId;
  String contestId;
  String description;
  String subject;
  String difficulty;
  String optionA;
  String optionB;
  String optionC;
  String optionD;
  int? userAnswer;
  int correctAnswer;
  bool isCorrect;

  ContestResultQuestion({
    required this.questionId,
    required this.contestId,
    required this.description,
    required this.subject,
    required this.difficulty,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });

  factory ContestResultQuestion.fromJson(Map<String, dynamic> json) {
    return ContestResultQuestion(
      questionId: json["question_id"],
      contestId: json["contest_id"],
      description: json["description"],
      subject: json["subject"],
      difficulty: json["difficulty"],
      optionA: json["option_a"],
      optionB: json["option_b"],
      optionC: json["option_c"],
      optionD: json["option_d"],
      userAnswer: json["user_answer"],
      correctAnswer: json["correct_answer"],
      isCorrect: json["is_correct"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question_id": questionId,
      "contest_id": contestId,
      "description": description,
      "subject": subject,
      "difficulty": difficulty,
      "option_a": optionA,
      "option_b": optionB,
      "option_c": optionC,
      "option_d": optionD,
      "user_answer": userAnswer,
      "correct_answer": correctAnswer,
      "is_correct": isCorrect,
    };
  }
}