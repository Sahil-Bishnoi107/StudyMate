class NotificationModel {
  String message;
  DateTime date;

  NotificationModel({required this.date,required this.message});

  factory NotificationModel.toJson(Map<String,dynamic> mp){
    String m = mp["message"] ?? "?????";
    DateTime dt = mp.containsKey('sent_at') ? DateTime.parse(mp["sent_at"]) : DateTime.now();
    return NotificationModel(date: dt, message: m);
  }

}