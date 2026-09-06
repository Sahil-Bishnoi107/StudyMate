import 'package:study_mate/Home/Domain/Entities/Question.dart';

class Test {
  String id;
  String name;
  int totalQuestions;
  String subject;
  int time;
  String diffiucluty;
  List<Question> questions;

  Test({required this.id,required this.name,required this.totalQuestions,required this.time,required this.subject,required this.diffiucluty,required this.questions});

  factory Test.fromJson(Map<String,dynamic> mp){
    List<Question> questions = [];
    
    if(mp.containsKey("questions")){
      for(var que in mp['questions']){
        questions.add(Question.fromJson(que));
      }
     
    }
    questions.sort((a, b) => a.subject.compareTo(b.subject),);
    print(questions);
    String id = mp['id'] ?? "No id found";
    String name = mp['name'] ?? "No name found";
    int totalQuestions = mp['total_questions']  ?? 0;
    String subject = mp['subject'] ?? "Unknown";
    int time = mp['time'] ?? 0;
    String diffiucluty = mp['difficulty'] ?? "easy";
    return Test(id: id, name: name, totalQuestions: totalQuestions, time: time, subject: subject, diffiucluty: diffiucluty, questions: questions);
  }

  Test copyWith(List<Question> ques){
    return Test(id: id, name: name, totalQuestions: totalQuestions, time: time, subject: subject, diffiucluty: diffiucluty, questions: ques);
  }

  Map<String, dynamic> toJson() {
  return {
    'id': id,
    'name': name,
    'total_questions': totalQuestions,
    'subject': subject,
    'time': time,
    'difficulty': diffiucluty,
    'questions': questions.map((q) => q.toJson()).toList(),
    
  };
}
}