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
    return Container(
      padding: EdgeInsets.only(left: width*0.05),
      height: height*0.16,
      width: width*0.4,
      decoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(200, 200, 200, 1),),borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height*0.016,),
          Container(
            height: height*0.04,width: height*0.04,
            margin: EdgeInsets.only(left: width*0.01),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(height*0.05),border: Border.all(color: Colors.green)),
            child: Icon(icon, color: const Color.fromARGB(255, 9, 200, 15),size: height*0.02,),
            ),
            SizedBox(height: height*0.01,),
            Text(heading.toUpperCase(),style: TextStyle(fontFamily: Fonts.nunito,color: Colors.grey,fontSize: 11),),
            SizedBox(height: height*0.01,),
            Text(stat,style: TextStyle(fontFamily: Fonts.nunito,fontSize: 22,fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}