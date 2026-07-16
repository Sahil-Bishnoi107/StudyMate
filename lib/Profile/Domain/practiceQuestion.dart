class PracticeUserQuestion {
  final String questionId;
  final String subject;
  final String difficulty;
  final bool isCorrect;
  final DateTime submittedAt;

  const PracticeUserQuestion({
    required this.questionId,
    required this.subject,
    required this.difficulty,
    required this.isCorrect,
    required this.submittedAt,
  });

  factory PracticeUserQuestion.fromJson(Map<String, dynamic> json) {
    return PracticeUserQuestion(
      questionId: json['question_id'] as String,
      subject: json['subject'] as String,
      difficulty: json['difficulty'] as String,
      isCorrect: json['is_correct'] as bool,
      submittedAt: DateTime.parse(json['submitted_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'subject': subject,
      'difficulty': difficulty,
      'is_correct': isCorrect,
      'submitted_at': submittedAt.toUtc().toIso8601String(),
    };
  }

  PracticeUserQuestion copyWith({
    String? questionId,
    String? subject,
    String? difficulty,
    bool? isCorrect,
    DateTime? submittedAt,
  }) {
    return PracticeUserQuestion(
      questionId: questionId ?? this.questionId,
      subject: subject ?? this.subject,
      difficulty: difficulty ?? this.difficulty,
      isCorrect: isCorrect ?? this.isCorrect,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }
}