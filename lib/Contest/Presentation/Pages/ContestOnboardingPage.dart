import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/Contest/Data/ContestRepo.dart';
import 'package:study_mate/Contest/Domain/Contest.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestQuestions/ContestQuestionBloc.dart';
import 'package:study_mate/Contest/Presentation/Pages/ContestQuestionPage.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';
import 'package:study_mate/fonts.dart';

class ContestOnboardingPage extends StatelessWidget {
  final Contest contest;

  const ContestOnboardingPage({super.key, required this.contest});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isUpcoming = DateTime.now().isBefore(contest.startTime);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Bootstrap.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Test Information", style: TextStyle(color: Colors.black, fontFamily: Fonts.inter, fontSize: Responsive.font(context, 16), fontWeight:   FontWeight.bold)),
        
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, bottom: 100),
              children: [
    
                _headerSection(height, width, contest,context),
                SizedBox(height: 20),
                _statsSection(contest, width,context),
                SizedBox(height: 25),
                _aboutContest(context),            
                SizedBox(height: 25),
                _instructions(width,height,context),
                // Instructions

                SizedBox(height: 25),
               _scoringSystem(contest,context),
                // Scoring System
              
                SizedBox(height: 15),
                _ratingSystem(context),
                SizedBox(height: 20),
              ],
            ),
        
            // Start Button pinned to bottom
            if (!isUpcoming)
             _startButton(context, contest)
          ],
        ),
      ),
    );
  }




  
}





Widget _headerSection(double height,double width, Contest contest,BuildContext context){
  return    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contest.contestName,
                          style: TextStyle(fontFamily: Fonts.outfit, fontSize: Responsive.font(context, 21), fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text("Subject :",style: TextStyle(fontFamily: Fonts.nunito, color: Colors.grey[600], fontSize: Responsive.font(context, 12))),
                            SizedBox(width: 5),
                            Text(
                              contest.subject,
                              style: TextStyle(fontFamily: Fonts.nunito, color: Colors.grey[600], fontSize: Responsive.font(context, 12)),
                            ),
                          ],
                        )
                      ],
                    ),
                 
                  ],
                );
}


