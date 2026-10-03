import 'package:flutter/material.dart';

Widget questionIcon(double height,double width,bool isSelected,int index,{Color color = Colors.green}){
  return Align(
    alignment: Alignment.center,
    child: Container(
      height: height*0.04,width: height*0.04,
      margin: EdgeInsets.only(right: width*0.015),
      decoration: BoxDecoration(
      color: isSelected ? color : Colors.white,
      border: Border.all(color: isSelected ? color : const Color.fromRGBO(220, 220, 220, 0.7), width: 1.2),
      borderRadius: BorderRadius.circular(20)
      ),
      child: Center(
        child: Text(index.toString(),style: TextStyle(color: isSelected ? Colors.white : Colors.black),),
      ),
    ),
  );
}
