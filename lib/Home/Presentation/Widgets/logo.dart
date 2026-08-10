
import 'package:study_mate/fonts.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

Widget Logo(double height, double width,BuildContext context){
  return SizedBox(
    height: height*0.1,width: width,
    child: Center(
      child: Container(
        height: height*0.08,width: height*0.08,
        decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10)),
        child: Icon(LucideIcons.zap400,color: Colors.white,size: Responsive.icon(context, 45),),
      ),
    ),
  );
}