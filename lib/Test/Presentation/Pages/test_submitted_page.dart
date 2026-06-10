import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/Test/Presentation/Bloc/test_bloc.dart';
import 'package:study_mate/Test/Presentation/Bloc/teststates.dart';
import 'package:study_mate/Test/Presentation/Widgets/stat_boc.dart';

class TestSubmittedPage extends StatelessWidget {
  const TestSubmittedPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body:  BlocBuilder<TestBloc,Teststates>(
        builder: (context, state) {
          final mystate = state as TestSubmitted;
          return Container(
          height: height,width: width,
          child: Center(child: Text("Your Test has been successfully Submitted"),),
        );
        } 
      ),
    );
  }
}




Widget _header(double height,double width){
  return Container(
    height: height*0.1,width: width,
    child: Align(
      alignment: Alignment.center,
      child: Text("TestResult")),
  );
}

Widget _scoreArea(double height,double width,int marks,int total){
  return Container(
    height: height*0.4,width: width*0.9,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [Colors.green,Colors.lightGreenAccent]
        ),
        borderRadius: BorderRadius.circular(width*0.03),
    ),
    child: Column(
      children: [
        Container(height: height*0.05,width: height*0.05, 
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        color: Colors.greenAccent,
        child: Icon(Bootstrap.trophy,color: Colors.white,),
        ),

        Text("FINAL SCORE"),

        Row(
          children: [
            Text(marks.toString(),),
            Text("/ $total")
          ],
        ),

        Container(height: 1,width: width*0.8,color: Colors.white,),

        Container(height: height*0.2,width: width*0.7,
        child: Column(
          children: [
            Text("Excellent Work Champ!"),
            Text("You performed better than 90% of students in this test.")
          ],
        ),
        )
      ],
    ),
  );
}


Widget _statArea(double height,double width,int marks, int total,int timeTaken,int timeLeft,int totalTime,String difficulty,int quesSolved){
  String avgTime = (quesSolved/ (timeTaken)).toString();
  String mins = (timeTaken/60).toInt().toString();
  String secs = (timeTaken % 60) < 10 ? "0${(timeTaken % 60).toString()}" : (timeTaken % 60).toString(); 
  return Container(
    height: height*0.3, width: width*0.9,
    child: Column(
      children: [
        Row(
          children: [
            StatBox(height, width, FontAwesome.arrow_down_1_9_solid, "Accuracy", (marks/total).toInt().toString(), "Impove Accuracy by prcaticing problems"),
            SizedBox(width: width*0.1,),
            StatBox(height, width, FontAwesome.bolt_lightning_solid, "Difficulty", difficulty, "Well Done!")
          ],
        ),
        Row(
          children: [
            StatBox(height, width, FontAwesome.stopwatch_solid ,"Avg. Speed", avgTime, "Per Question"),
            SizedBox(width: width*0.1,),
            StatBox(height, width, FontAwesome.clock, "Time Taken", "$mins : $secs", "Of $totalTime minutes")
          ],
        )
      ],
    ),
  );
}


Widget _pieChart(double height,double width,int totalQues,int correctQues,int skippedQues){
  return Container(
    height: height*0.4,width: width*0.8,
    child: PieChart(
      PieChartData(
        sectionsSpace: 5,
        centerSpaceRadius: 50,
        sections: [
          PieChartSectionData(
            value: correctQues.toDouble(),
            color: Colors.green,
            radius: 25,
            title: ''
          ),
          PieChartSectionData(
            value: (totalQues - (correctQues + skippedQues)).toDouble(),
            color: Colors.green,
            radius: 25,
            title: ''
          ),
          PieChartSectionData(
            value: skippedQues.toDouble(),
            color: Colors.green,
            radius: 25,
            title: ''
          )
        ]
      )
      ),
  );
}