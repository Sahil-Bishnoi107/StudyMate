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
            
            
            if (currentIndex >= state.collectionQuestions.length) {
               currentIndex = 0; 
            }

            Question currentQuestion = state.collectionQuestions[currentIndex];

            return SafeArea(
              child: Column(
                children: [
                  _header(height, width, context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: height * 0.015),
                      child: _questionSection(height, width, currentQuestion, currentIndex, state.collectionQuestions.length),
                    ),
                  ),
                  _revealSection(height, width, state.collectionQuestions.length),
                ],
              ),
            );
          }
          return Center(child: Text("Error loading questions"));
        },
      ),
    );
  }

  Widget _header(double height, double width, BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(minHeight: height * 0.05, maxHeight: height * 0.1),
          width: width,
          padding: EdgeInsets.only(left: width * 0.02, right: width * 0.05),
          child: Row(
            children: [
              IconButton(
                icon: Icon(LucideIcons.chevronLeft, size: Responsive.icon(context, 25)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Text("My Questions", style: TextStyle(fontFamily: Fonts.rubik, fontWeight: FontWeight.bold, fontSize: Responsive.font(context, 18))),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.01),
        Container(height: 1, width: width, color: const Color.fromRGBO(200, 200, 200, 0.6)),
      ],
    );
  }

  Widget _revealSection(double height, double width, int totalQuestions) {
    return Column(
      children: [
        Container(height: 1, width: width, color: const Color.fromRGBO(220, 220, 220, 0.7)),
        SizedBox(height: height * 0.01),
        _actionButtons(height, width, totalQuestions),
        SizedBox(height: height * 0.02),
      ],
    );
  }

  Widget _questionSection(double height, double width, Question question, int currInd, int totalQuestions) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        children: [
          _questionHeader(height, width, question, currInd, totalQuestions),
          SizedBox(height: height * 0.01),
          _questionDescription(height, width, question),
          SizedBox(height: height * 0.03),
          _optionsList(height, width, question),
          SizedBox(height: height * 0.02),
        ],
      ),
    );
  }

  Widget _questionHeader(double height, double width, Question question, int currInd, int totalQuestions) {
    String difficulty = question.difficulty;
    if (difficulty.length > 2) difficulty = difficulty[0].toUpperCase() + difficulty.substring(1);

    return Row(
      children: [
        Text("Question ${currInd + 1} of $totalQuestions",
            style: TextStyle(fontFamily: Fonts.inter, fontWeight: FontWeight.w700, fontSize: Responsive.font(context, 16))),
        const Spacer(),
        Icon(Bootstrap.exclamation_circle, size: Responsive.icon(context, 15), color: Colors.orange),
        const SizedBox(width: 5),
        Text(difficulty, style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, color: Colors.orange, fontSize: Responsive.font(context, 14))),
      ],
    );
  }

  Widget _questionDescription(double height, double width, Question question) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height * 0.03, maxHeight: height * 0.6, minWidth: width * 0.9, maxWidth: width * 0.9),
      child: MixedMathText(
        text: question.description,
        textStyle: TextStyle(fontFamily: Fonts.rubik, fontWeight: FontWeight.w700, color: const Color.fromRGBO(60, 60, 60, 1), fontSize: Responsive.font(context, 16)),
      ),
    );
  }

  Widget _optionsList(double height, double width, Question question) {
    return Column(
      children: List.generate(question.options.length, (index) {
        String option = question.options[index];
        String optionLetter = String.fromCharCode(65 + index);

        if (isAnswerRevealed) {
          bool isCorrect = option == question.correctOption;
          return QuestionReviewOption(option, height, width, isCorrect, optionLetter, isCorrect);
        } else {
          return QuestionOption(option, height, width, false, optionLetter, context);
        }
      }),
    );
  }

  Widget _actionButtons(double height, double width, int totalQuestions) {
    final String txt = !isAnswerRevealed
        ? "Reveal Answer"
        : (currentIndex < totalQuestions - 1 ? "Next >" : "Finish Review");

    return GestureDetector(
      onTap: () {
        if (!isAnswerRevealed) {
          setState(() {
            isAnswerRevealed = true;
          });
        } else if (currentIndex < totalQuestions - 1) {
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
        width: width * 0.9,
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(color: Colors.green),
        ),
        child: Center(
          child: Text(txt, style: TextStyle(color: Colors.white, fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: Responsive.font(context, 13))),
        ),
      ),
    );
  }
}
