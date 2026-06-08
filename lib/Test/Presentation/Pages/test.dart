import 'package:flutter/material.dart';

class Test extends StatefulWidget {
 final String testId;
 const Test({super.key,required this.testId});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Test"),
    );
  }
}