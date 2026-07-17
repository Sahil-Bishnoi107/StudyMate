import 'package:flutter/material.dart';
import 'package:study_mate/Profile/Domain/student.dart';
import 'package:study_mate/fonts.dart';

class ProfileTopSection extends StatelessWidget {
  final Student student;
  final double height;
  final double width;

  const ProfileTopSection({Key? key, required this.student,required this.height,required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height*0.18,width: width*0.4,
      margin: EdgeInsets.only(top: height*0.01),
    
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: const AssetImage('assets/avatar_images/man.png') as ImageProvider,
            onBackgroundImageError: (exception, stackTrace) {},
          ),
          SizedBox(height: 5),
          SizedBox(width: width*0.35,
            child: Center(
              child: Text(
                student.name  ,
                style: TextStyle(
                  fontFamily: Fonts.outfit,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          
          
        ],
      ),
    );
  }
}
