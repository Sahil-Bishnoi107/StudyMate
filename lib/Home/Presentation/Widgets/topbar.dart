import 'package:flutter/material.dart';
import 'package:study_mate/fonts.dart';

class Topbar extends StatefulWidget {
  const Topbar({super.key});

  @override
  State<Topbar> createState() => _TopbarState();
}

class _TopbarState extends State<Topbar> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: height*0.04),
      width: width,
      height: height*0.11,
      child: Row(
        children: [
         SizedBox(width: width*0.06,),
         GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Icon(Icons.menu,size: height*0.03,)),
         Expanded(child: Center(child: Text("Study Mate",style: TextStyle(fontFamily: Fonts.nunito,fontSize: 22,fontWeight: FontWeight.bold),))),
         SizedBox(width: width*0.2,),
        ],
      ),
    );
  }
}