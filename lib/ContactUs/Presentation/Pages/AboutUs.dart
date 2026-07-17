import 'package:flutter/material.dart';

class Aboutus extends StatelessWidget {
  const Aboutus({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Container(height:height,width: width, child: Center(child: Text("About uS PAGE WILL BE AVAILABLE SOON."),),)
        ],
      ),
    );
  }
}