import 'package:flutter/material.dart';

Widget questionIcon(double height,double width,bool isSelected,int index){
  return Container(
    height: height*0.02,width: width*0.04,
    decoration: BoxDecoration(
    color: isSelected ? Colors.green : Colors.white,
    border: Border.all(color: isSelected ? Colors.green : Colors.black)
    ),
    child: Center(
      child: Text(index.toString(),style: TextStyle(color: isSelected ? Colors.white : Colors.black),),
    ),
  );
}