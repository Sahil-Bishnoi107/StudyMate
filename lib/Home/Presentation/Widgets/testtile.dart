import 'package:flutter/material.dart';
import 'package:study_mate/Home/Domain/Entities/Test.dart';

class Testtile extends StatelessWidget {
  TestGiven test;
  Testtile({super.key,required this.test});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.book_rounded,color: Colors.green,),
        Column(
          children: [
            Text(test.name),
            Text("${test.subject}      \u2022 ${test.time} minutes")
          ],
        ),
        Column(
          children: [
            Text("${test.correctQuestions} / ${test.totalQuestions}"),
            Text(test.status)
          ],
        )
      ],
    );
  }
}