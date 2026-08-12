

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/AboutUs/Presentation/Pages/AboutUsPage.dart';


import 'package:study_mate/Contest/Presentation/Pages/ContestPage.dart';
import 'package:study_mate/Home/Presentation/Widgets/drawer.dart';
import 'package:study_mate/Notifications/Presentation/Pages/NotificationPage.dart';
import 'package:study_mate/QuestionsSection/Presentation/Pages/FiltersPage.dart';
import 'package:study_mate/Subscriptions/Presentation/Pages/SubscriptionsPage.dart';
import 'package:study_mate/fonts.dart';
import 'package:study_mate/Home/Presentation/Widgets/animated_texts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: mainDrawer(height, width, context),
      body: Column(
        children: [
          SizedBox(height: height*0.05,),
          _appBar(height, width, _scaffoldKey,context),
          Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,width: width,),
          Expanded(
            child: SingleChildScrollView(
              child: Column( 
                children: [
              SizedBox(height: height*0.02,),
              _header(height, width,context),
              SizedBox(height: height*0.01,),
              _aboutSection(height, width,context),
              SizedBox(height: height*0.01,),
              GestureDetector( onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContestPage())),
                child: _card(height, width, LucideIcons.swords300, "Challenge yourself with timed mock contests designed to simulate real exam pressure. Track your rating, climb the leaderboard, analyze your performance, and see how you compare with other aspirants.",
                 "Ready to", "Compete?",40, context),
              ),
               SizedBox(height: height*0.02,),
              GestureDetector( onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FiltersPage())),
                child: _card(height, width, LucideIcons.gauge300, "Strengthen your concepts one question at a time. Solve curated problems across Physics, Chemistry, and Mathematics, learn from your mistakes, and build confidence through consistent practice.",
                 "Practice", "Without Limits",40, context),
              ),
               SizedBox(height: height*0.02,),
               InkWell(
                onTap: () {
                   _snakcBar(height, width, context);
                },
                 child: _card(height, width, LucideIcons.chartColumn300, "Analyze your performance with detailed analytics and identify your strengths and weaknesses.",
                 "Track Your", "Progress",40, context),
               ),
               SizedBox(height: height*0.02,),
               _premiumCard(height, width,context),
               SizedBox(height: height*0.1,)
                ],
              ),
            ),
          )
          
          
        ],
      ),
    );
  }
}

Widget _appBar(double height, double width,GlobalKey<ScaffoldState> key,BuildContext context){
  
 return SizedBox(
  height: height*0.05,width: width,
  child: Row(
    children: [
      SizedBox(width: width*0.05,),
      InkWell(
        onTap: () => key.currentState?.openDrawer(),
        child: Icon(Icons.menu_sharp,size: Responsive.icon(context, 30),)),
      SizedBox(width: width*0.05,),
      Expanded(child: Text("StudyMate",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 18),fontWeight: FontWeight.w600),)),
      InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Notificationpage())),
        child: Icon(Icons.notifications_none_sharp)),
      SizedBox(width: width*0.05,)
    ],
  ),
 );
}

Widget _header(double height,double width,BuildContext context){

  return Container(

    height: height*0.22,width: width,
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TypingText(text: "Master",style: TextStyle(color: Colors.black, fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 40),fontWeight: FontWeight.w600),),
        TypingText(text: "Your",style: TextStyle(color: Colors.green, fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 40),fontWeight: FontWeight.w600), delay: const Duration(milliseconds: 315),),
        Row(
          children: [
            TypingText(text: "Potential",style: TextStyle(color: Colors.black, fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 40),fontWeight: FontWeight.w600), delay: const Duration(milliseconds: 540),),
            TypingText(text: ".",style: TextStyle(color: Colors.green, fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 40),fontWeight: FontWeight.w600), delay: const Duration(milliseconds: 900),)
          ],
        ),
        SizedBox(height: 10,),
        SizedBox(
          height: height*0.018,
          child: ScrambleText(text: "Where Preperation meets progress",style: TextStyle(color: const Color.fromRGBO(110, 110, 110, 1), fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10)), delay: const Duration(milliseconds: 1000), duration: const Duration(milliseconds: 1000),)),
        SizedBox(
          height: height*0.02,
          child: ScrambleText(text: "The Journey to AIR begins here",style: TextStyle(color: const Color.fromRGBO(110, 110, 110, 1), fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10)), delay: const Duration(milliseconds: 2000), duration: const Duration(milliseconds: 1000),)),
      ],
    ),
  );
}

