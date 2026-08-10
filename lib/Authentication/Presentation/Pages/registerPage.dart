import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/regirster_bloc.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/register_events.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/register_states.dart';
import 'package:study_mate/Authentication/Presentation/Widgets/Button.dart';
import 'package:study_mate/Authentication/Presentation/Widgets/LoginBoxes.dart';
import 'package:study_mate/Authentication/Presentation/Widgets/LoginOptions.dart';
import 'package:study_mate/Home/Presentation/Pages/Homepage.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
import 'package:study_mate/fonts.dart';

class Registerpage extends StatelessWidget {
  Registerpage({super.key});
  
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<RegisterBloc,RegisterStates>(
        listener: (context, state) {
          if(state is SuccessfullRegisterState){
            Navigator.push(context, MaterialPageRoute(builder: (_) => Homepage()));
          }
          
          if(state is FailureRegisterState){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
              content: const Text("Failed To Register",style: TextStyle(fontFamily: Fonts.outfit),),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
                   ),   
              ));
          }
        },
        builder: (context, state) {
          if(state is LoadingRegisterState){
            return SizedBox(height: height,width: width, child: Center(child: LoadingLogo(),));
          }
       return  Padding(
          padding: EdgeInsetsGeometry.only(left: width*0.05),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 // SizedBox(height: height*0.05,),
                  _header(height, width, context),
                  const SizedBox(height: 3,),
                  _line(height, width),
                  const SizedBox(height: 10,),
                  _intro(height, width, context),
                  _registerForm(height, width, name, email, password, confirmPassword,(state is PasswordMismatchState)),
                  SizedBox(height: height*0.05,),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<RegisterBloc>(context).add(AttemptedRegisterEvent(name: name.text, email:  email.text, password: password.text, confirmPassword: confirmPassword.text));
                    },
                    child: LoginButton(name: "Sign Up", bgColor: Colors.green, fgColor: Colors.black,additinalWidth: width*0.1,)),
                  SizedBox(height: height*0.03,),
                  _middleText(height, width, context),
                  SizedBox(height: height*0.03,),
                  _socialLogin(height, width),
                  SizedBox(height: height*0.1,)
                ],
              ),
            ),
          ),
        );
        }
      )
    );
  }
}



Widget _header(double height, double width,BuildContext context){
  return SizedBox(
    height: height*0.05,
    child: Row(
      children: [
       
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(LucideIcons.chevronLeft300Dir,size: Responsive.icon(context, 30),)),
        SizedBox(width: width*0.03,),
        Text("Create Account",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 16),fontWeight: FontWeight.w400),)
      ],
    ),
  );
}


Widget _line(double height,double width){
  return Container(
    height: 2,width: width*0.9,
  
    color: const Color.fromRGBO(220, 220, 220, 0.6),
  );
}

Widget _intro(double height, double width, BuildContext context){
  return SizedBox(
    height: height*0.16,width: width*0.6,
   // margin: EdgeInsets.only(left: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Get Started",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 32)),),
        Text("Join thousands of students achieving their goals with StudyMate's smart analytics.",
        style: TextStyle(fontFamily: Fonts.nunito,color: const Color.fromRGBO(108, 108, 108, 1),fontSize: Responsive.font(context, 12)),
        )
      ],
    ),
  );
}


Widget _registerForm(double height,double width,TextEditingController name,TextEditingController email,TextEditingController password,TextEditingController confirmPassword,bool passwordMismatch){
  return Padding(

    padding: EdgeInsetsGeometry.only(left: width*0.0),
    child: Column(
      children: [
        LoginBox(name: "Name", icon: Bootstrap.person_circle, placeholder: "John Doe", isHidden: false, txtController: name, size: 23, hideText: false,extraWidth: width*0.1,additionalGap: 5,),
        SizedBox(height: height*0.025,),
        LoginBox(name: "Email", icon: Bootstrap.at, placeholder: "john.doe@gmail.com", isHidden: false, txtController: email, size: 28, hideText: false,extraWidth: width*0.1,),
        SizedBox(height: height*0.025,),
        LoginBox(name: "Password", icon: Bootstrap.shield_lock, placeholder: "Password", isHidden: false, txtController: password, size: 23, hideText: true,extraWidth: width*0.1,additionalGap: 5,error: passwordMismatch,),
        SizedBox(height: height*0.025,),
        LoginBox(name: "Confirm Password", icon: Bootstrap.shield_check, placeholder: "Confirm Password", isHidden: false, txtController: confirmPassword, size: 23, hideText: true,extraWidth: width*0.1,additionalGap: 5,error: passwordMismatch,),
      ],
    ),
  );
}

Widget _middleText(double height,double width, BuildContext context){
  return SizedBox(
    width: width,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: width*0.02),
          width: width*0.27,
          height: 1.5,
          color: const Color.fromRGBO(200, 200, 200, 0.5),
        ),
        Text("OR REGISTER WITH",style: TextStyle(color: const Color.fromRGBO(120, 120, 120, 1),fontFamily:Fonts.outfit ,fontSize: Responsive.font(context, 12)),),
        Container(
          margin: EdgeInsets.only(left: width*0.02),
          width: width*0.27,
          height: 1.5,
          color: const Color.fromRGBO(200, 200, 200, 0.5),
        ),
        SizedBox(width: width*0.05,),
      ],
    ),
  );
}


Widget _socialLogin(double height,double width){
  return  Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginOption(icon: FontAwesome.google_brand, type: "Google",size: 22,), 
                  SizedBox(width: width*0.06,),
                  LoginOption(icon: FontAwesome.github_brand, type: "GitHub",size: 25,),
                  SizedBox(width: width*0.05 ,)
                  ],);
}