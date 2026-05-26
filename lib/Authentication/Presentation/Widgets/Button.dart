import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginButton extends StatefulWidget {
  String name;
  Color bgColor;
  Color fgColor;
  LoginButton({super.key,required this.name,required this.bgColor,required this.fgColor});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      color: widget.bgColor,
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: height*0.06, width: width*0.5,
       
        child: Center(
          child: Text(widget.name,style: TextStyle(color: widget.fgColor),),
        ),
      ),
    );
  }
}