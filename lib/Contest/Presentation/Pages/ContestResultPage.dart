import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestBloc.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestStates.dart';
import 'package:study_mate/Contest/Presentation/Pages/ContestReviewPage.dart';
import 'package:study_mate/Contest/Presentation/Pages/MyContestsPage.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_data.dart';
import 'package:study_mate/fonts.dart';

class ContestResultPage extends StatelessWidget {
  final MyContest contest;
  
  const ContestResultPage({Key? key, required this.contest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<MyContestBloc, MyContestStates>(
        builder: (context, state) {
          if (state is ContestResultLoading || state is MyContestInitial || state is MyContestLoading || state is MyContestLoaded) {
            return Center(child: LoadingAnimationWidget.beat(color: Colors.green, size: 50));
          }
          if (state is ContestResultError) {
            return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
          }

          if (state is ContestResultLoaded) {
            int totalQues = state.questions.length;
            int correctQues = state.questions.where((q) => q.isCorrect).length;
            int skippedQues = state.questions.where((q) => q.userAnswer == null || q.userAnswer == -1).length;
            int wrongQues = totalQues - (correctQues + skippedQues);

            // Calculate subject breakdown
            Map<String, int> totalPerSub = {};
            Map<String, int> correctPerSub = {};
            for (var q in state.questions) {
              totalPerSub[q.subject] = (totalPerSub[q.subject] ?? 0) + 1;
              if (q.isCorrect) correctPerSub[q.subject] = (correctPerSub[q.subject] ?? 0) + 1;
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: height*0.05,),
                _appBar(height, width, context),
                Container(height: 1,color: const Color.fromRGBO(220, 220, 220, 0.8),width: width,),
            
            
                Expanded(child: SingleChildScrollView(
                  child: Column(
                    children: [
                     SizedBox(height: 10),
                  _buildSummarySection(width, height, state, correctQues, totalQues),
                  SizedBox(height: 30),
                  _buildPieChart(height, width, totalQues, correctQues, skippedQues, wrongQues),
                  SizedBox(height: 30),
                  _buildSubjectBreakdown(height, width, totalPerSub, correctPerSub),
                  SizedBox(height: 40),
                  _buildReviewButton(width, context, state),
                  SizedBox(height: height*0.1),
                    ],
                  ),
                ))
                
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildSummarySection(double width, double height, ContestResultLoaded state, int correct, int total) {
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width*0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Rating",style: TextStyle(color: Colors.green,fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: 25),),
              Text(" Change",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: 25),)
            ],
          ),

          Row(
            children: [
              Text(state.result.prevRating.toString(),style: TextStyle(color: Colors.black,fontFamily: Fonts.outfit,fontWeight: FontWeight.w400,fontSize: 40)),
              SizedBox(width: width*0.05,),
              Icon(Icons.arrow_forward,size:20,color: Colors.blueGrey,),
              SizedBox(width: width*0.05,),
              Text(state.result.newRating.toString(),style: TextStyle(color: Colors.green,fontFamily: Fonts.outfit,fontWeight: FontWeight.w400,fontSize: 40))
            ],
          ),
          SizedBox(height: height*0.02,),
          Row(
            children: [
              Expanded(child: _buildStatCol("Score", "${state.result.score}", Colors.green, height, width, Bootstrap.file_code)),
              Expanded(child: _buildStatCol("Rank", "${state.result.rank}", Colors.blue, height, width, LucideIcons.swords400Dir)),
              Expanded(child: _buildStatCol("Time", "${state.result.duration}", Colors.orange, height, width, Bootstrap.stopwatch)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatCol(String title, String val, Color color,double height,double width,IconData icon) {
    return Row(
      children: [
       Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Icon(icon,color: color,size: 20,)),
        SizedBox(width: 5,),
        Column(
          children: [
            Text(title, style: TextStyle(color: const Color.fromRGBO(110, 110, 110, 1),fontFamily: Fonts.outfit,fontWeight: FontWeight.w400,fontSize: 10),),
            Text(val,style: TextStyle(color: Colors.black,fontFamily: Fonts.outfit,fontWeight: FontWeight.w600),)
          ],
        )
      ],
    );
  }

  Widget _buildPieChart(double height, double width, int totalQues, int correctQues, int skippedQues, int wrongQues) {
    return Container(
      width: width * 0.9,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text("Accuracy", style: TextStyle(fontFamily: Fonts.outfit, fontWeight: FontWeight.w600, fontSize: 22)),
                Text(" Analytics", style: TextStyle(fontFamily: Fonts.outfit, fontWeight: FontWeight.w600, fontSize: 22,color: Colors.green)),
              ],
            ),
          ),
          SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: height * 0.2,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 70,
                    sections: [
                      PieChartSectionData(value: correctQues.toDouble(), color: Colors.green, radius: 15, title: ''),
                      PieChartSectionData(value: wrongQues.toDouble(), color: Colors.red, radius: 15, title: ''),
                      PieChartSectionData(value: skippedQues.toDouble(), color: Colors.grey, radius: 15, title: ''),
                    ]
                  )
                ),
              ),
              Column(
                children: [
                  Text(
                    "${totalQues == 0 ? 0 : (correctQues * 100 / totalQues).toInt()}%",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: Fonts.inter, fontSize: 24, color: Colors.black)
                  ),
                  Text("Accuracy", style: TextStyle(color: Colors.grey[600], fontSize: 10, fontFamily: Fonts.nunito)),
                ],
              )
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              QuestionData(height, width, "CORRECT", correctQues, Colors.green),
              QuestionData(height, width, "WRONG", wrongQues, Colors.red),
              QuestionData(height, width, "SKIPPED", skippedQues, Colors.blueGrey),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSubjectBreakdown(double height, double width, Map<String, int> totalPerSub, Map<String, int> correctPerSub) {
    return Container(
      width: width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Subject ", style: TextStyle(fontFamily: Fonts.outfit, fontWeight: FontWeight.w600, fontSize: 22,color: Colors.green)),
              Text("Breakdown", style: TextStyle(fontFamily: Fonts.outfit, fontWeight: FontWeight.w600, fontSize: 22)),
            ],
          ),
          SizedBox(height: 20),
          ...totalPerSub.keys.map((sub) {
            int tot = totalPerSub[sub]!;
            int cor = correctPerSub[sub] ?? 0;
            double percent = tot == 0 ? 0 : cor / tot;
            return Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(sub, style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: 14)),
                      Text("$cor / $tot", style: TextStyle(fontFamily: Fonts.nunito, color: Colors.black, fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: percent,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    color: Colors.green,
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(4),
                  )
                ],
              ),
            );
          }).toList()
        ],
      ),
    );
  }

  Widget _buildReviewButton(double width, BuildContext context, ContestResultLoaded state) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ContestReviewPage(questions: state.questions)));
      },
      child: Container(
        width: width * 0.9,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text("Review Questions", style: TextStyle(color: Colors.white, fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}


Widget _appBar(double height,double width,BuildContext context){
  return SizedBox(
    height: height*0.05,
    child: Row(
      children: [
        SizedBox(width: width*0.05,),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MyContestsPage())),
          child: Icon(Bootstrap.chevron_left)),
        SizedBox(width: width*0.05,),
        Text("Contest Result",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: 18),)
    
      ],
    ),
  );
}