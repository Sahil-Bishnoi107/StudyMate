import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/Home/Presentation/Pages/Homepage.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
import 'package:study_mate/Test/Data/test_repo.dart';
import 'package:study_mate/Test/Domain/Entities/test.dart';
import 'package:study_mate/Test/Presentation/Bloc/SubmitBloc/SubmitBloc.dart';
import 'package:study_mate/Test/Presentation/Bloc/SubmitBloc/SubmitStates.dart';
import 'package:study_mate/Test/Presentation/Bloc/ReviewBloc/ReviewBloc.dart';
import 'package:study_mate/Test/Presentation/Bloc/ReviewBloc/ReviewEvents.dart';
import 'package:study_mate/Test/Presentation/Bloc/test_bloc.dart';
import 'package:study_mate/Test/Presentation/Bloc/testevents.dart';
import 'package:study_mate/Test/Presentation/Pages/test.dart';
import 'package:study_mate/Test/Presentation/Pages/test_review.dart';
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
      body: BlocBuilder<Submitbloc,Submitstates>(
        builder: (context, state) {
          if (state is InitialSubmitState || state is TestSubmitting) {
            return  Center(child: LoadingLogo());
          }
          if (state is FailedToSubmitTest) {
            return Center(child: Text("Failed to submit test.", style: TextStyle(color: Colors.red, fontFamily: Fonts.nunito)));
          }
          if(state is! TestSubmitted){
            return const SizedBox.shrink();
          }
          final mystate = state;
          int correctQues = 0;
          int quesSolved = 0;
          for(Question q in mystate.test.questions){
             if(q.selectedOption == q.correctOption){correctQues++; quesSolved++;continue;}
             if(q.selectedOption == null)continue;
             quesSolved++;
          }
          return SafeArea(
            child: Column(
              children: [
                SizedBox(height: height*0.008,),
                _appBar(height, width, context),
                Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,width: width,),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _header(height, width, mystate.test.name, context),
                        SizedBox(height: height*0.02,),
                        _scoreArea(height, width, correctQues, mystate.test.totalQuestions, context),
                        SizedBox(height: height*0.015,),
                        _statArea(height, width, correctQues, mystate.test.totalQuestions, mystate.timeTaken, mystate.test.time, mystate.test.diffiucluty, quesSolved, context),
                        _divider(height, width),
                        _pieChart(height, width, mystate.test.totalQuestions, correctQues, mystate.test.totalQuestions - quesSolved, context),
                        _divider(height, width),
                        _subjectBreakdown(height, width, mystate.correctQuestionsPerSubject, mystate.questionsPerSubject, mystate.questionsSkippedPerSubject, context),
                        SizedBox(height: height*0.02,),
                        _reviewButton(height, width, context, mystate.test),
                        SizedBox(height: height*0.012,),
                        _retryButton(height, width, context, mystate.test),
                        SizedBox(height: height*0.012,),
                        _goHome(height, width, context),
                        SizedBox(height: height*0.06,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

Widget _appBar(double height,double width,BuildContext context){
  return Container(
    height: height*0.05,
    margin: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Row(
      children: [
        Expanded(child: Text("Test Result",style: TextStyle(color: Colors.black,fontFamily: Fonts.rubik,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 20)),)),
      ],
    ),
  );
}

Widget _divider(double height,double width){
  return Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,margin: EdgeInsets.symmetric(horizontal: width*0.05,vertical: height*0.03),);
}

Widget _header(double height,double width,String testName,BuildContext context){
  return Padding(
    padding: EdgeInsets.only(top: height*0.03,left: width*0.05,right: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Test",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.black),),
            Text(" Submitted",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.green),),
            Text(".",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.black),),
          ],
        ),
        Text(testName,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 11),color: const Color.fromRGBO(110, 110, 110, 1)),),
      ],
    ),
  );
}

