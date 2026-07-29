import 'package:dio/dio.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Notifications/Domain/Notification.dart';

class Notificationdata {
  final Dio dio;
  Notificationdata(this.dio);

  Future<ApiResponse> loadNotifications() async{
    try{
    var res = await dio.get("/User/notifications");
    if(res.statusCode != 200){
      print("Couldnt fetch the notifications from the api with code ${res.statusCode}");
      return ApiResponse(statusCode: res.statusCode ?? 500);
    }

    var notiList = res.data;
    List<NotificationModel> notifications = [];

    for(var n in notiList){
     notifications.add(NotificationModel.toJson(n));
    }
    return ApiResponse(statusCode: 200,data: notifications);
    }
    catch(e){
      print("Exception occured during notifications $e");
      return ApiResponse(statusCode: 500);
    }
  }
}