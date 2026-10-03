import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Contest/Domain/ContestResult.dart';
import 'package:study_mate/Contest/Domain/ContestResultQuestion.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContest/MyContestStates.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestResult/MyContestResultBloc.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestResult/MyContestResultState.dart';
import 'package:study_mate/Contest/Presentation/Pages/ContestReviewPage.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
import 'package:study_mate/Test/Presentation/Widgets/stat_boc.dart';
import 'package:study_mate/Test/Presentation/Widgets/subject_breakdown_tile.dart';
import 'package:study_mate/fonts.dart';

class ContestResultPage extends StatelessWidget {
  final MyContest contest;

  const ContestResultPage({super.key, required this.contest});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<MyContestResultBloc, MyContestResultState>(
        builder: (context, state) {
          if (state is ContestResultLoading || state is InitialMyContestResultState ||  state is MyContestLoaded) {
            return Center(child: LoadingLogo());
          }
          if (state is ContestResultError) {
            return Center(child: Text(state.message, style: TextStyle(color: Colors.red, fontFamily: Fonts.nunito)));
          }

          if (state is ContestResultLoaded) {
            int totalQues = state.questions.length;
            int correctQues = state.questions.where((q) => q.isCorrect).length;
            int skippedQues = state.questions.where((q) => q.userAnswer == null || q.userAnswer == -1).length;
            int wrongQues = totalQues - (correctQues + skippedQues);

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
                          _header(height, width, state.result.contestName, context),
                          SizedBox(height: height*0.02,),
                          _ratingArea(height, width, state.result, context),
                          SizedBox(height: height*0.015,),
                          _statArea(height, width, state.result, contest, context),
                          _divider(height, width),
                          _pieChart(height, width, totalQues, correctQues, skippedQues, wrongQues, context),
                          _divider(height, width),
                          _subjectBreakdown(height, width, state.questions, context),
                          SizedBox(height: height*0.02,),
                          _reviewButton(height, width, context, state.questions),
                          SizedBox(height: height*0.06,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
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
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(LucideIcons.chevronLeft400Dir,size: Responsive.icon(context, 25),)),
        SizedBox(width: width*0.05,),
        Expanded(child: Text("Contest Result",style: TextStyle(color: Colors.black,fontFamily: Fonts.rubik,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 20)),)),
      ],
    ),
  );
}

Widget _divider(double height,double width){
  return Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,margin: EdgeInsets.symmetric(horizontal: width*0.05,vertical: height*0.03),);
}

Widget _header(double height,double width,String contestName,BuildContext context){
  return Padding(
    padding: EdgeInsets.only(top: height*0.03,left: width*0.05,right: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Rating",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.green),),
            Text(" Change",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.black),),
            Text(".",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.green),),
          ],
        ),
        Text(contestName,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 11),color: const Color.fromRGBO(110, 110, 110, 1)),),
      ],
    ),
  );
}

// dark card, same as the score card on the test result page
Widget _ratingArea(double height,double width,ContestResult result,BuildContext context){
  int change = result.newRating - result.prevRating;
  Color color = change >= 0 ? Colors.green : Colors.red;

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
              Text("NEW RATING",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10),fontWeight: FontWeight.bold,color: Colors.green,letterSpacing: 1),),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(result.newRating.toString(),style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 44),fontWeight: FontWeight.w600,color: Colors.white),),
                  SizedBox(width: width*0.03,),
                  Text("${change >= 0 ? '+' : ''}$change",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 18),fontWeight: FontWeight.w600,color: color),),
                ],
              ),
              Row(
                children: [
                  Text(result.prevRating.toString(),style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 13),fontWeight: FontWeight.w600,color: const Color.fromRGBO(160, 160, 160, 1)),),
                  SizedBox(width: width*0.02,),
                  Icon(LucideIcons.arrowRight400Dir,size: Responsive.icon(context, 14),color: const Color.fromRGBO(160, 160, 160, 1),),
                  SizedBox(width: width*0.02,),
                  Text(result.newRating.toString(),style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 13),fontWeight: FontWeight.w600,color: Colors.white),),
                ],
              ),
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

Widget _statArea(double height,double width,ContestResult result,MyContest contest,BuildContext context){
  String difficulty = result.difficulty;
  if(difficulty.length > 1){difficulty = difficulty[0].toUpperCase() + difficulty.substring(1);}

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      children: [
        StatBox(height, width, LucideIcons.target400Dir, Colors.green, "Score", result.score.toString(), "Marks you scored in this contest",context),
        Container(color: const Color.fromRGBO(220, 220, 220, 0.5),height: 1,),
        StatBox(height, width, LucideIcons.swords400Dir, Colors.blue, "Rank", "#${result.rank}", "Out of ${contest.participants} participants",context),
        Container(color: const Color.fromRGBO(220, 220, 220, 0.5),height: 1,),
        StatBox(height, width, LucideIcons.zap400Dir, Colors.orange, "Difficulty", difficulty, "Level of this contest",context),
        Container(color: const Color.fromRGBO(220, 220, 220, 0.5),height: 1,),
        StatBox(height, width, LucideIcons.timer400Dir, Colors.red, "Duration", "${result.duration} mins", "Length of this contest",context),
      ],
    ),
  );
}

Widget _pieChart(double height,double width,int totalQues,int correctQues,int skippedQues,int wrongQues,BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.chartPie400Dir,size: Responsive.icon(context, 20),),
            const SizedBox(width: 8),
            Text("Accuracy ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.green),),
            Text("Analytics",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.black),),
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

Widget _subjectBreakdown(double height,double width,List<ContestResultQuestion> questions,BuildContext context){
  Map<String,int> totalPerSub = {};
  Map<String,int> correctPerSub = {};
  Map<String,int> wrongPerSub = {};
  for(var q in questions){
    totalPerSub[q.subject] = (totalPerSub[q.subject] ?? 0) + 1;
    if(q.isCorrect){correctPerSub[q.subject] = (correctPerSub[q.subject] ?? 0) + 1;}
    else if(q.userAnswer != null && q.userAnswer != -1){wrongPerSub[q.subject] = (wrongPerSub[q.subject] ?? 0) + 1;}
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
        for(String sub in totalPerSub.keys)
          SubjectBreakdownTile(height, width, correctPerSub[sub] ?? 0, wrongPerSub[sub] ?? 0, totalPerSub[sub] ?? 0, sub,context),
      ],
    ),
  );
}

Widget _reviewButton(double height,double width,BuildContext context,List<ContestResultQuestion> questions){
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ContestReviewPage(questions: questions)));
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
