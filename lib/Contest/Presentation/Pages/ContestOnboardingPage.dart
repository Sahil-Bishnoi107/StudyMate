import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/Contest/Data/ContestRepo.dart';
import 'package:study_mate/Contest/Domain/Contest.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestQuestionBloc.dart';
import 'package:study_mate/Contest/Presentation/Pages/ContestQuestionPage.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';
import 'package:study_mate/fonts.dart';

class ContestOnboardingPage extends StatelessWidget {
  final Contest contest;

  const ContestOnboardingPage({Key? key, required this.contest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
        title: Text(contest.contestName, style: TextStyle(color: Colors.black, fontFamily: Fonts.inter, fontSize: 16, fontWeight:   FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Bootstrap.three_dots_vertical, color: Colors.black), onPressed: () {})
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, bottom: 100),
            children: [
              // Header section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contest.contestName,
                        style: TextStyle(fontFamily: Fonts.inter, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Bootstrap.book, size: 14, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(
                            contest.subject,
                            style: TextStyle(fontFamily: Fonts.nunito, color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      contest.difficulty.toUpperCase(),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: Fonts.nunito,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatBox(width * 0.28, "DURATION", "${contest.duration}m", Bootstrap.clock),
                  _buildStatBox(width * 0.28, "QUESTIONS", "${contest.marksPerQuestion * 10} Qs", Bootstrap.question_circle),
                  _buildStatBox(width * 0.28, "REC. RATING", "1600+", Bootstrap.graph_up),
                ],
              ),
              SizedBox(height: 25),

              // About Contest
              Row(
                children: [
                  Icon(Bootstrap.info_circle, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Text("ABOUT CONTEST", style: TextStyle(fontFamily: Fonts.inter, color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Text(
                  "This mock cup is designed to simulate the rigorous environment of the actual exam. Questions focus on application-based concepts. Ensure a stable environment before starting.",
                  style: TextStyle(fontFamily: Fonts.nunito, color: Colors.grey[600], height: 1.5, fontSize: 13),
                ),
              ),
              SizedBox(height: 25),

              // Instructions
              Row(
                children: [
                  Icon(Bootstrap.file_earmark_text, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Text("INSTRUCTIONS", style: TextStyle(fontFamily: Fonts.inter, color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInstructionCard(width * 0.43, Bootstrap.clock, "Timer cannot be paused", Colors.green),
                  _buildInstructionCard(width * 0.43, Bootstrap.wifi, "Internet connection required", Colors.green),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInstructionCard(width * 0.43, Bootstrap.bullseye, "Negative marking active", Colors.green),
                  _buildInstructionCard(width * 0.43, Bootstrap.box_arrow_right, "Don't leave the screen", Colors.green),
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: width,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Icon(Bootstrap.check2_circle, color: Colors.green, size: 24),
                    SizedBox(height: 10),
                    Text("Detailed results shown immediately after submission", textAlign: TextAlign.center, style: TextStyle(fontFamily: Fonts.nunito, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 25),

              // Scoring System
              Row(
                children: [
                  Icon(Bootstrap.graph_up_arrow, color: Colors.grey[700], size: 16),
                  SizedBox(width: 8),
                  Text("SCORING SYSTEM", style: TextStyle(fontFamily: Fonts.inter, color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildScoreBox("+${contest.marksPerQuestion}", "CORRECT", Colors.green),
                    Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.3)),
                    _buildScoreBox("-${contest.negativeMarking}", "WRONG", Colors.red),
                    Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.3)),
                    _buildScoreBox("0", "SKIPPED", Colors.grey[700]!),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.withOpacity(0.2), style: BorderStyle.solid),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(Bootstrap.graph_up, color: Colors.green, size: 16),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Rating System", style: TextStyle(fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: 12)),
                          SizedBox(height: 5),
                          Text(
                            "Your platform rating will be adjusted based on your performance relative to other participants.",
                            style: TextStyle(fontFamily: Fonts.nunito, color: Colors.grey[600], fontSize: 11),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),

          // Start Button pinned to bottom
          if (!isUpcoming)
            Positioned(
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
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: Fonts.inter),
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildStatBox(double width, String title, String value, IconData icon) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 9, color: Colors.grey[600], fontWeight: FontWeight.bold, fontFamily: Fonts.nunito)),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: Fonts.inter)),
        ],
      ),
    );
  }

  Widget _buildInstructionCard(double width, IconData icon, String text, Color iconColor) {
    return Container(
      width: width,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: Fonts.nunito, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBox(String score, String label, Color color) {
    return Column(
      children: [
        Text(score, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color, fontFamily: Fonts.inter)),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.bold, fontFamily: Fonts.nunito)),
      ],
    );
  }
}
