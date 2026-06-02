import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_bloc.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_events.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_states.dart';
import 'package:study_mate/Authentication/Presentation/Widgets/Button.dart';
import 'package:study_mate/Authentication/Presentation/Widgets/LoginBoxes.dart';
import 'package:study_mate/Authentication/Presentation/Widgets/LoginOptions.dart';
import 'package:study_mate/Home/Presentation/Pages/Homepage.dart';
import 'package:study_mate/fonts.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    return BlocConsumer<AuthBloc,AuthState>(
      listener: (context, state) {
        if(state is AuthFailure){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not login")));
        }
        if(state is AuthSuccess){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
        }
      },
      builder: (context, state) {  
        if(state is AuthLoading){
          return Scaffold(
             body: Container(
              height: height,width: width,
              color: Colors.white,
              child: Center(
                child: LoadingAnimationWidget.inkDrop(color: Colors.green, size: 50),
              ),
             ),
          );
        }
        
       return  Scaffold(
        backgroundColor: const Color.fromRGBO(254, 254, 254, 1),
        body: Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width*0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
              SizedBox(height: height*0.1,),
              topLogin(height, width),
              SizedBox(height: height*0.05,),
              LoginBox(name: "Email", icon: Icons.alternate_email_rounded, placeholder: "xyz@gmail.com", isHidden: false, txtController: email ),
              SizedBox(height: height*0.02,),
              LoginBox(name: "Password", icon: Icons.lock, placeholder: "*********", isHidden: true, txtController: password),
              SizedBox(height: height*0.04,),
              GestureDetector(
                onTap: () => BlocProvider.of<AuthBloc>(context).add(AuthLoginStart(email: email.text, password: password.text)),
                child: LoginButton(name: "Sign In", bgColor: const Color.fromRGBO(0, 230, 118, 1), fgColor: Colors.black)),
              SizedBox(height: height*0.04,),
              middleText(height, width),
              SizedBox(height: height*0.04,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [LoginOption(icon: FontAwesome.google_brand, type: "Google"), SizedBox(width: width*0.06,),LoginOption(icon: FontAwesome.github_brand, type: "GitHub")],)
            ],
          ),
        ),
      );}
    );
  }
}

Widget topLogin(double height,double width){
  return Container(
   
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("StudyMate",style: TextStyle(color: Colors.green,fontSize: 60,fontFamily: Fonts.inter),),
        Text("Smarter Learning, One test at a time",style: TextStyle(color: const Color.fromARGB(255, 132, 132, 132),fontFamily: 'Nunito',fontSize: 12),)
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
          height: 0.5,
          color: const Color.fromRGBO(120, 120, 120, 1),
        ),
        Text("OR CONTINUE WITH",style: TextStyle(color: const Color.fromRGBO(120, 120, 120, 1),fontWeight: FontWeight.bold,fontFamily:Fonts.nunito ,fontSize: 12),),
        Container(
          margin: EdgeInsets.only(left: width*0.02),
          width: width*0.2,
          height: 0.5,
          color: const Color.fromRGBO(120, 120, 120, 1),
        )
      ],
    ),
  );
}