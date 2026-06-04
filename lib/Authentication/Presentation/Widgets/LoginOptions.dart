import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:study_mate/fonts.dart';

class LoginOption extends StatefulWidget {
 final IconData icon;
 final String type;
 const  LoginOption({super.key,required this.icon,required this.type});

  @override
  State<LoginOption> createState() => _LoginOptionState();
}

class _LoginOptionState extends State<LoginOption> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width*0.37,
      padding: EdgeInsets.symmetric(horizontal: width*0.032,vertical: height*0.013),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(226, 229, 233, 1),width: 1.5),
        borderRadius: BorderRadius.circular(height*0.012)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon),
          SizedBox(width: 10,),
          Text(widget.type,style: TextStyle(color: Colors.black,fontFamily: Fonts.nunito),)
        ],
      ),
    ); 
  }
}