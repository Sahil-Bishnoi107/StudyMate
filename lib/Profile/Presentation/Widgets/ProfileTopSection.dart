import 'package:flutter/material.dart';
import 'package:study_mate/Profile/Domain/student.dart';
import 'package:study_mate/fonts.dart';

class ProfileTopSection extends StatelessWidget {
  final Student student;

  const ProfileTopSection({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[200],
          backgroundImage: student.pic.isNotEmpty
              ? NetworkImage(student.pic)
              : const AssetImage('assets/images/profile_pic_girl.png') as ImageProvider,
          onBackgroundImageError: (exception, stackTrace) {},
        ),
        SizedBox(height: 15),
        Text(
          student.name,
          style: TextStyle(
            fontFamily: Fonts.outfit,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "JEE Aspirant • Class 12",
          style: TextStyle(
            fontFamily: Fonts.nunito,
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
