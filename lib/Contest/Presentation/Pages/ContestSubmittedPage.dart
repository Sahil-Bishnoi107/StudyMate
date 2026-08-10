import 'package:flutter/material.dart';
import 'package:study_mate/Home/Presentation/Pages/Homepage.dart';
import 'package:study_mate/fonts.dart';
import 'package:lottie/lottie.dart';

class ContestSubmittedPage extends StatelessWidget {
  const ContestSubmittedPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/check_animation.json',
              width: 200,
              height: 200,
              repeat: false,
            ),
            SizedBox(height: 30),
            Text(
              "Test Submitted",
              style: TextStyle(
                fontFamily: Fonts.inter,
                fontSize: Responsive.font(context, 24),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Text(
                "Your contest answers have been successfully submitted. Your results and updated rating will be available soon.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Fonts.nunito,
                  color: Colors.grey[600],
                  fontSize: Responsive.font(context, 14),
                ),
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                // Return to the first route (or main page) where ContestPage lives.
                Navigator.push(context, MaterialPageRoute(builder: (_) => Homepage()));
              },
              child: Container(
                width: width * 0.6,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    "Back to HomePage",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: Fonts.inter,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.font(context, 16),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
