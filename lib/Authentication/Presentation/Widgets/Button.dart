import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:study_mate/fonts.dart';

class LoginButton extends StatefulWidget {
 final String name;
 final Color bgColor;
 final Color fgColor;
 const LoginButton({super.key,required this.name,required this.bgColor,required this.fgColor});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height*0.06, width: width*0.8,
      decoration: BoxDecoration(color: const Color.fromRGBO(29, 200, 86, 1),borderRadius: BorderRadius.circular(height*0.015)),
      child: Center(
        child: Text(widget.name,style: TextStyle(color: widget.fgColor,fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: 18),),
      ),
    );
  }
}