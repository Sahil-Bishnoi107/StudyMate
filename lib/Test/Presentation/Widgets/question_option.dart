import 'package:flutter/material.dart';
import 'package:study_mate/Test/Presentation/Widgets/fixedTextWidget.dart';
import 'package:study_mate/fonts.dart';

Widget QuestionOption(String option,double height,double width,bool isSelected,String optionNum,BuildContext context){
  return Container(
    constraints: BoxConstraints(minHeight: height*0.08),
    width: width*0.9,
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(left: width*0.04),
    margin: EdgeInsets.only(bottom: height*0.01),
    decoration: BoxDecoration(
      border: Border.all(color: isSelected ? Colors.green : const Color.fromRGBO(220, 220, 220, 0.7),width: 1.2),
    //  borderRadius: BorderRadius.circular(width*0.03)
    ),
    child: Row(
      children: [
        Container(
          height: width*0.099,width: width*0.099,
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : const Color.fromRGBO(220, 220, 220, 0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.15))
          ),
          child: Center(child: Text(optionNum,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 15), fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black),)),
        ),
        SizedBox(width: width*0.03,),
        Flexible(child: MixedMathText(text:  option,textStyle: TextStyle(fontFamily: Fonts.nunito,color: isSelected ? Colors.green : Colors.black),)),
      ],
    ),
  );
}


Widget QuestionReviewOption(String option,double height,double width,bool isSelected,String optionNum,bool isCorrect){
  return Container(
    constraints: BoxConstraints(minHeight: height*0.08),
    width: width*0.9,
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(left: width*0.04),
    margin: EdgeInsets.only(bottom: height*0.01),
    decoration: BoxDecoration(
      border: Border.all(color: isSelected ? (isCorrect ? Colors.green : Colors.red) : const Color.fromRGBO(220, 220, 220, 0.8),width: 1),
     // borderRadius: BorderRadius.circular(width*0.03)
    ),
    child: Row(
      children: [
        Container(
          height: width*0.099,width: width*0.099,
          decoration: BoxDecoration(
            color: isSelected ? (isCorrect ? Colors.green : Colors.red) : const Color.fromRGBO(220, 220, 220, 0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.15))
          ),
          child: Center(child: Text(optionNum,style: TextStyle(fontFamily: Fonts.nunito,fontSize: 15, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black),)),
        ),
        SizedBox(width: width*0.03,),
        Flexible(child: MixedMathText(text:  option, textStyle: TextStyle(fontFamily: Fonts.nunito,color: isSelected ? (isCorrect ? Colors.green : Colors.red) : Colors.black),)),
      ],
    ),
  );
}