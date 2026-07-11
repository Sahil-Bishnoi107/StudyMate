import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/Home/Presentation/Pages/Homepage.dart';
import 'package:study_mate/QuestionsSection/Presentation/Pages/FiltersPage.dart';
import 'package:study_mate/TestsPage/Presentation/Pages/testspage.dart';

Drawer mainDrawer(double height, double width,BuildContext context){
  return Drawer(
        width: width*0.5,
        child: ListView(
          children: [
            DrawerHeader(
              
              child: Container(
              height: height*0.1,width: width*0.01,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width*0.03),
                border: Border.all()
              ),
              child: Icon(Icons.person))),

              ListTile(
              leading: Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage())); 
                },
              ),
              ListTile(
                leading: Icon(Bootstrap.book_fill),
                title: const Text("Tests"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TestsPage())); 
                },
              ),
              ListTile(
                leading: Icon(Bootstrap.question),
                title: const Text("Questions"),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FiltersPage())),
              )
          ],
        ),
      );
}