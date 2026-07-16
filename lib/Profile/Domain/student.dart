import 'package:study_mate/Profile/Domain/Test.dart';

class Student {
  String id;
  String name;
  String pic;
  List<TestGiven> testsGiven;

  int rank;
  Student({required this.id,required this.name,required this.pic, required this.rank, required this.testsGiven});

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
    int rank = mp['rank'] ?? 0;
    return Student(id: id, name: name, pic: pic,  rank: rank, testsGiven: testsGiven);
  }
  
}
