import 'package:flutter/material.dart';
import 'package:study_mate/fonts.dart';

Widget SubjectBreakdownTile(double height,double width,int correctQues,int wrongQues,int totalQues,String subject,BuildContext context){
  int attempted = correctQues + wrongQues;
  int skippedQues = totalQues - attempted;
  int accuracy = (correctQues*100/(attempted != 0 ? attempted : 1)).toInt();

  Color color = Colors.green;
  if(subject.toLowerCase().contains("phy")){color = Colors.blue;}
  if(subject.toLowerCase().contains("chem")){color = Colors.orange;}
  if(subject.toLowerCase().contains("bio")){color = Colors.red;}

  return Container(
    width: width*0.9,
    margin: EdgeInsets.only(bottom: height*0.012),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),
      borderRadius: BorderRadius.circular(Responsive.icon(context, 3))
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width*0.04,vertical: height*0.014),
          child: Row(
            children: [
              // subject initial in the subject colour
              Container(height: height*0.05,width: height*0.05,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Responsive.icon(context, 3)),color: color.withValues(alpha: 0.1)),
              child: Center(child: Text(subject.isNotEmpty ? subject[0].toUpperCase() : "",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: color),)),
              ),
              SizedBox(width: width*0.035,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject,style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 15),color: Colors.black),),
                    Text("$correctQues of $totalQues correct",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),color: Colors.blueGrey),)
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("$accuracy%",style: TextStyle(color: Colors.black,fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 22),height: 1.1),),
                  Text("ACCURACY",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 8),fontWeight: FontWeight.bold,color: Colors.blueGrey,letterSpacing: 0.5),),
                ],
              ),
            ],
          ),
        ),
        // one bar split into correct / wrong / skipped
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width*0.04),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Responsive.icon(context, 3)),
            child: SizedBox(
              height: height*0.007,
              child: Row(
                children: [
                  if(correctQues > 0) Expanded(flex: correctQues,child: Container(color: Colors.green,)),
                  if(wrongQues > 0) Expanded(flex: wrongQues,child: Container(color: Colors.red,)),
                  if(skippedQues > 0 || totalQues == 0) Expanded(flex: skippedQues > 0 ? skippedQues : 1,child: Container(color: const Color.fromRGBO(220, 220, 220, 1),)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: height*0.014,),
        Container(color: const Color.fromRGBO(220, 220, 220, 0.5),height: 1,),
        SizedBox(
          height: height*0.055,
          child: Row(
            children: [
              Expanded(child: _count(Colors.green, correctQues, "Correct", context)),
              Container(color: const Color.fromRGBO(220, 220, 220, 0.5),width: 1,),
              Expanded(child: _count(Colors.red, wrongQues, "Wrong", context)),
              Container(color: const Color.fromRGBO(220, 220, 220, 0.5),width: 1,),
              Expanded(child: _count(Colors.blueGrey, skippedQues, "Skipped", context)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _count(Color color,int stat,String name,BuildContext context){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      Text(stat.toString(),style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 15),color: color),),
      const SizedBox(width: 5),
      Text(name,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10),color: Colors.blueGrey),),
    ],
  );
}
