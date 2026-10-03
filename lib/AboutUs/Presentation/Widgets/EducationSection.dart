import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/AboutUs/Domain/Person.dart';
import 'package:study_mate/fonts.dart';
import 'dart:math';

class EducationSection extends StatelessWidget {
  final Person person;

  const EducationSection({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    int count = max(person.education.length, person.institute.length);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width*0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.graduationCap400Dir,size: Responsive.icon(context, 20),),
              const SizedBox(width: 8),
              Text("Academic ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.green),),
              Text("Qualifications",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.black),),
            ],
          ),
          SizedBox(height: height*0.015,),
          ...List.generate(count, (index) {
            String edu = index < person.education.length ? person.education[index] : "";
            String inst = index < person.institute.length ? person.institute[index] : "";

            return Container(
              margin: EdgeInsets.only(bottom: height*0.012),
              padding: EdgeInsets.symmetric(horizontal: width*0.04,vertical: height*0.012),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),
                borderRadius: BorderRadius.circular(Responsive.icon(context, 3))
              ),
              child: Row(
                children: [
                  Container(height: height*0.05,width: height*0.05,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Responsive.icon(context, 3)),color: const Color.fromRGBO(33, 150, 243, 0.1)),
                  child: Center(child: Text(_getAcronym(edu),style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 11),fontWeight: FontWeight.w700,color: Colors.blue),)),
                  ),
                  SizedBox(width: width*0.035,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(edu.isNotEmpty) Text(edu,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 14),fontWeight: FontWeight.w600,color: Colors.black),),
                        if(inst.isNotEmpty) Text(inst,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),color: Colors.blueGrey),),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _getAcronym(String text) {
    if (text.isEmpty) return "";
    List<String> parts = text.split(RegExp(r'[\s.]+'));
    String result = "";
    for (String part in parts) {
      if (part.isNotEmpty && part[0] == part[0].toUpperCase()) {
        result += part[0];
        if (result.length >= 3) break;
      }
    }
    return result.isEmpty ? text.substring(0, min(3, text.length)).toUpperCase() : result;
  }
}
