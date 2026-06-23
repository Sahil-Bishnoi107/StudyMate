import 'package:study_mate/Home/Domain/Entities/Question.dart';

class TestGiven {
  String id;
  String name;
  int totalQuestions;
  int correctQuestions;
  String status;
  String givenAt;
  String subject;
  List<Question> questions;
  int time;
  TestGiven({required this.id,required this.name,required this.totalQuestions,required this.correctQuestions,required this.subject,required this.givenAt,required this.questions,required this.status,required this.time});

  factory TestGiven.fromJson(Map<String,dynamic> mp){
    List<Question> questions = [];
    if(mp.containsKey('questions')){
      for(var q in mp['questions']){
        Question que = Question.fromJson(q);
        questions.add(que);
      }
    }
    String id = mp['id'] ?? "No id found";
    String name = mp['name'] ?? "No name found";
    int totalQuestions = mp['total_questions']  ?? 0;
    int correctQuestions = mp['correct_questions'] ?? 0;
    bool status = mp['status'] ?? "Not Known";
    String givenAt = mp['given_at'] ?? DateTime(2027, 3, 14, 18, 45, 22);
    String subject = mp['subject'] ?? "Unknown";
    int time = mp['time'] ?? 0;
    return TestGiven(id: id, name: name, totalQuestions: totalQuestions, correctQuestions: correctQuestions, subject: subject, givenAt: givenAt, questions: questions, status: status ? "Passed" : "Failed", time: time);
  }
}