// dark card, same colour as the app logo box
Widget _scoreArea(double height,double width,int correctQues,int totalQues,BuildContext context){
  int accuracy = (correctQues*100/(totalQues != 0 ? totalQues : 1)).toInt();
  String message = "Keep practicing, you will get there";
  if(accuracy >= 50){message = "Good effort, keep pushing";}
  if(accuracy >= 80){message = "Excellent work, champ!";}

  return Container(
    width: width*0.9,
    margin: EdgeInsets.symmetric(horizontal: width*0.05),
    padding: EdgeInsets.symmetric(horizontal: width*0.05,vertical: height*0.022),
    decoration: BoxDecoration(
      color: const Color.fromRGBO(30, 30, 30, 1),
      borderRadius: BorderRadius.circular(Responsive.icon(context, 3))
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("FINAL SCORE",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10),fontWeight: FontWeight.bold,color: Colors.green,letterSpacing: 1),),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text((correctQues*4).toString(),style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 44),fontWeight: FontWeight.w600,color: Colors.white),),
                  Text(" / ${totalQues*4}",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 18),fontWeight: FontWeight.w600,color: const Color.fromRGBO(160, 160, 160, 1)),),
                ],
              ),
              Text(message,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 13),fontWeight: FontWeight.w600,color: Colors.white),),
              Text("You got $correctQues of $totalQues questions right",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 10),color: const Color.fromRGBO(160, 160, 160, 1)),),
            ],
          ),
        ),
        SizedBox(height: height*0.09,width: height*0.09,
        child: Image.asset("assets/images/trophy (1).png"),
        ),
      ],
    ),
  );
}

Widget _statArea(double height,double width,int correctQues,int totalQues,int timeTaken,int totalTime,String difficulty,int quesSolved,BuildContext context){
  String avgTime = quesSolved != 0 ? "${(timeTaken/quesSolved).toStringAsFixed(1)}s" : "-";
  String mins = (timeTaken/60).toInt().toString();
  String secs = (timeTaken % 60) < 10 ? "0${(timeTaken % 60).toString()}" : (timeTaken % 60).toString();
  if(difficulty.length > 1){difficulty = difficulty[0].toUpperCase() + difficulty.substring(1);}

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      children: [
        StatBox(height, width, LucideIcons.target400Dir, Colors.green, "Accuracy", "${(correctQues*100/(totalQues != 0 ? totalQues : 1)).toInt()}%", "$quesSolved of $totalQues questions attempted",context),
        Container(color: const Color.fromRGBO(220, 220, 220, 0.5),height: 1,),
        StatBox(height, width, LucideIcons.zap400Dir, Colors.orange, "Difficulty", difficulty, "Level of this test",context),
        Container(color: const Color.fromRGBO(220, 220, 220, 0.5),height: 1,),
        StatBox(height, width, LucideIcons.gauge400Dir, Colors.blue, "Avg. Speed", avgTime, "Time spent per attempted question",context),
        Container(color: const Color.fromRGBO(220, 220, 220, 0.5),height: 1,),
        StatBox(height, width, LucideIcons.timer400Dir, Colors.red, "Time Taken", "$mins : $secs", "Out of $totalTime minutes",context),
      ],
    ),
  );
}

