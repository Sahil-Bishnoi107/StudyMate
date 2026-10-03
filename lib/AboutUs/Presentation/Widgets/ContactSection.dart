import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/AboutUs/Domain/Person.dart';
import 'package:study_mate/fonts.dart';

class ContactSection extends StatelessWidget {
  final Person person;

  const ContactSection({super.key, required this.person});

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
              Icon(LucideIcons.contact400Dir,size: Responsive.icon(context, 20),),
              const SizedBox(width: 8),
              Text("Contact ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.green),),
              Text("Information",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.black),),
            ],
          ),
          SizedBox(height: height*0.015,),
          if(person.email.isNotEmpty) _contactTile(height, width, LucideIcons.mail400Dir, Colors.green, "EMAIL", person.email, context),
          if(person.mobileNumber.isNotEmpty) _contactTile(height, width, LucideIcons.phone400Dir, Colors.orange, "MOBILE", person.mobileNumber, context),
        ],
      ),
    );
  }

  Widget _contactTile(double height,double width,IconData icon,Color color,String label,String value,BuildContext context){
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
          Container(height: height*0.045,width: height*0.045,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Responsive.icon(context, 3)),color: color.withValues(alpha: 0.1)),
          child: Icon(icon,color: color,size: Responsive.icon(context, 20),)
          ),
          SizedBox(width: width*0.035,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 9),fontWeight: FontWeight.bold,color: Colors.blueGrey,letterSpacing: 1),),
                SelectableText(value,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 14),fontWeight: FontWeight.w600,color: Colors.black),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
