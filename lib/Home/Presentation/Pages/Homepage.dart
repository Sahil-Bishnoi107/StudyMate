import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:study_mate/Home/Domain/Entities/Test.dart';
import 'package:study_mate/Home/Presentation/Bloc/HomeBloc.dart';
import 'package:study_mate/Home/Presentation/Bloc/homeStates.dart';
import 'package:study_mate/Home/Presentation/Widgets/drawer.dart';
import 'package:study_mate/Home/Presentation/Widgets/line_chart.dart';
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
      backgroundColor: Colors.white,
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
            List<int> data = [0,0,0,0,0,0,0];
            for(int i = 0; i < state.student.testsGiven.length;i++){
              if(i == 7)break;
              data[6-i] = (state.student.testsGiven[i].correctQuestions*100/state.student.testsGiven[i].totalQuestions).toInt();
            } 
            int percentage = state.student.attemptedQuestions != 0 ? (state.student.correctQuestions*100/state.student.attemptedQuestions).round() : 0;
            return SingleChildScrollView(
              child: Column(
              children: [
              Topbar(),
              Container(color: const Color.fromRGBO(190, 190, 190, 0.5),height: 1.5,width: width,),
              SizedBox(height: height*0.02,),
              ProfileSection(name: state.student.name, picUrl: state.student.pic),
              SizedBox(height: height*0.05,),
              _statSection(width, height, percentage , state.student.attemptedQuestions, state.student.rank, state.student.testsGiven.length),
              SizedBox(height: height*0.03,),
              _chart(height, width, data),
              SizedBox(height: height*0.03,),
              _testsList(height, width, state.student.testsGiven),
              SizedBox(height: height*0.02,),
              _bottomCard(height, width),
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
           Statbox(icon: FontAwesome.check_double_solid, heading: "Accuracy", stat: percentage.toString() + "%"),
           SizedBox(width: width*0.055,),
           Statbox(icon: Bootstrap.patch_question_fill, heading: "Questions", stat: attemptedQuestions.toString() + " Ques")
          ],
        ),
        SizedBox(height: height*0.025,),
        Row(
          children: [
            Statbox(icon: Bootstrap.clipboard2_check_fill, heading: "Tests Given", stat: testsGiven.toString() + " Tests"),
            SizedBox(width: width*0.055,),
            Statbox(icon: FontAwesome.chart_line_solid, heading: "Rank", stat: "#" + rank.toString())
          ],
        )
      ],
    ),
  );
}

Widget _testsList(double height,double width,List<TestGiven> tests){
  return Container(
    constraints: BoxConstraints(minHeight: height*0.1, maxHeight : height*0.56),
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [ 
        Container(
          width: width,
          child: Text("Recent Tests",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: 18),)),
          SizedBox(height: height*0.01,),
    
        (tests.isNotEmpty) ? 
         Container(
        constraints: BoxConstraints(minHeight: height*0.1, maxHeight : height*0.5),
      
        child:   ListView.builder(
          itemCount: tests.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: height*0.01),
          itemBuilder: (context,index){
            return Testtile(test: tests[index]);
          }),
      )  :  
     SizedBox(
      height: height*0.1,width: width,
      child: Center(child: Text("You haven't given any test yet",style: TextStyle(fontFamily: Fonts.nunito),))),
      ]
    ),
  );
}


Widget _chart(double height, double width, List<int> data){
  return Material(
    color: Colors.white,
    elevation: 0.1,
    borderRadius: BorderRadius.circular(10),
    child: SizedBox(
      height: height*0.36,width: width*0.9,
      child: Column(
        children: [
          SizedBox(height: height*0.015,),
          SizedBox(
            height: height*0.1,width: width*0.9,
            child: Row(              
              children: [
                SizedBox(width: width*0.05,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Text("Performance Trend",style: TextStyle(fontSize: 20,fontFamily: Fonts.outfit,fontWeight: FontWeight.w600),),
                    Text("Weekly Score Overview",style: TextStyle(fontSize: 12,fontFamily: Fonts.nunito,color: Colors.blueGrey),)
                  ],
                ),
                SizedBox(width: width*0.1,),
                Container(
                  margin: EdgeInsets.only(bottom: height*0.045),
                  height: height*0.03,width: width*0.25,
                  decoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(76, 175, 80, 0.3),width: 1.5),borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text("Last 7 Days",style: TextStyle(color: Colors.green,fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: 12),)),
                )
              ],
            ),
          ),
          homePageChart(height, width, data)
        ],
      ),
    ),
  );
}


Widget _bottomCard(double height,double width){
  return Container(
   height: height*0.18,width: width*0.9,
   padding: EdgeInsets.only(left: width*0.07,right: width*0.07),
   decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(20)),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: height*0.02,),
      Text("Unlock Pro Analytics",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.bold,fontSize: 18),),
     // SizedBox(height: height*0.005,),
      Text("Get Personalized Study Plans and deep dive into your test performance",style: TextStyle(fontFamily: Fonts.nunito,fontSize: 12),),
      SizedBox(height: height*0.015,),
      Container(
        height: height*0.05,width: width*0.75,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Center(child: Text("Go Premium Now",style: TextStyle(color: Colors.green,fontFamily: Fonts.outfit,fontWeight: FontWeight.bold,fontSize: 15),)),
      )
    ],
   ),
  );
}