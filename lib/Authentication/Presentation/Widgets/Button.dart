import 'package:flutter/material.dart';
import 'package:study_mate/fonts.dart';

class LoginButton extends StatefulWidget {
 final String name;
 final Color bgColor;
 final Color fgColor;
 final double? additinalWidth;
 const LoginButton({super.key,required this.name,required this.bgColor,required this.fgColor,this.additinalWidth});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height*0.06, width: width*0.8 + (widget.additinalWidth ?? 0),
      decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(height*0.01)),
      child: Center(
        child: Text(widget.name,style: TextStyle(color: widget.fgColor,fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 18)),),
      ),
    );
  }
}