Widget _statsSection(Contest contest,double width,BuildContext context){
  return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatBox(width * 0.28, "DURATION", "${contest.duration}m", Bootstrap.clock,context),
                    _buildStatBox(width * 0.28, "QUESTIONS", "${contest.marksPerQuestion * 10} Qs", Bootstrap.question_circle,context),
                    _buildStatBox(width * 0.28, "REC. RATING", "1600+", Bootstrap.graph_up,context),
                  ],
                );
}

  Widget _buildStatBox(double width, String title, String value, IconData icon,BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2),width: 1.4),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(color: const Color.fromRGBO(76, 175, 80, 0.1), borderRadius: BorderRadius.circular(50)),
            child: Icon(icon, color: Colors.green, size: Responsive.icon(context, 20))),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: Responsive.font(context, 9), color: Colors.grey[600], fontWeight: FontWeight.bold, fontFamily: Fonts.nunito)),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: Responsive.font(context, 14), fontWeight: FontWeight.bold, fontFamily: Fonts.inter)),
        ],
      ),
    );
  }

  Widget _aboutContest(BuildContext context){
    return Column(
      children: [
         Row(
                  children: [
                    Icon(Bootstrap.info_circle, color: Colors.green, size: Responsive.icon(context, 16), fontWeight: FontWeight.bold,),
                    SizedBox(width: 8),
                    Text("ABOUT CONTEST", style: TextStyle(fontFamily: Fonts.outfit, color: Colors.grey[700], fontSize: Responsive.font(context, 12), fontWeight: FontWeight.w600)),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.2),width: 1.5),
                  ),
                  child: Text(
                    "This mock cup is designed to simulate the rigorous environment of the actual exam. Questions focus on application-based concepts. Ensure a stable environment before starting.",
                    style: TextStyle(fontFamily: Fonts.nunito, color: Colors.black, height: 1.5, fontSize: Responsive.font(context, 13)),
                  ),
                ),
      ],
    );
  }


  Widget _instructions(double width,double height,BuildContext context){
    return Column(
      children: [
                  Row(
                  children: [
                    Icon(Bootstrap.file_earmark_text, color: Colors.green, size: Responsive.icon(context, 16), fontWeight: FontWeight.bold,),
                    SizedBox(width: 8),
                    Text("INSTRUCTIONS", style: TextStyle(fontFamily: Fonts.outfit, color: Colors.grey[700], fontSize: Responsive.font(context, 12), fontWeight: FontWeight.w600)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInstructionCard(width * 0.43, Bootstrap.clock, "Timer cannot be paused", Colors.green,height,context),
                    _buildInstructionCard(width * 0.43, Bootstrap.wifi, "Internet connection required", Colors.green,height,context),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInstructionCard(width * 0.43, Bootstrap.bullseye, "Negative marking active", Colors.green,height,context),
                    _buildInstructionCard(width * 0.43, Bootstrap.box_arrow_right, "Don't leave the screen", Colors.green,height,context),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: width,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.2),width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Icon(Bootstrap.check2_circle, color: Colors.green, size: Responsive.icon(context, 24)),
                      SizedBox(height: 10),
                      Text("Detailed results shown immediately after submission", textAlign: TextAlign.center, style: TextStyle(fontFamily: Fonts.nunito, fontSize: Responsive.font(context, 12), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
      ],
    );
  }

  
  Widget _buildInstructionCard(double width, IconData icon, String text, Color iconColor,double height,BuildContext context) {
    return Container(
      width: width,
      height: height*0.1,
      padding: EdgeInsets.only(left: 15,right: 15,top: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2),width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color.fromRGBO(76, 175, 80, 0.1), borderRadius: BorderRadius.circular(50)),
            child: Icon(icon, color: iconColor, size: Responsive.icon(context, 20))),
          SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: Fonts.nunito, fontSize: Responsive.font(context, 11), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _scoringSystem(Contest contest,BuildContext context){
    return Column(
      children: [
          Row(
                  children: [
                    Icon(Bootstrap.graph_up_arrow, color: Colors.green, size: Responsive.icon(context, 16),fontWeight: FontWeight.bold,),
                    SizedBox(width: 8),
                    Text("SCORING SYSTEM", style: TextStyle(fontFamily: Fonts.outfit, color: Colors.grey[700], fontSize: Responsive.font(context, 12), fontWeight: FontWeight.w600)),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.075),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildScoreBox("+${contest.marksPerQuestion}", "CORRECT", Colors.green,context),
                      Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.3)),
                      _buildScoreBox("-${contest.negativeMarking}", "WRONG", Colors.red,context),
                      Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.3)),
                      _buildScoreBox("0", "SKIPPED", Colors.grey[700]!,context),
                    ],
                  ),
                ),
      ],
    );
  }

  Widget _buildScoreBox(String score, String label, Color color,BuildContext context) {
    return Column(
      children: [
        Text(score, style: TextStyle(fontSize: Responsive.font(context, 20), fontWeight: FontWeight.bold, color: color, fontFamily: Fonts.inter)),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: Responsive.font(context, 10), color: Colors.grey[600], fontWeight: FontWeight.bold, fontFamily: Fonts.nunito)),
      ],
    );
  }

  Widget _ratingSystem(BuildContext context){
    return Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.2), style: BorderStyle.solid,width: 1.25),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                        child: Icon(Bootstrap.graph_up, color: Colors.green, size: Responsive.icon(context, 16)),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Rating System", style: TextStyle(fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: Responsive.font(context, 12))),
                            SizedBox(height: 5),
                            Text(
                              "Your platform rating will be adjusted based on your performance relative to other participants.",
                              style: TextStyle(fontFamily: Fonts.nunito, color: Colors.grey[600], fontSize: Responsive.font(context, 11)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
  }


  Widget _startButton(BuildContext context, Contest contest){
    return  Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), offset: Offset(0, -5), blurRadius: 10)
                    ]
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (context) => ContestQuestionBloc(sl<ContestRepo>(), contest),
                            child: ContestQuestionPage(),
                          )
                        )
                      );
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          "Start Contest",
                          style: TextStyle(color: Colors.white, fontSize: Responsive.font(context, 16), fontWeight: FontWeight.bold, fontFamily: Fonts.inter),
                        ),
                      ),
                    ),
                  ),
                ),
              );
  }