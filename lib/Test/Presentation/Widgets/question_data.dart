import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_mate/fonts.dart';

Widget QuestionData(double height, double width,String header,int stat,Color color,BuildContext context){
  return Column(
    children: [
     Text(header,style: TextStyle(color: const Color.fromRGBO(70, 70, 70, 1),fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 12)),),
     Text(stat.toString(), style: TextStyle(color: color,fontFamily: Fonts.inter,fontWeight: FontWeight.bold),)
    ],
  );
}