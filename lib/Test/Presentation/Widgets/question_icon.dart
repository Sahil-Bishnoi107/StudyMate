import 'package:flutter/material.dart';

Widget questionIcon(double height,double width,bool isSelected,int index){
  return Align(
    alignment: Alignment.center,
    child: Container(
      height: height*0.035,width: height*0.035,
      margin: EdgeInsets.only(right: width*0.01),
      decoration: BoxDecoration(
      color: isSelected ? Colors.green : Colors.white,
      border: Border.all(color: isSelected ? Colors.green : Colors.black),
      borderRadius: BorderRadius.circular(20)
      ),
      child: Center(
        child: Text(index.toString(),style: TextStyle(color: isSelected ? Colors.white : Colors.black),),
      ),
    ),
  );
}