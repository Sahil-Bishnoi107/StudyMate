import 'package:study_mate/Home/Domain/Entities/Test.dart';

class Student {
  String id;
  String name;
  String pic;
  int attemptedQuestions;
  int correctQuestions;
  List<TestGiven> testsGiven;

  int rank;
  Student({required this.id,required this.name,required this.pic,required this.attemptedQuestions, required this.correctQuestions, required this.rank, required this.testsGiven});

  factory Student.fromJson(Map<String,dynamic> mp){
    List<TestGiven> testsGiven = [];
    if(mp.containsKey('tests_given')){
      for(var z in mp['tests_given']){
        TestGiven testGiven = TestGiven.fromJson(z);
        testsGiven.add(testGiven);
      }
    }
    String id = mp['id'] ?? "id not found";
    String name = mp['name'] ?? "A man with no name";
    String pic = mp['profile_pic'] ?? "A man has no face";
    int attemptedQuestions = mp['attempted_questions'] ?? 0;
    int correctQuestions = mp['correct_questions'] ?? 0;
    int rank = mp['rank'] ?? 0;
    return Student(id: id, name: name, pic: pic, attemptedQuestions: attemptedQuestions, correctQuestions: correctQuestions, rank: rank, testsGiven: testsGiven);
  }
  
}
