import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Authentication/Presentation/Pages/LoginPage.dart';
import 'package:study_mate/Authentication/Presentation/Pages/registerPage.dart';
import 'package:study_mate/fonts.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height*0.07,),
          _topLogo(height, width),
          SizedBox(height: height*0.01,),
          _imageSection(height, width),
          SizedBox(height: height*0.03,),
          _text(height, width),
          SizedBox(height: height*0.03,),
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage())),
            child: _getStarted(height, width)),
          SizedBox(height: height*0.01,),
          _registerOption(height, width, context)
        ],
      ),
    );
  }
}



Widget _topLogo(double height,double width){
  return SizedBox(
    height: height*0.1,width: width,
    child: Center(
      child: Container(
        height: height*0.08,width: height*0.08,
        decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10)),
        child: Icon(LucideIcons.zap500,color: Colors.white,size: 45,),
      ),
    ),
  );
}

Widget _imageSection(double height,double width){
  return Transform.scale(
    scale: 0.9,
    child: SizedBox(
      height: width*0.8, width: width*0.8,
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
          
            Material(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromRGBO(255, 255, 255, 1),
              elevation: 0.2,
              
              child: SizedBox(
                height: width*0.7,width: width*0.7,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(25),
                    child: Image.asset("assets/images/priscilla-du-preez-XkKCui44iM0-unsplash.jpg",fit: BoxFit.cover,)),
                ),
              ),
            ),
        
              Positioned(
              bottom: width*0.73,left: width*0.63,
              child: _popIcons(height, width, "RANK #1", Bootstrap.trophy, 15),
            ),
            Positioned(
              top: width*0.75,left: width*0.5,
              child: _popIcons(height, width, "100+ TESTS", Bootstrap.file_code, 15),
            ),
            Positioned(
              top: width*0.32,right: width*0.63,
              child: _popIcons(height, width, "SMART AI", Bootstrap.stars, 15),
            ),
          ],
        ),
      ),
    ),
  );
}


Widget _popIcons(double height,double width,String title, IconData icon,double size){
  return Material(
    elevation: 1,
    borderRadius: BorderRadius.circular(30),
    color:   const Color.fromRGBO(255, 255, 255, 0.9),
    child: SizedBox(
      height: height*0.04,
      
      child: Row(
        children: [
          SizedBox(width: width*0.012,),
          Container(
            height: width*0.07,width: width*0.07,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: const Color.fromRGBO(76, 175, 80, 0.2)),
            child: Icon(icon,size: size,color: Colors.green,fontWeight: FontWeight.bold,),
          ),
          SizedBox(width: width*0.01,),
          Text(title, style:  TextStyle(fontFamily: Fonts.nunito,fontSize: 11,fontWeight: FontWeight.w600),),
          SizedBox(width: width*0.02,)
        ],
      ),
    ),
  );
}

Widget _text(double height,double width){
  TextStyle tstyle = TextStyle(fontFamily: Fonts.nunito,color: const Color.fromRGBO(108, 108, 108, 1),fontSize: 13);
  return SizedBox(
    width: width,height: height*0.2,
    child: Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: width*0.15),
      child: Column(
        children: [
           Text("Master Your Exams",style: TextStyle(fontFamily: Fonts.outfit,fontSize: 30,fontWeight: FontWeight.w900),),
           Text("With Confidence",style: TextStyle(fontFamily: Fonts.outfit,fontSize: 33,color: Colors.green,fontWeight: FontWeight.bold),),
           SizedBox(height: height*0.01,),
           Text("Your personalized learning journey",  style: tstyle),
           Text("starts here. Track Performance and ace", style: tstyle,),
           Text("your tests with AI.",style: tstyle,)
        ],
      ),
    ),
  );
}

Widget _getStarted(double height,double width){
  return Container(
    height: height*0.055,width: width*0.8,
    decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(40)),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Get Started",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: 16),),
          SizedBox(width: width*0.01,),
          Icon(Icons.arrow_forward,size: 20,fontWeight: FontWeight.bold,)
        ],
      ),
    ),
  );
}

Widget _registerOption(double height, double width,BuildContext context){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     Text("Don't have an account?",style: TextStyle(fontFamily: Fonts.outfit),),
     //SizedBox(width: 1,),
     TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => Registerpage()));
      },
      child: Text("Create Account",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontFamily: Fonts.outfit),),
      )
    ],
  );
}