class Contest {
  String contestId;
  String contestName;
  DateTime startTime;
  int duration;
  String difficulty;
  int status;
  String subject;
  int participants;
  int negativeMarking;
  int marksPerQuestion;

  Contest({
    required this.contestId,
    required this.contestName,
    required this.startTime,
    required this.duration,
    required this.difficulty,
    required this.status,
    required this.subject,
    required this.participants,
    required this.negativeMarking,
    required this.marksPerQuestion,
  });

  factory Contest.fromJson(Map<String, dynamic> json) {
    return Contest(
      contestId: json["contest_id"],
      contestName: json["contest_name"],
      startTime: DateTime.parse(json["start_time"]),
      duration: json["duration"],
      difficulty: json["difficulty"],
      status: json["status"],
      subject: json["subject"],
      participants: json["participants"],
      negativeMarking: json["negative_marking"],
      marksPerQuestion: json["marks_per_question"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "contest_id": contestId,
      "contest_name": contestName,
      "start_time": startTime.toUtc().toIso8601String(),
      "duration": duration,
      "difficulty": difficulty,
      "status": status,
      "subject": subject,
      "participants": participants,
      "negative_marking": negativeMarking,
      "marks_per_question": marksPerQuestion,
    };
  }
}