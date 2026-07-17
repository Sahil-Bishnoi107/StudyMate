import 'package:flutter/material.dart';

class Lecturespage extends StatefulWidget {
  const Lecturespage({super.key});

  @override
  State<Lecturespage> createState() => _LecturespageState();
}

class _LecturespageState extends State<Lecturespage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Container(height:height,width: width,
           child: Center(child: Text("Video Lectures Will be available soon"),),)
        ],
      ),
    );
  }
}