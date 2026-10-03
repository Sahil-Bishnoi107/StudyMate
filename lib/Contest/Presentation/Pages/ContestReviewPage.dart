import 'package:flutter/material.dart';
import 'package:study_mate/Contest/Domain/ContestResultQuestion.dart';
import 'package:study_mate/Test/Presentation/Widgets/fixedTextWidget.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_button.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_icon.dart';
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
      body: SizedBox(
        height: height, width: width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(height, width),
              SizedBox(height: height*0.01,),
              Container(height: 1,width: width,color: const Color.fromRGBO(200, 200, 200, 0.6),),
              SizedBox(height: height*0.005,),
              if(widget.questions.isEmpty)
                SizedBox(height: height*0.6,child: Center(child: Text("No questions to review.",style: TextStyle(fontFamily: Fonts.nunito),)))
              else ...[
                _buildTestProgress(height, width),
                SizedBox(height: height*0.01,),
                _buildQuestionSection(height, width),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double height, double width) {
    return Container(
      constraints: BoxConstraints(minHeight: height*0.05,maxHeight: height*0.1),
      width: width,
      padding: EdgeInsets.only(left: width*0.05),
      margin: EdgeInsets.only(top: height*0.05),
      child: Row(
      children: [
        GestureDetector(
          onTap: ()  {
           Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new,size: Responsive.icon(context, 20),)),
        SizedBox(width: width*0.03,),
        SizedBox(
          width: width*0.65,
          child: Text("Review Answers",style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 20)),)
          ),
      ],
      ),
    );
  }

  Widget _buildTestProgress(double height, double width) {
    return SizedBox(
      height: height*0.05,width: width*0.9,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.questions.length,
        itemBuilder: (context, index) {
          var q = widget.questions[index];
          bool isAnswered = q.userAnswer != null && q.userAnswer != -1;

          return GestureDetector(
            onTap: () {
              pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
            },
            child: questionIcon(height, width, isAnswered, index + 1,color: q.isCorrect ? Colors.green : Colors.red));
        },
      ),
    );
  }

  Widget _buildQuestionSection(double height, double width) {
    return Column(
      children: [
        SizedBox(
          height: height*0.68,width: width,
          child: PageView.builder(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.questions.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(child: _buildQuestion(height, width, widget.questions[index], index));
            },
          ),
        ),
        Container(height: 1,width: width,color: const Color.fromRGBO(220, 220, 220, 0.7),),
        SizedBox(height: height*0.01,),
        Row(
          children: [
            SizedBox(width: width*0.05,),
            GestureDetector(
              onTap: () {
                if (pageController.page != null && pageController.page! > 0) {
                  pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                }
              },
              child: queButton(height, width, false, context),
            ),
            SizedBox(width: width*0.1,),
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
    bool isSkipped = question.userAnswer == null || question.userAnswer == -1;

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width*0.05),
      child: Column(
        children: [
          Row(
            children: [
              Text("Question ${index + 1} of ${widget.questions.length}",style: TextStyle(fontFamily: Fonts.inter,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 16)),),
              const Spacer(),
              Text(diff,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,color: Colors.blueGrey,fontSize: Responsive.font(context, 14)),),
            ],
          ),
          SizedBox(height: height*0.01,),
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: height*0.03, maxHeight: height*0.6,minWidth: width*0.9,maxWidth: width*0.9),
            child: MixedMathText(text: question.description, textStyle: TextStyle(fontFamily: Fonts.rubik,fontWeight: FontWeight.w700,color: const Color.fromRGBO(60, 60, 60, 1), fontSize: Responsive.font(context, 16)),)),

          SizedBox(height: height*0.03,),
          SizedBox(
            child: Column(
              children: [
                _buildOption(question, question.optionA, 1, "A", height, width),
                _buildOption(question, question.optionB, 2, "B", height, width),
                _buildOption(question, question.optionC, 3, "C", height, width),
                _buildOption(question, question.optionD, 4, "D", height, width),

                if(!question.isCorrect)
                Row(
                  children: [
                    Icon(Icons.check_circle_outline,color: Colors.green,size: Responsive.icon(context, 15),),
                    const SizedBox(width: 5),
                    Expanded(child: Text(isSkipped ? "You skipped this question, the correct answer is marked green" : "Your answer is marked red, the correct answer green",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),color: Colors.blueGrey),)),
                  ],
                ),

                SizedBox(height: height*0.02,)
              ],
            ),
          )
        ],
      ),
    );
  }

  // the correct option is shown green even when the user picked something else or skipped
  Widget _buildOption(ContestResultQuestion question, String optionText, int optionIndex, String label, double height, double width) {
    bool isSelected = question.userAnswer == optionIndex;
    bool isCorrect = question.correctAnswer == optionIndex;

    return QuestionReviewOption(optionText, height, width, isSelected || isCorrect, label, isCorrect);
  }
}
