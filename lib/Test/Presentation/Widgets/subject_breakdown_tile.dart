import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_mate/fonts.dart';

Widget SubjectBreakdownTile(double height,double width,int correctQues,int wrongQues,int totalQues,String subject,BuildContext context){

  return Container(
    height: height*0.15,width: width*0.9,
    margin: EdgeInsets.only(bottom: height*0.015),
    padding: EdgeInsets.only(left: width*0.05),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(200, 200, 200, 0.5),width: 1.5),
      borderRadius: BorderRadius.circular(10)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height*0.014,),

        Row(
          children: [
            SizedBox(
              height: height*0.06,width: width*0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 17)),),
                  Text("$correctQues/$totalQues Correct",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),color: const Color.fromRGBO(140, 140, 140, 1),fontWeight: FontWeight.bold),)
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: width*0.03,vertical: width*0.012),
              
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromRGBO(76, 175, 80, 0.5),),
                borderRadius: BorderRadius.circular(width*0.09),
                color: const Color.fromRGBO(76, 175, 80, 0.06),
                ),
              child: Center(child: Text("${(correctQues*100/((correctQues + wrongQues) != 0 ? (correctQues + wrongQues) : 1)).toInt().toString()}%",style: TextStyle(color: Colors.green,fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 12)),)))
          ],
        ),
        SizedBox(height: height*0.01,),
        SizedBox(
          width: width*0.8,
          child: LinearProgressIndicator(
            backgroundColor: const Color.fromRGBO(220, 220, 220, 0.8),
            valueColor: const AlwaysStoppedAnimation(Colors.green),
            value: (correctQues/totalQues),
            borderRadius: BorderRadius.circular(height*0.01),
            minHeight: height*0.0125,
            
          ),
        ),
        SizedBox(height: height*0.01,),
        Row(
          children: [
            Container(height: height*0.02,width: height*0.02,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),border: Border.all(color: Colors.green)),
            child: Center(child: Icon(Icons.check,color: Colors.green,size: Responsive.icon(context, 15),weight: 700,)),
            ),
            SizedBox(width: width*0.01,),
            Text("$correctQues Correct",style: TextStyle(color: Colors.green,fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 12),fontWeight: FontWeight.bold),),
            SizedBox(width: width*0.2,),

            Container(height: 20,width: 20,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),border: Border.all(color: Colors.red)),
            child: Center(child: Icon(Icons.close,color: Colors.red,size: Responsive.icon(context, 15),)),
            ),
            SizedBox(width: width*0.01,),
            Text("$wrongQues Wrong",style: TextStyle(color: Colors.red,fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 12),fontWeight: FontWeight.bold)),
          ],
        )
      ],
    ),
  );
}