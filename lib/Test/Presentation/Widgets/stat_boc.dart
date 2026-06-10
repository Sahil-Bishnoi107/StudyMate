import 'package:flutter/material.dart';
import 'package:study_mate/fonts.dart';

Widget StatBox(double height,double width,IconData icon,String statName,String stat, String followOn){
   return Container(
    height: height*0.2,width: width*0.4,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey,width: 1.5)),
    child: Column(
      children: [
        Row(
          children: [
             Icon(icon,color: Colors.green,),
             Text(statName)
          ],
        ),
      
        Text(stat,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold),),
        
        Text(followOn,style: TextStyle(color: Colors.blueGrey,fontFamily: Fonts.nunito,fontSize: 12),)

      ],
    ),
   );
}