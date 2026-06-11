import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget SubjectBreakdownTile(double height,double width,int correctQues,int wrongQues,int totalQues,String subject){

  return Container(
    height: height*0.15,width: width*0.9,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blueGrey),
      borderRadius: BorderRadius.circular(10)
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              height: height*0.05,width: width*0.4,
              child: Column(
                children: [
                  Text(subject),
                  Text("$correctQues / $totalQues Correct")
                ],
              ),
            ),

            Text((correctQues/(correctQues + wrongQues)).toInt().toString(),style: TextStyle(color: Colors.green),)
          ],
        ),

        SizedBox(
          width: width*0.8,
          child: LinearProgressIndicator(
            backgroundColor: const Color.fromRGBO(220, 220, 220, 0.8),
            valueColor: const AlwaysStoppedAnimation(Colors.green),
            value: (correctQues/totalQues),
            borderRadius: BorderRadius.circular(4),
            minHeight: 10,
            
          ),
        ),

        Row(
          children: [
            Container(height: 20,width: 20,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),border: Border.all(color: Colors.green)),
            child: Icon(Icons.check,color: Colors.green,),
            ),
            Text("$correctQues Correct"),
            SizedBox(width: width*0.2,),

            Container(height: 20,width: 20,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),border: Border.all(color: Colors.red)),
            child: Icon(Icons.check,color: Colors.red,),
            ),
            Text("$wrongQues Wrong"),
          ],
        )
      ],
    ),
  );
}