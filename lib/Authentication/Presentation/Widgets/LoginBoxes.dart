import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:study_mate/fonts.dart';

class LoginBox extends StatefulWidget {
   String name;
   IconData icon;
   String placeholder;
   bool isHidden;
   TextEditingController txtController;
   LoginBox({super.key,required this.name,required this.icon,required this.placeholder,required this.isHidden,required this.txtController});

  @override
  State<LoginBox> createState() => _LoginBoxState();
}

class _LoginBoxState extends State<LoginBox> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width*0.8,
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(widget.name, style: TextStyle(color: Colors.black,fontFamily: Fonts.nunito,fontSize: 16,fontWeight: FontWeight.w400),),
        SizedBox(height: height*0.01),
        Container(
          height: height*0.06,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color.fromRGBO(226, 229, 233, 1),width: 1.5
            ),
            borderRadius: BorderRadius.circular(height*0.015)
          ),
          child: Row(
            children: [
              SizedBox(width: width*0.025,),
              Icon(widget.icon,color: Colors.black,),
              SizedBox(width: width*0.016,),
              Container(
                width: width*0.5,
                child: TextField(
                  
                  controller: widget.txtController,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none
                  ),
                  
                ),
              ),
            ],
          ),
        )
        ],
      ),
    );
  }
}