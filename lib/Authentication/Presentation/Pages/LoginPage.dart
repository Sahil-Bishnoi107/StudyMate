import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/Authentication/Presentation/Widgets/Button.dart';
import 'package:study_mate/Authentication/Presentation/Widgets/LoginBoxes.dart';
import 'package:study_mate/Authentication/Presentation/Widgets/LoginOptions.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: width*0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [
            SizedBox(height: height*0.15,),
            topLogin(height, width),
            SizedBox(height: height*0.05,),
            LoginBox(name: "Email", icon: Icons.alternate_email_rounded, placeholder: "xyz@gmail.com", isHidden: false, txtController: email ),
            SizedBox(height: height*0.02,),
            LoginBox(name: "Password", icon: Icons.lock, placeholder: "*********", isHidden: true, txtController: password),
            SizedBox(height: height*0.03,),
            LoginButton(name: "Sign In", bgColor: const Color.fromRGBO(0, 230, 118, 1), fgColor: Colors.white),
            SizedBox(height: height*0.03,),
            middleText(height, width),
            SizedBox(height: height*0.02,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [LoginOption(icon: FontAwesome.google_brand, type: "Google"), SizedBox(width: width*0.02,),LoginOption(icon: FontAwesome.github_brand, type: "GitHub")],)
          ],
        ),
      ),
    );
  }
}

Widget topLogin(double height,double width){
  return Container(
   
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Study Mate",style: TextStyle(color: Colors.green,fontSize: 30),),
        Text("Smarter Learning, One test at a time")
      ],
    ),
  );
}

Widget middleText(double height,double width){
  return Container(
    width: width,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: width*0.02),
          width: width*0.2,
          height: 2,
          color: Colors.grey,
        ),
        Text("OR CONTINUE WITH",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
        Container(
          margin: EdgeInsets.only(left: width*0.02),
          width: width*0.2,
          height: 2,
          color: Colors.grey,
        )
      ],
    ),
  );
}