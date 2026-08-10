import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:study_mate/Notifications/Domain/Notification.dart';
import 'package:study_mate/fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget NotificationTile(double height, double width,NotificationModel noti,BuildContext context){
  final now = DateTime.now();
  String day = DateFormat('EEEE').format(noti.date);
  String date = now.difference(noti.date).inDays > 7 ? DateFormat('dd MMM yyyy').format(noti.date) : timeago.format(noti.date);
  return Container(
  height: height*0.07,width: width,
  decoration: BoxDecoration(color: const Color.fromRGBO(76, 175, 80, 0.04)),
  margin: EdgeInsets.symmetric(horizontal: width*0.05),
  padding: EdgeInsets.symmetric(horizontal: width*0.01,vertical: height*0.005),
  child: Row(
    children: [
      
      Column(
        children: [
          SizedBox(
            height: height*0.03,width: width*0.85,
            child: Text(noti.message,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 14)))),
          SizedBox(
            width: width*0.85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("$day,",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10))),
                Text(date,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10)))
              ],
            ),
          )
        ],
      )
    ],
  ),
  );
}