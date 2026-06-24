import 'package:flutter/material.dart';
import 'package:study_mate/fonts.dart';

class Statbox extends StatelessWidget {
 final IconData icon;
 final String heading;
 final String stat;
 const Statbox({super.key,required this.icon,required this.heading,required this.stat});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      elevation: 0.1,
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.only(left: width*0.04),
        height: height*0.14,
        width: width*0.42,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height*0.012,),
            Container(
              height: height*0.042,width: height*0.042,
              margin: EdgeInsets.only(left: width*0.01),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(height*0.05),color: const Color.fromRGBO(86, 248, 92, 0.102)),
              child: Icon(icon, color: const Color.fromARGB(255, 60, 193, 39),size: height*0.02,),
              ),
              SizedBox(height: height*0.01,),
              Text(heading.toUpperCase(),style: TextStyle(fontFamily: Fonts.nunito,color: Colors.blueGrey,fontSize: 11,fontWeight: FontWeight.bold),),
              SizedBox(height: height*0.01,),
              Text(stat,style: TextStyle(fontFamily: Fonts.outfit,fontSize: 20,fontWeight: FontWeight.w700),)
          ],
        ),
      ),
    );
  }
}