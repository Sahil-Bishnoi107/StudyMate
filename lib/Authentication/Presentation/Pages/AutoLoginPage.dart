import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_bloc.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_events.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_states.dart';
import 'package:study_mate/Authentication/Presentation/Pages/LoginPage.dart';
import 'package:study_mate/Authentication/Presentation/Pages/onboarding_page.dart';
import 'package:study_mate/Home/Presentation/Pages/Homepage.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';


class Autologinpage extends StatefulWidget {
  const Autologinpage({super.key});

  @override
  State<Autologinpage> createState() => _AutologinpageState();
}

class _AutologinpageState extends State<Autologinpage> {
  @override
  void initState() {
    
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
    
    BlocProvider.of<AuthBloc>(context).add(AutoLogin());
    });
  }
  @override
  Widget build(BuildContext context) {
  
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocListener<AuthBloc,AuthState>(
      listener: (context, state) {
        if(state is AuthInitial){
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
        if(state is AuthSuccess){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
        }
        if(state is NewUserState){
          Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingPage()));
        }
      },
      child: Scaffold(
        body: Container(
          color: Colors.white,
          height: height,width: width,
          child: Center(child: LoadingLogo())),
      ),
    );
  }
}