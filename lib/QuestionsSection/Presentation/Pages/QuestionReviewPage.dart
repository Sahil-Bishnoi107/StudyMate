import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/MyQuestionsBloc/MyQuestionsBloc.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/MyQuestionsBloc/MyQuestionsStates.dart';
import 'package:study_mate/Test/Presentation/Widgets/fixedTextWidget.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_option.dart';
import 'package:study_mate/fonts.dart';

class QuestionReviewPage extends StatefulWidget {
  final int initialIndex;
  const QuestionReviewPage({super.key, required this.initialIndex});

  @override
  State<QuestionReviewPage> createState() => _QuestionReviewPageState();
}

class _QuestionReviewPageState extends State<QuestionReviewPage> {
  late int currentIndex;
  bool isAnswerRevealed = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<MyQuestionsBloc, MyQuestionsStates>(
        builder: (context, state) {
          if (state is MyQuestionsLoadedState) {
            if (state.collectionQuestions.isEmpty) {
              return Center(child: Text("No questions in this collection."));
            }
            
            // Safety check
            if (currentIndex >= state.collectionQuestions.length) {
               currentIndex = 0; 
            }

            Question currentQuestion = state.collectionQuestions[currentIndex];

            return Column(
              children: [
                _header(height, width, context),
                
                Container(height: 1, width: width, color: const Color.fromRGBO(200, 200, 200, 0.6)),
                Expanded(child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.02),
                _questionSection(height, width, currentQuestion, currentIndex, state.collectionQuestions.length),
                    ],
                  ),
                ))
               
              ],
            );
          }
          return Center(child: Text("Error loading questions"));
        },
      ),
    );
  }

  Widget _header(double height, double width, BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: height * 0.05, maxHeight: height * 0.1),
      width: width,
      padding: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
      margin: EdgeInsets.only(top: height * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(LucideIcons.chevronLeft, size: 25),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text("My Questions",style: TextStyle(fontFamily: Fonts.outfit,fontSize: 18,fontWeight: FontWeight.w600),)
            ],
          ),
        ],
      ),
    );
  }

  Widget _questionSection(double height, double width, Question question, int currInd, int totalQuestions) {
    return Column(
      children: [
        Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            children: [
              _questionHeader(height, width, question, currInd, totalQuestions),
              SizedBox(height: height * 0.02),
              _questionDescription(height, width, question),
              SizedBox(height: height * 0.02),
              _optionsList(height, width, question),
            ],
          ),
        ),
        Container(height: 2, width: width, color: const Color.fromRGBO(200, 200, 200, 0.6)),
        SizedBox(height: height * 0.01),
        _actionButtons(height, width, totalQuestions),
      ],
    );
  }

  Widget _questionHeader(double height, double width, Question question, int currInd, int totalQuestions) {
    String difficulty = question.difficulty;
    if (difficulty.length > 2) difficulty = difficulty[0].toUpperCase() + difficulty.substring(1);

    return Row(
      children: [
        Container(
          height: height * 0.034,
          width: width * 0.36,
          decoration: BoxDecoration(
              border: Border.all(color: const Color.fromRGBO(180, 180, 180, 0.7), width: 1.5),
              borderRadius: BorderRadius.circular(20)),
          child: Center(
              child: Text("Question ${currInd + 1} of $totalQuestions",
                  style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: 12))),
        ),
        SizedBox(width: width * 0.2),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Bootstrap.exclamation_circle, size: 15, color: Colors.orange),
            SizedBox(width: 5),
            Text(difficulty, style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, color: Colors.grey[700])),
          ],
        )),
      ],
    );
  }

  Widget _questionDescription(double height, double width, Question question) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height * 0.03, maxHeight: height * 0.5, minWidth: width * 0.9, maxWidth: width * 0.9),
      child: MixedMathText(
        text: question.description,
        textStyle: TextStyle(fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _optionsList(double height, double width, Question question) {
    return SizedBox(
      height: height * 0.45,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: question.options.length,
        itemBuilder: (context, index) {
          String option = question.options[index];
          String optionLetter = String.fromCharCode(65 + index);
          
          if (isAnswerRevealed) {
            bool isCorrect = option == question.correctOption;
            return QuestionReviewOption(option, height, width, isCorrect, optionLetter, isCorrect);
          } else {
            return QuestionOption(option, height, width, false, optionLetter);
          }
        },
      ),
    );
  }

  Widget _actionButtons(double height, double width, int totalQuestions) {
    if (!isAnswerRevealed) {
      return GestureDetector(
        onTap: () {
          setState(() {
            isAnswerRevealed = true;
          });
        },
        child: Container(
          height: height * 0.06,
          width: width * 0.8,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text("Reveal Answer", style: TextStyle(color: Colors.white, fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          if (currentIndex < totalQuestions - 1) {
            setState(() {
              currentIndex++;
              isAnswerRevealed = false;
            });
          } else {
            Navigator.pop(context); // Final question reached, return to list view
          }
        },
        child: Container(
          height: height * 0.06,
          width: width * 0.8,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(currentIndex < totalQuestions - 1 ? "Next Question" : "Finish Review", style: TextStyle(color: Colors.white, fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      );
    }
  }
}