Widget _pieChart(double height,double width,int totalQues,int correctQues,int skippedQues,BuildContext context){
  int wrongQues = totalQues - (correctQues + skippedQues);
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.chartPie400Dir,size: Responsive.icon(context, 20),),
            const SizedBox(width: 8),
            Text("Performance ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.green),),
            Text("Summary",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.black),),
          ],
        ),
        SizedBox(height: height*0.015,),
        Center(
          child: SizedBox(
            height: width*0.62,width: width*0.62,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: width*0.22,
                    sections: [
                      PieChartSectionData(value: correctQues.toDouble(),color: Colors.green,radius: width*0.06,title: ''),
                      PieChartSectionData(value: wrongQues.toDouble(),color: Colors.red,radius: width*0.06,title: ''),
                      PieChartSectionData(value: skippedQues.toDouble(),color: const Color.fromRGBO(200, 200, 200, 1),radius: width*0.06,title: ''),
                    ]
                  )
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${(correctQues*100/(totalQues != 0 ? totalQues : 1)).toInt()}%",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 38),color: Colors.black,height: 1.1),),
                    Text("CORRECT",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10),fontWeight: FontWeight.bold,color: Colors.blueGrey,letterSpacing: 1),),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: height*0.02,),
        Row(
          children: [
            Expanded(child: _legend(height, width, Colors.green, "Correct", correctQues, context)),
            Container(color: const Color.fromRGBO(220, 220, 220, 0.8),width: 1,height: height*0.045,),
            Expanded(child: _legend(height, width, Colors.red, "Wrong", wrongQues, context)),
            Container(color: const Color.fromRGBO(220, 220, 220, 0.8),width: 1,height: height*0.045,),
            Expanded(child: _legend(height, width, const Color.fromRGBO(200, 200, 200, 1), "Skipped", skippedQues, context)),
          ],
        ),
      ],
    ),
  );
}

Widget _legend(double height,double width,Color color,String name,int stat,BuildContext context){
  return Column(
    children: [
      Text(stat.toString(),style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 22),color: Colors.black,height: 1.1),),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: height*0.01,width: height*0.01,color: color,),
          SizedBox(width: width*0.015,),
          Text(name,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),color: Colors.blueGrey),),
        ],
      ),
    ],
  );
}

Widget _subjectBreakdown(double height,double width,Map<String,int> correctQues, Map<String,int> totalQues,Map<String,int> skippedQues,BuildContext context){
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

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      children: [
        Row(
          children: [
            Icon(LucideIcons.notepadText400Dir,size: Responsive.icon(context, 20),),
            const SizedBox(width: 8),
            Text("Subject ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.green),),
            Expanded(child: Text("Breakdown",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.black),)),
  
          ],
        ),
        SizedBox(height: height*0.015,),
        for(int index = 0;index < total.length;index++)
          SubjectBreakdownTile(height, width, correct[index], wrong[index], total[index], subjects[index],context),
      ],
    ),
  );
}

Widget _reviewButton(double height,double width,BuildContext context,Test test){
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ReviewBloc()..add(LoadReviewEvent(test: test)),
          child: TestReview(),
          )
        ));
    },
    child: Container(
      height: height*0.05,
      margin: EdgeInsets.symmetric(horizontal: width*0.05),
      decoration: BoxDecoration(color: const Color.fromRGBO(30, 30, 30, 1),borderRadius: BorderRadius.circular(Responsive.icon(context, 3))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.listChecks400Dir,color: Colors.white,size: Responsive.icon(context, 18),),
          SizedBox(width: width*0.02,),
          Text("Review Answers",style: TextStyle(color: Colors.white,fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 14)),),
        ],
      ),
    ),
  );
}

Widget _retryButton(double height,double width,BuildContext context,Test test){
  return GestureDetector(
    onTap: () {
      for(int i = 0;i < test.questions.length;i++){
        test.questions[i].selectedOption = null;
      }
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => TestBloc(sl<TestRepo>())..add(RetakeTestEvent(test: test)),
          child: GiveTest(),
          )
          ));
    },
    child: Container(
      height: height*0.05,
      margin: EdgeInsets.symmetric(horizontal: width*0.05),
      decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(Responsive.icon(context, 3))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.rotateCcw400Dir,color: Colors.white,size: Responsive.icon(context, 18),),
          SizedBox(width: width*0.02,),
          Text("Retake Test",style: TextStyle(color: Colors.white,fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 14)),),
        ],
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
      height: height*0.05,
      margin: EdgeInsets.symmetric(horizontal: width*0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.icon(context, 3)),
        border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8))
      ),
      child: Center(
        child: Text("Go to Home",style: TextStyle(color: Colors.black,fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 14)),),
      ),
    ),
  );
}
