import 'package:flutter/material.dart';
import 'package:study_mate/fonts.dart';

Widget queButton(double height,double width,bool isnext,BuildContext context){
  String txt = isnext ? "Next >" : "< Previous";
  return Container(
    height: height*0.06,width: width*0.4,
    padding: isnext ? EdgeInsets.only(left: width*0.02) : EdgeInsets.only(right: width*0.02),
    decoration: BoxDecoration(
      color: isnext ? Colors.green : Colors.white,
      border: Border.all(color: isnext ? Colors.green : Colors.black),
    //  borderRadius: BorderRadius.circular(height*0.05),
    ),
    child: Center(child: Text(txt,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,color: isnext ?  Colors.white : Colors.black,fontSize: Responsive.font(context, 13)),)),
  );
}