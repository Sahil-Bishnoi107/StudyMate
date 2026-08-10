import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/Profile/Domain/Test.dart';
import 'package:study_mate/fonts.dart';

class Testtile extends StatelessWidget {
 final TestGiven test;
 const Testtile({super.key,required this.test});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height*0.07,width: width*0.9,
      margin: EdgeInsets.only(bottom: height*0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
        ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: width*0.01,),
          Icon(Bootstrap.journal_check,color: Colors.green,size: Responsive.icon(context, 40),),
          SizedBox(width: width*0.025,),
          Container(
            height: height*0.07,
            width: width*0.6,
            padding: EdgeInsets.only(top: height*0.004),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height*0.01,),
                Text(test.name,style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 14)),),
                Text("${test.subject}    \u2022     ${test.time} minutes",style: TextStyle(color: Colors.grey,fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 10)),)
              ],
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height*0.01,),
              Text("${test.correctQuestions} / ${test.totalQuestions}",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 12),fontWeight: FontWeight.w500),),
              SizedBox(height: height*0.003,),
              Text(test.status,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10),fontWeight: FontWeight.bold),)
            ],
          )
        ],
      ),
    );
  }
}