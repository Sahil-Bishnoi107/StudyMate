import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestBloc.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestStates.dart';
import 'package:study_mate/Contest/Presentation/Pages/ContestReviewPage.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Bootstrap.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Contest Result", style: TextStyle(color: Colors.black, fontFamily: Fonts.inter, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
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

            return SingleChildScrollView(
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
                  SizedBox(height: 40),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildSummarySection(double width, double height, ContestResultLoaded state, int correct, int total) {
    int ratingChange = state.result.newRating - state.result.prevRating;
    return Container(
      width: width * 0.9,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCol("SCORE", state.result.score.toString(), Colors.black),
              Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
              _buildStatCol("RANK", "#${state.result.rank}", Colors.orange),
              Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
              _buildStatCol("RATING", "${ratingChange >= 0 ? '+' : ''}$ratingChange", ratingChange >= 0 ? Colors.green : Colors.red),
            ],
          ),
          SizedBox(height: 20),
          Container(height: 1, color: Colors.grey.withOpacity(0.2)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text("PREV RATING", style: TextStyle(color: Colors.grey[600], fontSize: 10, fontWeight: FontWeight.bold, fontFamily: Fonts.nunito)),
                  SizedBox(height: 5),
                  Text("${state.result.prevRating}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: Fonts.inter)),
                ],
              ),
              Icon(Bootstrap.arrow_right, color: Colors.grey),
              Column(
                children: [
                  Text("NEW RATING", style: TextStyle(color: Colors.grey[600], fontSize: 10, fontWeight: FontWeight.bold, fontFamily: Fonts.nunito)),
                  SizedBox(height: 5),
                  Text("${state.result.newRating}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green, fontFamily: Fonts.inter)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatCol(String title, String val, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 10, fontWeight: FontWeight.bold, fontFamily: Fonts.nunito)),
        SizedBox(height: 8),
        Text(val, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: Fonts.inter)),
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
            child: Text("Accuracy Analytics", style: TextStyle(fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          SizedBox(height: 30),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: height * 0.2,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 60,
                    sections: [
                      PieChartSectionData(value: correctQues.toDouble(), color: Colors.green, radius: 20, title: ''),
                      PieChartSectionData(value: wrongQues.toDouble(), color: Colors.red, radius: 20, title: ''),
                      PieChartSectionData(value: skippedQues.toDouble(), color: Colors.grey, radius: 20, title: ''),
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
          Text("Subject Breakdown", style: TextStyle(fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: 18)),
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
                      Text("$cor / $tot", style: TextStyle(fontFamily: Fonts.nunito, color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: percent,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    color: Colors.green,
                    minHeight: 8,
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
          color: Colors.black,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text("Review Questions", style: TextStyle(color: Colors.white, fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}
