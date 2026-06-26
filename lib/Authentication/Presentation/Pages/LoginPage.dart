import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_bloc.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_events.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_states.dart';
import 'package:study_mate/Authentication/Presentation/Pages/registerPage.dart';
import 'package:study_mate/Authentication/Presentation/Widgets/Button.dart';
import 'package:study_mate/Authentication/Presentation/Widgets/LoginBoxes.dart';
import 'package:study_mate/Authentication/Presentation/Widgets/LoginOptions.dart';
import 'package:study_mate/Home/Presentation/Pages/Homepage.dart';
import 'package:study_mate/fonts.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
 final TextEditingController email = TextEditingController();
 final TextEditingController password = TextEditingController();

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
              SizedBox(height: height*0.05,),
              _header(height,width,context),
              SizedBox(height: height*0.015,),
              Container(height: 1.8,width: width,color: const Color.fromRGBO(220, 220, 220, 0.5),),
              SizedBox(height: height*0.01,),
              topLogin(height, width),
              SizedBox(height: height*0.05,),
              LoginBox(name: "Email", icon: Bootstrap.at, placeholder: "name@gmail.com",  isHidden: false, txtController: email ,size: 28,hideText: false,),
              SizedBox(height: height*0.02,),
              LoginBox(name: "Password", icon: Bootstrap.shield_lock, placeholder: "password", isHidden: true, txtController: password,size: 23,additionalGap: 10,hideText: true,),
              SizedBox(height: height*0.04,),
              GestureDetector(
                onTap: () => BlocProvider.of<AuthBloc>(context).add(AuthLoginStart(email: email.text, password: password.text)),
                child: LoginButton(name: "Sign In", bgColor: Colors.green, fgColor: Colors.black)),
              SizedBox(height: height*0.04,),
              _middleText(height, width),
              SizedBox(height: height*0.04,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [LoginOption(icon: FontAwesome.google_brand, type: "Google",size: 22,), SizedBox(width: width*0.06,),LoginOption(icon: FontAwesome.github_brand, type: "GitHub",size: 25,)],),
                SizedBox(height: height*0.04,),
              _createAccount(height, width,context)  
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
        SizedBox(height: height*0.03,),
        Container(
          height: height*0.06,width: height*0.06,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.black),
          child: Icon(LucideIcons.zap400,color: Colors.white,size: 35,)),
          SizedBox(height: height*0.01,),
        Text("StudyMate",style: TextStyle(color: Colors.black,fontSize: 40,fontFamily: Fonts.outfit,fontWeight: FontWeight.w600),),
        Text("Smarter Learning, One test at a time",style: TextStyle(color: const Color.fromRGBO(132, 132, 132, 1),fontFamily: Fonts.outfit,fontSize: 12),)
      ],
    ),
  );
}

Widget _middleText(double height,double width){
  return Container(
    width: width,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: width*0.02),
          width: width*0.23,
          height: 1.5,
          color: const Color.fromRGBO(200, 200, 200, 0.5),
        ),
        Text("OR CONTINUE WITH",style: TextStyle(color: const Color.fromRGBO(120, 120, 120, 1),fontFamily:Fonts.outfit ,fontSize: 12),),
        Container(
          margin: EdgeInsets.only(left: width*0.02),
          width: width*0.23,
          height: 1.5,
          color: const Color.fromRGBO(200, 200, 200, 0.5),
        )
      ],
    ),
  );
}



Widget _header(double height, double width,BuildContext context){
  return SizedBox(width: width,height: height*0.03,
  child: Row(
    children: [
      SizedBox(width: width*0.02,),
      InkWell(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back_ios,size: 22,)),
      SizedBox(width: width*0.03,),
      Text("Sign In",style: TextStyle(fontFamily: Fonts.outfit,fontSize: 18),)
    ],
  ),
  );
}


Widget _createAccount(double height,double width,BuildContext context){
  return Row(
    children: [
      SizedBox(width: width*0.08,),
      Text("Dont have an Account?",style: TextStyle(fontFamily: Fonts.nunito),),
      SizedBox(width: width*0.02,),
      InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Registerpage())),
        child: Text("Create Account",style: TextStyle(fontFamily: Fonts.outfit,color: Colors.green,fontWeight: FontWeight.w600),))
    ],
  );
}