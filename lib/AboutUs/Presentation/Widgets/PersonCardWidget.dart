import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/AboutUs/Domain/PeopleCard.dart';
import 'package:study_mate/fonts.dart';

class PersonCardWidget extends StatelessWidget {
  final PersonCard person;
  final VoidCallback onTap;

  const PersonCardWidget({super.key,required this.person,required this.onTap});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Color color = Colors.green; IconData icon = LucideIcons.graduationCap400Dir; String role = "TEACHER";
    if(person.peopleRole == PeopleRole.developer){color = Colors.blue; icon = LucideIcons.code400Dir; role = "DEVELOPER";}
    if(person.peopleRole == PeopleRole.management){color = Colors.orange; icon = LucideIcons.briefcase400Dir; role = "MANAGEMENT";}

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: height*0.012),
        padding: EdgeInsets.symmetric(horizontal: width*0.04,vertical: height*0.016),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),
          borderRadius: BorderRadius.circular(Responsive.icon(context, 3))
        ),
        child: Column(
          children: [
            Row(
              children: [
                // photo with a ring in the role colour
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: color,width: 1.5)),
                  child: ClipOval(
                    child: person.photoUrl.isNotEmpty
                    ? Image.network(person.photoUrl,height: height*0.065,width: height*0.065,fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _placeholder(height, color, context),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _placeholder(height, color, context);
                      },
                    )
                    : _placeholder(height, color, context),
                  ),
                ),
                SizedBox(width: width*0.04,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(person.name,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 16),fontWeight: FontWeight.w600,color: Colors.black),),
                      Text(person.roleTitle,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),color: Colors.blueGrey),),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: height*0.014,),
            Container(height: 1,color: const Color.fromRGBO(220, 220, 220, 0.5),),
            SizedBox(height: height*0.012,),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width*0.02,vertical: height*0.004),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1),borderRadius: BorderRadius.circular(Responsive.icon(context, 3))),
                  child: Row(
                    children: [
                      Icon(icon,color: color,size: Responsive.icon(context, 12),),
                      SizedBox(width: width*0.012,),
                      Text(role,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 9),fontWeight: FontWeight.bold,color: color,letterSpacing: 0.5),),
                    ],
                  ),
                ),
                const Spacer(),
                Text("View Profile",style: TextStyle(fontFamily: Fonts.rubik,fontSize: Responsive.font(context, 11),fontWeight: FontWeight.w600,color: Colors.black),),
                SizedBox(width: width*0.01,),
                Icon(LucideIcons.arrowUpRight400Dir,size: Responsive.icon(context, 14),color: Colors.black,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(double height,Color color,BuildContext context){
    return Container(
      height: height*0.065,width: height*0.065,
      color: color.withValues(alpha: 0.1),
      child: Icon(LucideIcons.userRound400Dir,color: color,size: Responsive.icon(context, 24),),
    );
  }
}
