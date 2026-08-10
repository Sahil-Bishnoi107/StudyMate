import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/Contest/Domain/ContestResultQuestion.dart';
import 'package:study_mate/Test/Presentation/Widgets/fixedTextWidget.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_button.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_option.dart';
import 'package:study_mate/fonts.dart';

class ContestReviewPage extends StatefulWidget {
  final List<ContestResultQuestion> questions;
  const ContestReviewPage({super.key, required this.questions});

  @override
  State<ContestReviewPage> createState() => _ContestReviewPageState();
}

class _ContestReviewPageState extends State<ContestReviewPage> {
  PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

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
        title: Text("Review Answers", style: TextStyle(color: Colors.black, fontFamily: Fonts.inter, fontSize: Responsive.font(context, 18), fontWeight: FontWeight.bold)),
      ),
      body: widget.questions.isEmpty
          ? Center(child: Text("No questions to review."))
          : Column(
              children: [
                _buildTestProgress(height, width),
                Container(height: 1.5, width: width, color: const Color.fromRGBO(220, 220, 220, 0.8)),
                SizedBox(height: height * 0.02),
                _buildQuestionSection(height, width),
              ],
            ),
    );
  }

  Widget _buildTestProgress(double height, double width) {
    return SizedBox(
      height: height * 0.05,
      width: width * 0.9,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.questions.length,
        itemBuilder: (context, index) {
          var q = widget.questions[index];
          Color iconColor = Colors.grey;
          if (q.userAnswer != null && q.userAnswer != -1) {
            iconColor = q.isCorrect ? Colors.green : Colors.red;
          }
          
          return GestureDetector(
            onTap: () {
              pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
            },
            child: Center(
              child: Container(
                height: height * 0.035,
                width: height * 0.035,
                margin: EdgeInsets.only(right: width * 0.03),
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(width * 0.1),
                ),
                child: Center(
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionSection(double height, double width) {
    return Column(
      children: [
        SizedBox(
          height: height * 0.65,
          width: width,
          child: PageView.builder(
            controller: pageController,
            itemCount: widget.questions.length,
            itemBuilder: (context, index) {
              return _buildQuestion(height, width, widget.questions[index], index);
            },
          ),
        ),
        Container(height: 2, width: width, color: const Color.fromRGBO(200, 200, 200, 0.6)),
        SizedBox(height: height * 0.01),
        Row(
          children: [
            SizedBox(width: width * 0.05),
            GestureDetector(
              onTap: () {
                if (pageController.page != null && pageController.page! > 0) {
                  pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                }
              },
              child: queButton(height, width, false, context),
            ),
            SizedBox(width: width * 0.1),
            GestureDetector(
              onTap: () {
                if (pageController.page != null && pageController.page! < widget.questions.length - 1) {
                  pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                }
              },
              child: queButton(height, width, true, context),
            )
          ],
        )
      ],
    );
  }

  Widget _buildQuestion(double height, double width, ContestResultQuestion question, int index) {
    String diff = question.difficulty;
    if (diff.isNotEmpty) diff = diff[0].toUpperCase() + diff.substring(1);

    return Container(
      width: width,
      height: height * 0.6,
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: height * 0.034,
                width: width * 0.36,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromRGBO(180, 180, 180, 0.7), width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "Question ${index + 1} of ${widget.questions.length}",
                    style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: Responsive.font(context, 12)),
                  ),
                ),
              ),
              SizedBox(width: width * 0.32),
              Expanded(
                child: Row(
                  children: [
                    Icon(Bootstrap.exclamation_circle, size: Responsive.icon(context, 15)),
                    SizedBox(width: 3),
                    Text(diff, style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: height * 0.03,
              maxHeight: height * 0.5,
              minWidth: width * 0.9,
              maxWidth: width * 0.9,
            ),
            child: MixedMathText(
              text: question.description,
              textStyle: TextStyle(fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: Responsive.font(context, 20)),
            ),
          ),
          SizedBox(
            height: height * 0.4,
            child: ListView(
              children: [
                _buildOption(question, question.optionA, 1, "A", height, width),
                _buildOption(question, question.optionB, 2, "B", height, width),
                _buildOption(question, question.optionC, 3, "C", height, width),
                _buildOption(question, question.optionD, 4, "D", height, width),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOption(ContestResultQuestion question, String optionText, int optionIndex, String label, double height, double width) {
    bool isSelected = question.userAnswer == optionIndex;
    bool isCorrect = question.correctAnswer == optionIndex;

    // Use QuestionReviewOption from the existing widgets, modifying behavior based on selection & correctness
    // Note: If an option is the correct one, we want to highlight it green.
    // If the user selected an incorrect option, highlight it red.
    // QuestionReviewOption takes isSelected and isCorrect. 
    // If we pass isSelected=true and isCorrect=true -> green
    // If we pass isSelected=true and isCorrect=false -> red
    // But we also want to show the correct answer if user didn't select it.
    // So if it's the correct answer, we treat it as "selected" (highlighted) and "correct".
    
    bool highlight = isSelected || isCorrect;
    bool showAsCorrect = isCorrect;
    
    return QuestionReviewOption(optionText, height, width, highlight, label, showAsCorrect);
  }
}
