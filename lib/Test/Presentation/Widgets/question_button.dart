import 'package:flutter/material.dart';
import 'package:study_mate/fonts.dart';

Widget queButton(double height,double width,bool isnext){
  String txt = isnext ? "Next >" : "< Previous";
  return Container(
    height: height*0.06,width: width*0.4,
    decoration: BoxDecoration(
      color: isnext ? Colors.green : Colors.white,
      border: Border.all(color: isnext ? Colors.green : Colors.black),
      borderRadius: BorderRadius.circular(height*0.02),
    ),
    child: Text(txt,style: TextStyle(fontFamily: Fonts.nunito),),
  );
}