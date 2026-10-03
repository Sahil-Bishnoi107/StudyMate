import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/AboutUs/Domain/Person.dart';
import 'package:study_mate/fonts.dart';

class ExperienceSection extends StatelessWidget {
  final Person person;

  const ExperienceSection({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width*0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.briefcase400Dir,size: Responsive.icon(context, 20),),
              const SizedBox(width: 8),
              Text("Professional ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.green),),
              Text("Experience",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.black),),
            ],
          ),
          SizedBox(height: height*0.015,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),
              borderRadius: BorderRadius.circular(Responsive.icon(context, 3))
            ),
            child: Column(
              children: [
                for(int i = 0; i < person.experience.length; i++) ...[
                  if(i != 0) Container(color: const Color.fromRGBO(220, 220, 220, 0.5),height: 1,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width*0.04,vertical: height*0.014),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(LucideIcons.circleCheck400Dir,color: Colors.green,size: Responsive.icon(context, 16),),
                        SizedBox(width: width*0.03,),
                        Expanded(child: Text(person.experience[i],style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 12),color: Colors.black,height: 1.4),)),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
