import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:study_mate/fonts.dart';

class LoginBox extends StatefulWidget {
  final String name;
  final IconData icon;
  final String placeholder;
  final bool isHidden;
  final double size;
  final TextEditingController txtController;
  final double? additionalGap;
  final bool hideText;
  final double? extraWidth;
  final bool? error;
  const LoginBox({super.key,required this.name,required this.icon,required this.placeholder,required this.isHidden,required this.txtController,required this.size,this.additionalGap,required this.hideText,this.extraWidth,this.error});

  @override
  State<LoginBox> createState() => _LoginBoxState();
}

class _LoginBoxState extends State<LoginBox> {
  bool obsecure = true;
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool? error = widget.error;
    return Container(
      width: width*0.8 + (widget.extraWidth ?? 0),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(widget.name, style: TextStyle(color: Colors.black,fontFamily: Fonts.outfit,fontSize: 14,fontWeight: FontWeight.w400),),
        SizedBox(height: height*0.005),
        Container(
          height: height*0.06,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: (error != null && error) ? const Color.fromRGBO(244, 67, 54, 0.7)   : const Color.fromRGBO(220, 220, 220, 0.5),width: 2
            ),
            borderRadius: BorderRadius.circular(height*0.01)
          ),
          child: Row(
            children: [
              SizedBox(width: width*0.025,),
              Icon(widget.icon,color: Colors.black,size: widget.size,),
              SizedBox(width: widget.additionalGap ?? 0,),
              SizedBox(width: width*0.016,),
              Container(
                width: width*0.65 + (widget.extraWidth ?? 0),
                child: TextField(            
                  controller: widget.txtController,
                  style: TextStyle(fontFamily: Fonts.outfit),
                  decoration: InputDecoration(
                    hintText: widget.placeholder,             
                    hintStyle: TextStyle(color: const Color.fromRGBO(120, 120, 120, 1),fontFamily: Fonts.outfit),
                    border: InputBorder.none,
                    suffixIcon: widget.hideText ? IconButton(
                      onPressed: (){
                        setState(() {
                          obsecure = !obsecure;
                        });
                      }, 
                      icon: Icon( obsecure ? Icons.visibility : Icons.visibility_off)) 
                      : SizedBox.shrink()
                  ),
                  
                  obscureText: obsecure && widget.hideText,
                
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