

class TestInfo{
  String id;
  String name;
  int totalQuestions;
  String status;
  String subject;
  int time;
  String diffiucluty;
  TestInfo({required this.id,required this.name,required this.totalQuestions,required this.subject,required this.status,required this.time,required this.diffiucluty});
  
    factory TestInfo.fromJson(Map<String,dynamic> mp){
  
    String id = mp['id'] ?? "No id found";
    String name = mp['name'] ?? "No name found";
    int totalQuestions = mp['total_questions']  ?? 0;
    
    String status = mp['status'] ?? "Not Known";
    
    String subject = mp['subject'] ?? "Unknown";
    int time = mp['time'] ?? 0;
    String diffiucluty = mp['difficulty'] ?? "easy";
    return TestInfo(id: id, name: name, totalQuestions: totalQuestions, subject: subject, status: status, time: time,diffiucluty: diffiucluty);
  }
}