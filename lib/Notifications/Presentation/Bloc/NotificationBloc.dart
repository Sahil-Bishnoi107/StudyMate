import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Notifications/Data/NotificationData.dart';
import 'package:study_mate/Notifications/Presentation/Bloc/NotificationEvents.dart';
import 'package:study_mate/Notifications/Presentation/Bloc/NotificationStates.dart';

class NotificationBloc extends Bloc<NotificationEvent,Notificationstate> {
  final Notificationdata repo;
  NotificationBloc(this.repo) : super(InitialNotificationState()){
    on<LoadNotificationEvent>(_LoadNotificationHandler);
  }

  Future<void> _LoadNotificationHandler(LoadNotificationEvent event, Emitter<Notificationstate> emit) async {
   emit(LoadingNotificationState());
   ApiResponse res = await repo.loadNotifications();
   if(res.statusCode != 200){
    emit(ErrorNotificationState());
    return;
   }
   emit(LoadedNotificationState(notifications: res.data));
  }
}