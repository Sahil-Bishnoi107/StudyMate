import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
import 'package:study_mate/Notifications/Domain/Notification.dart';
import 'package:study_mate/Notifications/Presentation/Bloc/NotificationBloc.dart';
import 'package:study_mate/Notifications/Presentation/Bloc/NotificationEvents.dart';
import 'package:study_mate/Notifications/Presentation/Bloc/NotificationStates.dart';
import 'package:study_mate/Notifications/Presentation/Widgets/NotificationTile.dart';
import 'package:study_mate/fonts.dart';

class Notificationpage extends StatefulWidget {
  const Notificationpage({super.key});

  @override
  State<Notificationpage> createState() => _NotificationpageState();
}

class _NotificationpageState extends State<Notificationpage> {

  @override 
  void initState() {
    
    super.initState();
    BlocProvider.of<NotificationBloc>(context).add(LoadNotificationEvent());
  }
  @override
  Widget build(BuildContext context) {
   double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _header(height, width, context),
            Container(width: width*0.9, height: 1.5,color: const Color.fromRGBO(220, 220, 220, 0.8),),
            BlocBuilder<NotificationBloc,Notificationstate>(
              builder: (context, state) {
                
                if(state is LoadingNotificationState){
                  return SizedBox(
                    height: height*0.8,width: width,
                    child: Center(child: LoadingLogo()),
                  );
                }

                if(state is LoadedNotificationState){
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: height*0.01,),
                        _listNoti(height, width,state.notifications ,context)
                      ],
                    ),
                  )
                  );
                }

                
                  return SizedBox(
                    height: height*0.8,width: width,
                    child: Center(child: Text("Failed to Load Data",style: TextStyle(color: Colors.red),))
                  );
                
              },)
          ],
        ),
      ),
    );
  }
}

Widget _header(double height,double width,BuildContext context){
  return SizedBox(
    height: height*0.05,
    width: width,
    child: Row(
      children: [
        SizedBox(width: width*0.03,),
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(LucideIcons.chevronLeft300Dir,size: Responsive.icon(context, 30),),
        ),
        SizedBox(width: width*0.03,),
        Text("Notifications",style: TextStyle(fontFamily: Fonts.outfit, fontSize: Responsive.font(context, 18),fontWeight: FontWeight.w400),)
      ],
    ),
  );
}

Widget _listNoti(double height, double width, List<NotificationModel> notis,BuildContext context){
  return SizedBox(
    height: height*0.8,width: width,
    child: ListView.builder(
      itemCount: notis.length,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return NotificationTile(height, width, notis[index],context);
      },
     ),
  );
}