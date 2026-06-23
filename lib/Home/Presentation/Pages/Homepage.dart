import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:study_mate/Home/Domain/Entities/Test.dart';
import 'package:study_mate/Home/Presentation/Bloc/HomeBloc.dart';
import 'package:study_mate/Home/Presentation/Bloc/homeStates.dart';
import 'package:study_mate/Home/Presentation/Widgets/drawer.dart';
import 'package:study_mate/Home/Presentation/Widgets/profilesection.dart';
import 'package:study_mate/Home/Presentation/Widgets/statBox.dart';
import 'package:study_mate/Home/Presentation/Widgets/testtile.dart';
import 'package:study_mate/Home/Presentation/Widgets/topbar.dart';
import 'package:study_mate/fonts.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      
      drawer: mainDrawer(height, width, context),
      body: BlocBuilder<Homebloc,Homestates>(
        builder: (context, state) {
          if(state is HomeInitial){
            return Container(
              child: Center(
                child: LoadingAnimationWidget.beat(color: Colors.green, size: 50),
              ),
            );
          }
          if(state is HomeDataRecieved) {
            int percentage = state.student.attemptedQuestions != 0 ? (state.student.correctQuestions*100/state.student.attemptedQuestions).round() : 0;
            return SingleChildScrollView(
              child: Column(
              children: [
              Topbar(),
              Container(color: const Color.fromRGBO(190, 190, 190, 1),height: 1,width: width,),
              SizedBox(height: height*0.03,),
              ProfileSection(name: state.student.name, picUrl: state.student.pic),
              SizedBox(height: height*0.05,),
              _statSection(width, height, percentage , state.student.attemptedQuestions, state.student.rank, state.student.testsGiven.length),
              SizedBox(height: height*0.03,),
              _testsList(height, width, state.student.testsGiven),
              SizedBox(height: height*0.1,)
                        ],
                      ),
            );
        }
        return Container(
         height: height,width: width,
         child: Center(child: Text("Unexpected Error. Please Try Opening the App again",style: TextStyle(color: Colors.red),),),
        );
        }
        )
    );
  }
}


















Widget _statSection(double width,double height,int percentage,int attemptedQuestions,int rank,int testsGiven){
  return Container(
    width: width,
    padding: EdgeInsets.only(left: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
           Statbox(icon: Bootstrap.bullseye, heading: "Accuracy", stat: percentage.toString() + "%"),
           SizedBox(width: width*0.07,),
           Statbox(icon: Bootstrap.file_earmark_arrow_down_fill, heading: "Questions", stat: attemptedQuestions.toString() + " Ques")
          ],
        ),
        SizedBox(height: height*0.025,),
        Row(
          children: [
            Statbox(icon: Bootstrap.p_circle_fill, heading: "Tests Given", stat: testsGiven.toString() + " Tests"),
            SizedBox(width: width*0.07,),
            Statbox(icon: Bootstrap.trophy, heading: "Rank", stat: "#" + rank.toString())
          ],
        )
      ],
    ),
  );
}

Widget _testsList(double height,double width,List<TestGiven> tests){
  return Container(
    height: height*0.4,width : width,
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      children: [ 
        Container(
          width: width,
          child: Text("Recent Tests",style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: 18),)),
    
        Container(
        height: height*0.4,width: width,
      
        child: ListView.builder(
          itemCount: tests.length,
          padding: EdgeInsets.only(top: height*0.01),
          itemBuilder: (context,index){
            return Testtile(test: tests[index]);
          }),
      ),
      
    
      
      ]
    ),
  );
}