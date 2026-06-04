import 'package:flutter/material.dart';
import 'package:study_mate/Home/Domain/Entities/Test.dart';
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
       // border: Border.all(color: const Color.fromRGBO(170, 170, 170, 1)),
        borderRadius: BorderRadius.circular(10)
        ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: width*0.01,),
          Icon(Icons.book_rounded,color: Colors.green,size: 50,),
          SizedBox(width: width*0.01,),
          Container(
            width: width*0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height*0.01,),
                Text(test.name,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: 14),),
                Text("${test.subject}    \u2022     ${test.time} minutes",style: TextStyle(color: Colors.grey,fontFamily: Fonts.nunito,fontSize: 10),)
              ],
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height*0.01,),
              Text("${test.correctQuestions} / ${test.totalQuestions}",style: TextStyle(fontFamily: Fonts.nunito,fontSize: 13,fontWeight: FontWeight.bold),),
              Text(test.status,style: TextStyle(fontFamily: Fonts.nunito,fontSize: 10,fontWeight: FontWeight.bold),)
            ],
          )
        ],
      ),
    );
  }
}