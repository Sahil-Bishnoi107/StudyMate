import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        Text(widget.name),
        SizedBox(height: height*0.01),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,width: 2
            ),
            borderRadius: BorderRadius.circular(5)
          ),
          child: Row(
            children: [
              Icon(widget.icon),
              Container(
                width: width*0.5,
                child: TextField(
                  controller: widget.txtController,
                  decoration: InputDecoration(
                    
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