class ContestResult {
  String contestId;
  int rank;
  int prevRating;
  int newRating;
  int score;
  String contestName;
  DateTime startTime;
  int duration;
  String difficulty;

  ContestResult({
    required this.contestId,
    required this.rank,
    required this.prevRating,
    required this.newRating,
    required this.score,
    required this.contestName,
    required this.startTime,
    required this.duration,
    required this.difficulty,
  });

  factory ContestResult.fromJson(Map<String, dynamic> json) {
    return ContestResult(
      contestId: json["contest_id"],
      rank: json["rank"],
      prevRating: json["prev_rating"],
      newRating: json["new_rating"],
      score: json["score"],
      contestName: json["contest_name"],
      startTime: DateTime.parse(json["start_time"]),
      duration: json["duration"],
      difficulty: json["difficulty"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "contest_id": contestId,
      "rank": rank,
      "prev_rating": prevRating,
      "new_rating": newRating,
      "score": score,
      "contest_name": contestName,
      "start_time": startTime.toUtc().toIso8601String(),
      "duration": duration,
      "difficulty": difficulty,
    };
  }
}