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
import 'package:study_mate/Test/Presentation/Widgets/question_data.dart';
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
      backgroundColor: Colors.white,
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
                SizedBox(height: height*0.035,),
                _header(height, width),
                Container(height: 2,width: width,color: const Color.fromRGBO(220, 220, 220, 0.8),),
                SizedBox(height: height*0.03,),
                _scoreArea(height, width, correctQues*4, mystate.test.totalQuestions*4),
                SizedBox(height: height*0.03,),
                _statArea(height, width, correctQues, mystate.test.totalQuestions, (mystate.timeTaken), mystate.test.time - mystate.timeTaken,mystate.test.time, "Medium", quesSolved),
                SizedBox(height: height*0.02,),
                _pieChart(height, width, mystate.test.totalQuestions, correctQues, mystate.test.totalQuestions - quesSolved),
                SizedBox(height: height*0.05,),
                _subjectBreakdown(height, width, mystate.correctQuestionsPerSubject, mystate.questionsPerSubject, mystate.questionsSkippedPerSubject),
                SizedBox(height: height*0.03,),
                _retryButton(height, width, context, mystate.test),
                SizedBox(height: height*0.02,),
                _goHome(height, width, context),
                SizedBox(height: height*0.08,),
                
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
    height: height*0.06,width: width,
    padding: EdgeInsets.only(left: width*0.05),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text("Test Result",style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: 18),)),
  );
}

Widget _scoreArea(double height,double width,int marks,int total){
  return Container(
    height: height*0.35,width: width*0.9,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [Color(0xFF17B169),Color(0xFF1DB954)]
        ),
        borderRadius: BorderRadius.circular(width*0.07),
    ),
    child: Column(
      children: [
        SizedBox(height: height*0.02,),
        Container(height: height*0.07,width: height*0.07, 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width*0.03),
          color: const Color.fromRGBO(255, 255, 255, 0.25),
          border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.6))
          ),
        child: Icon(Bootstrap.trophy,color: Colors.white,weight: 900,size: 30,),
        ),

        SizedBox(height: height*0.014,),
        Text("FINAL SCORE",style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,color: Colors.white),),
       
        Container(
          height: height*0.07,width: width*0.8,
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height*0.05,
                alignment: Alignment.bottomCenter,
                child: Text(marks.toString(),style: TextStyle(fontFamily: Fonts.inter,fontSize: 44,fontWeight: FontWeight.bold))),
              Container(
                alignment: Alignment.bottomCenter,
                child: Text(" / $total",style: TextStyle(fontFamily: Fonts.inter,fontSize: 24,fontWeight: FontWeight.bold,color: const Color.fromRGBO(70, 70, 70, 0.6))))
            ],
          ),
        ),
        SizedBox(height: height*0.02),
        Container(height: 1.5,width: width*0.75,color: const Color.fromRGBO(255, 255, 255, 0.5),),
        SizedBox(height: height*0.03),
        Container(height: height*0.1,width: width*0.5,
        child: Column(
          children: [
            Text("Excellent Work Champ!",style: TextStyle(fontFamily: Fonts.nunito,fontSize: 18,fontWeight: FontWeight.bold),),
            Text("You performed better than 90% of students in this test.",style: TextStyle(fontFamily: Fonts.nunito,fontSize: 13,color: const Color.fromRGBO(70, 70, 70, 0.6)),)
          ],
        ),
        )
      ],
    ),
  );
}


Widget _statArea(double height,double width,int marks, int total,int timeTaken,int timeLeft,int totalTime,String difficulty,int quesSolved){
  String avgTime = (quesSolved/ (timeTaken)).toStringAsFixed(2);
  String mins = (timeTaken/60).toInt().toString();
  String secs = (timeTaken % 60) < 10 ? "0${(timeTaken % 60).toString()}" : (timeTaken % 60).toString(); 
  return Container(
    height: height*0.3, width: width*0.9,
    child: Column(
      children: [
        Row(
          children: [
            StatBox(height, width, FontAwesome.arrow_down_1_9_solid, "Accuracy", (marks/total).toInt().toString(), "Impove Accuracy by prcaticing problems"),
            SizedBox(width: width*0.05,),
            StatBox(height, width, FontAwesome.bolt_lightning_solid, "Difficulty", difficulty, "Well Done!")
          ],
        ),
        SizedBox(height: height*0.02,),
        Row(
          children: [
            StatBox(height, width, FontAwesome.stopwatch_solid ,"Avg. Speed", avgTime, "Per Question"),
            SizedBox(width: width*0.05,),
            StatBox(height, width, FontAwesome.clock, "Time Taken", "$mins : $secs", "Of $totalTime minutes")
          ],
        )
      ],
    ),
  );
}


Widget _pieChart(double height,double width,int totalQues,int correctQues,int skippedQues){
  return Container(
    height: height*0.3,width: width*0.8,
    child: Column(
      children: [
        Container(
          height: height*0.03,width: width*0.8,
          child: Text("Performance Summary",style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: 18),),
        ),
        Container(
          height: height*0.03,width: width*0.8,
          child: Text("Breakdown By Subject",style: TextStyle(fontFamily: Fonts.nunito,fontSize: 12,color: Colors.blueGrey),),
        ),
        SizedBox(height: height*0.04,),
        Stack(
          children: [
            Positioned(
              top: height*0.035,left: width*0.36,
              child: Text("${(correctQues*100/(totalQues)).toInt().toString()}%",
              style: TextStyle(fontWeight: FontWeight.bold,fontFamily: Fonts.inter,fontSize: 20,color: const Color.fromRGBO(70, 70, 70, 1)))
              ),
            Container(
              height: height*0.1,width: width*0.8,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 70,
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
          ],
        ),
         SizedBox(height: height*0.05,),
        Container(
          width: width*0.7,
          child: Row(
            spacing: width*0.13,
            children: [
              
              QuestionData(height, width, "CORRECT", correctQues, Colors.green),
              QuestionData(height, width, "WRONG", (totalQues - (correctQues + skippedQues)), Colors.red),
              QuestionData(height, width, "SKIPPED", skippedQues, Colors.blueGrey),
            ],
          ),
        )
      ],
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
    height: height*0.56,width: width*0.9,
    child: Column(
      children: [
        Container(
          height: height*0.04,width: width*0.9,
          child: Row(
            children: [
              Icon(Icons.description_outlined,size: 27,color: Colors.green,),
              SizedBox(width: width*0.02,),
              Text("Subject Breakdown", style: TextStyle(fontFamily: Fonts.nunito,fontSize: 18,fontWeight: FontWeight.bold),),
              SizedBox(width: width*0.2,),
              GestureDetector(
                child: Text("View All",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontFamily: Fonts.inter),),
              )
            ],
          ),
        ),
         SizedBox(height: height*0.02,),
        Container(
          constraints: BoxConstraints(minHeight: height*0.3,maxHeight: height*0.5),
          width: width*0.9,
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
      height: height*0.055,width: width*0.9,
      decoration: BoxDecoration(
        color: Color(0xFF1DB954),
        borderRadius: BorderRadius.circular(
          width*0.1
        )
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.keyboard_double_arrow_left),
            Text("Retake Test",style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: 15),),
            SizedBox(width: width*0.1,)
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
      height: height*0.055,width: width*0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          width*0.1
        ),
        border: Border.all(color: const Color.fromRGBO(200, 200, 200, 0.6),)
      ),
      child: Center(
        child: Text("Go to Home",style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: 14),),
      ),
    ),
  );
}