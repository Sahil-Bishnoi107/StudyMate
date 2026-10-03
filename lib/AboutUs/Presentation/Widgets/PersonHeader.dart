import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/AboutUs/Domain/PeopleCard.dart';
import 'package:study_mate/AboutUs/Domain/Person.dart';
import 'package:study_mate/fonts.dart';

class PersonHeader extends StatelessWidget {
  final Person person;

  const PersonHeader({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Color color = Colors.green; IconData icon = LucideIcons.graduationCap400Dir; String role = "TEACHER";
    if(person.role == PeopleRole.developer){color = Colors.blue; icon = LucideIcons.code400Dir; role = "DEVELOPER";}
    if(person.role == PeopleRole.management){color = Colors.orange; icon = LucideIcons.briefcase400Dir; role = "MANAGEMENT";}

    return Padding(
      padding: EdgeInsets.only(top: height*0.03,left: width*0.05,right: width*0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // photo with a ring in the role colour, same as the person cards
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: color,width: 2)),
                child: ClipOval(
                  child: person.photoUrl.isNotEmpty
                  ? Image.network(person.photoUrl,height: height*0.11,width: height*0.11,fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _placeholder(height, color, context),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _placeholder(height, color, context);
                    },
                  )
                  : _placeholder(height, color, context),
                ),
              ),
              SizedBox(width: width*0.05,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width*0.02,vertical: height*0.004),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.1),borderRadius: BorderRadius.circular(Responsive.icon(context, 3))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon,color: color,size: Responsive.icon(context, 12),),
                          SizedBox(width: width*0.012,),
                          Text(role,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 9),fontWeight: FontWeight.bold,color: color,letterSpacing: 0.5),),
                        ],
                      ),
                    ),
                    SizedBox(height: height*0.006,),
                    Text(person.name,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 24),fontWeight: FontWeight.w600,color: Colors.black,height: 1.1),),
                    SizedBox(height: height*0.004,),
                    Text(person.roleTitle,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 12),color: Colors.blueGrey),),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: height*0.025,),
          Row(
            children: [
              if(person.yearsExperience > 0) ...[
                _stat(width, "${person.yearsExperience}+", person.yearsExperience == 1 ? "Year Experience" : "Years Experience", context),
                SizedBox(width: width*0.08,),
              ],
              if(person.education.isNotEmpty)
                _stat(width, person.education.length.toString(), person.education.length == 1 ? "Qualification" : "Qualifications", context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(double width,String stat,String name,BuildContext context){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(stat,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 30),fontWeight: FontWeight.w600,color: Colors.black),),
        SizedBox(width: width*0.015,),
        Text(name,style: TextStyle(fontFamily: Fonts.rubik,fontSize: Responsive.font(context, 12),color: const Color.fromRGBO(120, 120, 120, 1)),),
      ],
    );
  }

  Widget _placeholder(double height,Color color,BuildContext context){
    return Container(
      height: height*0.11,width: height*0.11,
      color: color.withValues(alpha: 0.1),
      child: Icon(LucideIcons.userRound400Dir,color: color,size: Responsive.icon(context, 40),),
    );
  }
}
