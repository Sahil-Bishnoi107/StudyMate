import 'package:flutter/widgets.dart';

class TestSubmittedPage extends StatelessWidget {
  const TestSubmittedPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height,width: width,
      child: Center(child: Text("Your Test has been successfully Submitted"),),
    );
  }
}