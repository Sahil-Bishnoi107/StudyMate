import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/AboutUs/Presentation/Pages/AboutUsPage.dart';
import 'package:study_mate/Contest/Presentation/Pages/ContestPage.dart';
import 'package:study_mate/Home/Presentation/Pages/Homepage.dart';
import 'package:study_mate/Lectures/Presentation/Pages/LecturesPage.dart';
import 'package:study_mate/Profile/Presentation/Pages/ProfilePage.dart';
import 'package:study_mate/QuestionsSection/Presentation/Pages/FiltersPage.dart';
import 'package:study_mate/QuestionsSection/Presentation/Pages/MyQuestion.dart';
import 'package:study_mate/Settings/Presentation/Pages/SettingsPage.dart';
import 'package:study_mate/Subscriptions/Presentation/Pages/SubscriptionsPage.dart';
import 'package:study_mate/TestsPage/Presentation/Pages/testspage.dart';
import 'package:study_mate/fonts.dart';

Drawer mainDrawer(double height, double width,BuildContext context){
  const TextStyle ts = TextStyle(color: Colors.black,fontFamily: Fonts.outfit,fontSize: 16);
  return Drawer(
    backgroundColor: Colors.white,
        width: width*0.5,
        child: ListView(
          children: [
            DrawerHeader(
              
              child: Column(
                children: [
                 // SizedBox(height: height*0.05,),
                  Container(
                  
                  height: width*0.16,width: width*0.16,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(width*0.03),
                    border: Border.all()
                  ),
                  child: Icon(LucideIcons.zap400, color: Colors.white,size: 30,)),
                   SizedBox(height: height*0.01,),
                  Text("StudyMate",style: TextStyle(color: Colors.black,fontFamily: Fonts.outfit,fontSize: 18,fontWeight: FontWeight.w600),)
                ],
              )),


              //Options
              
              ListTile(
                leading: Icon(LucideIcons.userRound400Dir),
                title: const Text("Profile",style: ts),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage())),
              ),
              ListTile(
              leading: Icon(LucideIcons.house400Dir),
              title: const Text("Home",style: ts,),
              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage())); 
                },
              ),
              ListTile(
                leading: Icon(LucideIcons.file400Dir),
                title: const Text("Tests",style: ts,),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TestsPage())); 
                },
              ),
              ListTile(
                leading: Icon(LucideIcons.brain400Dir),
                title: const Text("Questions",style: ts,),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FiltersPage())),
              ),
              ListTile(
                leading: Icon(LucideIcons.notebookPen400Dir),
                title: const Text("My Questions",style: ts,),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyQuestion())),
              ),
              ListTile(
                leading: Icon(LucideIcons.swords400Dir),
                title: const Text("Contests",style: ts,),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ContestPage())),
              ),
              ListTile(
                leading: Icon(LucideIcons.monitorPlay400Dir),
                title: const Text("Lectures",style: ts,),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Lecturespage())),
              ),
              ListTile(
                leading: Icon(LucideIcons.crown400Dir),
                title: const Text("Subscription",style: ts,),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Subscriptionspage())),
              ),
              ListTile(
                leading: Icon(LucideIcons.circleHelp400Dir),
                title: const Text("Contact Us",style: ts,),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsPage())),
              ),
              ListTile(
                leading: Icon(LucideIcons.settings),
                title: const Text("Settings",style: ts,),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Settingspage())),
              ),
              
              
          ],
        ),
      );
}