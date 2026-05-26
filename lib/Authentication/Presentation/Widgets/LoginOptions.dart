import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginOption extends StatefulWidget {
  IconData icon;
  String type;
  LoginOption({super.key,required this.icon,required this.type});

  @override
  State<LoginOption> createState() => _LoginOptionState();
}

class _LoginOptionState extends State<LoginOption> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width*0.3,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        children: [
          Icon(widget.icon),
          SizedBox(width: 10,),
          Text(widget.type,style: TextStyle(color: Colors.black),)
        ],
      ),
    );
  }
}