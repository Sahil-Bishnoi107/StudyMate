import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/Home/Presentation/Pages/Homepage.dart';
import 'package:study_mate/Test/Domain/Entities/test.dart';
import 'package:study_mate/Test/Presentation/Bloc/test_bloc.dart';
import 'package:study_mate/Test/Presentation/Bloc/testevents.dart';
import 'package:study_mate/Test/Presentation/Bloc/teststates.dart';
import 'package:study_mate/Test/Presentation/Pages/test.dart';
import 'package:study_mate/Test/Presentation/Widgets/stat_boc.dart';
import 'package:study_mate/Test/Presentation/Widgets/subject_breakdown_tile.dart';
import 'package:study_mate/fonts.dart';

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
          int correctQues = 0;
          int quesSolved = 0;
          for(Question q in mystate.test.questions){
             if(q.selectedOption == q.correctOption){correctQues++; quesSolved++;continue;}
             if(q.selectedOption == null)continue;
             quesSolved++;
          }
          return SingleChildScrollView(
            child: Container(
            width: width,
            child: Column(
              children: [
                _header(height, width),
                SizedBox(height: height*0.05,),
                _scoreArea(height, width, correctQues*4, mystate.test.totalQuestions*4),
                SizedBox(height: height*0.03,),
                _statArea(height, width, correctQues, mystate.test.totalQuestions, (mystate.timeTaken), mystate.test.time - mystate.timeTaken,mystate.test.time, "Medium", quesSolved),
                SizedBox(height: height*0.05,),
                _pieChart(height, width, mystate.test.totalQuestions, correctQues, mystate.test.totalQuestions - quesSolved),
                SizedBox(height: height*0.05,),
                _subjectBreakdown(height, width, mystate.correctQuestionsPerSubject, mystate.questionsPerSubject, mystate.questionsSkippedPerSubject),
                SizedBox(height: height*0.03,),
                _retryButton(height, width, context, mystate.test),
                SizedBox(height: height*0.04,),
                _goHome(height, width, context)

              ],
            ) ),
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
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.greenAccent,),
        
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
    
    child: Container(
      height: height*0.4,width: width*0.8,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 50,
          sections: [
            
            PieChartSectionData(
              value: correctQues.toDouble(),
              color: Colors.green,
              radius: 20,
              title: ''
            ),
            
            PieChartSectionData(
              value: (totalQues - (correctQues + skippedQues)).toDouble(),
              color: Colors.red,
              radius: 20,
              title: ''
            ),
            
            PieChartSectionData(
              value: skippedQues.toDouble(),
              color: Colors.grey,
              radius: 20,
              title: ''
            ),
            
          ]
        )
        ),
    ),
  );
}


Widget _subjectBreakdown(double height,double width,Map<String,int> correctQues, Map<String,int> totalQues,Map<String,int> skippedQues){
  List<String> subjects = [];
  List<int> correct = [];
  List<int> total = [];
  List<int> wrong = [];
  totalQues.forEach((key,value){
   subjects.add(key);
  });
  for(var s in subjects){
     correct.add(correctQues[s] ?? 0);
     total.add(totalQues[s] ?? 0);
     int incorrect = (totalQues[s] ?? 0) - (correctQues[s] ?? 0) - (skippedQues[s] ?? 0);
     wrong.add(incorrect);
  }

  return Container(
    height: height*0.4,width: width*0.9,
    child: Column(
      children: [
        Container(
          height: height*0.04,width: width*0.9,
          child: Row(
            children: [
              Icon(FontAwesome.book_atlas_solid,size: 20,color: Colors.green,),
              SizedBox(width: width*0.02,),
              Text("Subject Breakdown", style: TextStyle(fontFamily: Fonts.nunito,fontSize: 12,fontWeight: FontWeight.bold),),

              GestureDetector(
                child: Text("View All",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
              )
            ],
          ),
        ),

        Container(
          height: height*0.3,width: width*0.9,
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: total.length,
            itemBuilder: (context, index) {
             return SubjectBreakdownTile(height, width, correct[index], wrong[index], total[index], subjects[index]);
            },
          ),
        )
      ],
    ),
  );
}



Widget _retryButton(double height,double width,BuildContext context,Test test){
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TestBloc>()..add(RetakeTest(test: test)),
          child: GiveTest(),
          )         
          ));
    },
    child: Container(
      height: height*0.04,width: width*0.9,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(
          width*0.04
        )
      ),
      child: Center(
        child: Row(
          children: [
            Icon(Icons.keyboard_double_arrow_left),
            Text("Retake Test")
          ],
        ),
      ),
    ),
  );
}


Widget _goHome(double height,double width,BuildContext context){
  return GestureDetector(
    onTap: () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
    },
    child: Container(
      height: height*0.04,width: width*0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          width*0.04
        ),
        border: Border.all()
      ),
      child: Center(
        child: Row(
          children: [
          
            Text("Go to Home")
          ],
        ),
      ),
    ),
  );
}