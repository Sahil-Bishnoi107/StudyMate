import 'package:flutter/material.dart';
import 'package:study_mate/fonts.dart';

Widget QuestionOption(String option,double height,double width,bool isSelected){
  return Container(
    height: height*0.05,width: width*0.9,
    child: Text(option,style: TextStyle(fontFamily: Fonts.nunito,color: isSelected ? Colors.green : Colors.black),),
  );
}