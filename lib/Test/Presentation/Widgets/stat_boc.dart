import 'package:flutter/material.dart';
import 'package:study_mate/fonts.dart';

Widget StatBox(double height,double width,IconData icon,String statName,String stat, String followOn,BuildContext context){
   return Container(
    height: height*0.12,width: width*0.42,
    padding: EdgeInsets.only(left: width*0.04),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(width*0.04), border: Border.all(color: const Color.fromRGBO(220, 220, 220, 1),width: 1.7)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height*0.02,),
        Row(
          children: [
            
             Icon(icon,color:  Color(0xFF17B169),),
             SizedBox(width: width*0.02,),
             Text(statName,style: TextStyle(color: Colors.blueGrey,fontFamily: Fonts.nunito,fontWeight: FontWeight.bold),)
          ],
        ),
        SizedBox(height: height*0.005,),
        Text(stat,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 18)),),
        
        Text(followOn,style: TextStyle(color: Colors.blueGrey,fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10)),)

      ],
    ),
   );
}