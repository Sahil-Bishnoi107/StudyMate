import 'package:flutter/material.dart';
import 'package:study_mate/fonts.dart';


Widget StatBox(double height,double width,IconData icon,Color color,String statName,String stat, String followOn,BuildContext context){
   return Padding(
    padding: EdgeInsets.symmetric(vertical: height*0.014),
    child: Row(
      children: [
        Icon(icon,color: color,size: Responsive.icon(context, 22),),
        SizedBox(width: width*0.04,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(statName,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 14),fontWeight: FontWeight.w600,color: Colors.black),),
              Text(followOn,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 10),color: const Color.fromRGBO(110, 110, 110, 1)),)
            ],
          ),
        ),
        Text(stat,style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w500,fontSize: Responsive.font(context, 18),color: Colors.black),),
      ],
    ),
   );
}