Widget _aboutSection(double height, double width,BuildContext context){
  return Container(
    height: height*0.18,
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
         "Preparing The Future",
        style: TextStyle(color: Colors.black,fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 24),fontWeight: FontWeight.w600)
      ),
      Row(
        children: [
          Text( "Engineers ",style: TextStyle(color: Colors.green,fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 24),fontWeight: FontWeight.w600)),
          Text( "And",style: TextStyle(color: Colors.black,fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 24),fontWeight: FontWeight.w600)),
          Text( " Doctors.",style: TextStyle(color: Colors.green,fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 24),fontWeight: FontWeight.w600)),
        ],
      ),
      SizedBox(height: height*0.005,),
      Text(
       "We offer comprehensive JEE and NEET coaching with experienced teachers, concept-focused classes, regular practice sessions, mock examinations, and continuous academic support to help every student reach their full potential. To be a part of our real life classes click here",
        style: TextStyle(fontFamily: Fonts.outfit,color: Colors.black,fontSize: Responsive.font(context, 10)),

      ),
      Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AboutUsPage())),
            child: Text("Contact Us", style: TextStyle(color: Colors.green,fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 11)),)),
          Icon(Icons.arrow_forward_ios_sharp,size: Responsive.icon(context, 10),color: Colors.green,)
        ],
      )
    ],),
  );
}

Widget _card(double height, double width,IconData icon,String text,String header1,String header2,int iconSize, BuildContext context){
  return Container(
    height: height*0.1,
    margin: EdgeInsets.symmetric(horizontal: width*0.05),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),
      borderRadius: BorderRadius.circular(10)
    ),
    child: Row(
      children: [
       SizedBox(width: width*0.03,),

       Container(height: height*0.08,width: height*0.08, 
       decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(76, 175, 80, 0.75)),
        borderRadius: BorderRadius.circular(10)
        ),
        child: Icon(icon,size: Responsive.icon(context, iconSize.toDouble()),color: Colors.green,),
       ),


       SizedBox(width: width*0.035,),
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height*0.006,),
          Row(children: [
            Text(header1,style: TextStyle(fontFamily: Fonts.outfit,color: Colors.black,fontWeight: FontWeight.w600),),
            Text( " $header2",style: TextStyle(fontFamily: Fonts.outfit,color: Colors.green,fontWeight: FontWeight.w600),)
          ],),
          //SizedBox(height: height*0.01,),
          SizedBox(
            width: width*0.6,
            child: Text(text,style: TextStyle(fontFamily: Fonts.outfit, color: const Color.fromRGBO(110, 110, 110, 1),fontSize: Responsive.font(context, 8)),))
        ],
       ),

       SizedBox(width: width*0.01,),
      // Icon(Icons.arrow_forward_ios,size: Responsive.icon(context, 30),color: Colors.green,)
      ],
    ),
  );
}


Widget _premiumCard(double height, double width,BuildContext context){
  return Container(
    height: height*0.15,
    margin: EdgeInsets.symmetric(horizontal: width*0.05),
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),
      borderRadius: BorderRadius.circular(10)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        SizedBox(height: height*0.01,),
        Row(
          children: [
            Text("Go ",style: TextStyle(color: Colors.black, fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 20)),),
             Text("Beyond ",style: TextStyle(color: Colors.green, fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 20)),),
              Text("Practice",style: TextStyle(color: Colors.black, fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 20)),),
               Text(".",style: TextStyle(color: Colors.green, fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 20)),),
          ],
        ),
        Text("Premium gives you everything you need to study smarter, improve faster, and stay ahead of the competition.",
        style: TextStyle(color: Colors.black, fontSize: Responsive.font(context, 10),fontFamily: Fonts.outfit),
        ),
        SizedBox(height: height*0.01,),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Subscriptionspage())),
          child: Container(
            height: height*0.045,width: width*0.8,
            
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(50)
            ),
            child: Center(child: Text("Explore Subscriptions",style: TextStyle(color: Colors.white,fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 14),fontWeight: FontWeight.w600),),),
          ),
        )
       ],
    ),
  );
}


ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _snakcBar(double height, double width, BuildContext context){
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Analythics are not availabe in this version of the app. They will be soon availabe!",
    style: TextStyle(fontFamily: Fonts.outfit, fontSize: Responsive.font(context, 12)),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.green,
    ));
}