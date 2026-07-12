import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/QuestionsSection/Domain/Collection.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/MyQuestionsBloc/MyQuestionsBloc.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/MyQuestionsBloc/MyQuestionsStates.dart';
import 'package:study_mate/QuestionsSection/Presentation/Pages/QuestionReviewPage.dart';
import 'package:study_mate/fonts.dart';

class CollectionQuestionPage extends StatelessWidget {
  final Collection collection;
  const CollectionQuestionPage({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<MyQuestionsBloc, MyQuestionsStates>(
        builder: (context, state) {
          if (state is MyQuestionsLoadedState) {
            List<Question> questions = state.collectionQuestions;
            
            return SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: height * 0.12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _header(height, width, context),
                        SizedBox(height: height * 0.02),
                        _statsBar(height, width, questions.length),
                        SizedBox(height: height * 0.03),
                        _recentQuestionsHeader(width),
                        SizedBox(height: height * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Column(
                            children: questions.map((q) => _questionCard(height, width, q, context)).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _startPracticeButton(height, width, context, questions),
                  ),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(width: 5),
              Text(
                collection.collectionname,
                style: TextStyle(fontFamily: Fonts.inter, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.search, size: 24, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _statsBar(double height, double width, int totalQuestions) {
    return Container(
      width: width,
      color: Colors.green.withOpacity(0.1),
      padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
      child: Row(
        children: [
          Icon(FontAwesome.book_open_solid, color: Colors.green, size: 20),
          SizedBox(width: width * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("TOTAL QUESTIONS", style: TextStyle(fontFamily: Fonts.nunito, fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600])),
              Text("$totalQuestions Questions", style: TextStyle(fontFamily: Fonts.inter, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("LAST ACTIVITY", style: TextStyle(fontFamily: Fonts.nunito, fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600])),
              Text("Today", style: TextStyle(fontFamily: Fonts.inter, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(width: width * 0.04),
          Icon(FontAwesome.clock_solid, color: Colors.green, size: 20),
        ],
      ),
    );
  }

  Widget _recentQuestionsHeader(double width) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("RECENT QUESTIONS", style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.2, fontSize: 12)),
          Text("Filter All", style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, color: Colors.green, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _questionCard(double height, double width, Question question, BuildContext context) {
    String difficulty = question.difficulty;
    if (difficulty.length > 2) difficulty = difficulty.toUpperCase();
    
    // Subject pill color mapping (rough approximation based on typical subjects)
    Color subjectColor = Colors.green;
    if (question.subject.toLowerCase() == 'physics') subjectColor = Colors.green;
    if (question.subject.toLowerCase() == 'chemistry') subjectColor = Colors.teal;
    if (question.subject.toLowerCase() == 'biology') subjectColor = Colors.lightGreen;
    if (question.subject.toLowerCase() == 'mathematics') subjectColor = Colors.greenAccent[700]!;

    // Difficulty pill color
    Color diffBgColor = Colors.orange.withOpacity(0.1);
    Color diffTextColor = Colors.orange;
    if (difficulty == 'EASY') {
      diffBgColor = Colors.green.withOpacity(0.1);
      diffTextColor = Colors.green;
    } else if (difficulty == 'HARD') {
      diffBgColor = Colors.red.withOpacity(0.1);
      diffTextColor = Colors.red;
    }

    return GestureDetector(
      onTap: () {
        // Tapping a specific question opens review mode starting from this question.
        // We find the index of the question in the state to pass it.
        final state = BlocProvider.of<MyQuestionsBloc>(context).state;
        if (state is MyQuestionsLoadedState) {
          int index = state.collectionQuestions.indexOf(question);
          if (index != -1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuestionReviewPage(initialIndex: index)),
            );
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.02),
        padding: EdgeInsets.all(width * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: subjectColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(FontAwesome.book_solid, size: 10, color: subjectColor),
                      SizedBox(width: 4),
                      Text(question.subject, style: TextStyle(color: subjectColor, fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: 10)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: diffBgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(difficulty, style: TextStyle(color: diffTextColor, fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                    SizedBox(width: 10),
                    Icon(FontAwesome.bookmark_solid, size: 14, color: Colors.green),
                  ],
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Text(
              question.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: 14, height: 1.4),
            ),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Icon(Icons.history, size: 14, color: Colors.grey), // Placeholder for avatars/history
                SizedBox(width: 8),
                Text("Practice history available", style: TextStyle(fontFamily: Fonts.nunito, color: Colors.grey[500], fontSize: 11, fontStyle: FontStyle.italic)),
                Spacer(),
                Icon(Icons.arrow_forward, size: 16, color: Colors.grey[400]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _startPracticeButton(double height, double width, BuildContext context, List<Question> questions) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: GestureDetector(
        onTap: () {
          if (questions.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuestionReviewPage(initialIndex: 0)),
            );
          }
        },
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bolt, color: Colors.white),
              SizedBox(width: 8),
              Text("Start Practice", style: TextStyle(color: Colors.white, fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
