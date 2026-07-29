import 'package:study_mate/Notifications/Domain/Notification.dart';

class Notificationstate {}

class InitialNotificationState extends Notificationstate{}

class LoadingNotificationState extends Notificationstate{}
class LoadedNotificationState extends Notificationstate{
  List<NotificationModel> notifications;
  LoadedNotificationState({required this.notifications});
}
class ErrorNotificationState extends Notificationstate{}