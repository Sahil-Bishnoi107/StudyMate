import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/Contest/Domain/ContestQuestion.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestQuestions/ContestQuestionBloc.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestQuestions/ContestQuestionEvents.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestQuestions/ContestQuestionStates.dart';
import 'package:study_mate/Contest/Presentation/Pages/ContestSubmittedPage.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
import 'package:study_mate/Test/Presentation/Widgets/fixedTextWidget.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_button.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_icon.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_option.dart';
import 'package:study_mate/fonts.dart';

class ContestQuestionPage extends StatefulWidget {
  const ContestQuestionPage({super.key});

  @override
  State<ContestQuestionPage> createState() => _ContestQuestionPageState();
}

class _ContestQuestionPageState extends State<ContestQuestionPage> {
  PageController pageController = PageController();
  Timer? _timer;
  int _timeLeft = 0;

  @override
  void initState() {
    super.initState();
    final bloc = BlocProvider.of<ContestQuestionBloc>(context);
    bloc.add(LoadContestQuestions(contestId: bloc.contest.contestId));
  }

  void _startTimer(DateTime serverEndTime) {
    if (_timer != null) return;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      Duration diff = serverEndTime.difference(DateTime.now());
      if (diff.inSeconds <= 0) {
        timer.cancel();
        setState(() {
          _timeLeft = 0;
        });
        BlocProvider.of<ContestQuestionBloc>(context).add(SubmitContestEvent());
      } else {
        setState(() {
          _timeLeft = diff.inSeconds;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ContestQuestionBloc, ContestQuestionStates>(
        listener: (context, state) {
          if (state is ContestQuestionLoaded) {
            _startTimer(state.serverEndTime);
          } else if (state is ContestQuestionSubmitted) {
            _timer?.cancel();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ContestSubmittedPage()),
            );
          } else if (state is ContestQuestionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("You are not eligible to give this contest. Please try again later."),
                behavior: SnackBarBehavior.floating,
              )
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is ContestQuestionLoading || state is ContestQuestionInitial) {
            return Center(child: LoadingLogo());
          }

          if (state is ContestQuestionSubmitting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingLogo(),
                  SizedBox(height: 20),
                  Text("Please wait, your Contest is being submitted...", style: TextStyle(fontFamily: Fonts.nunito)),
                ],
              ),
            );
          }

          if (state is ContestQuestionLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(height, width, state.contest.contestName),
                  SizedBox(height: height * 0.01),
                  _buildTestProgress(height, width, state.questions),
                  Container(height: 2, width: width, color: const Color.fromRGBO(200, 200, 200, 0.6)),
                  SizedBox(height: height * 0.02),
                  _buildQuestionSection(height, width, state.questions),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildHeader(double height, double width, String contestName) {
    String minutes = (_timeLeft / 60).toInt().toString().padLeft(2, '0');
    String seconds = (_timeLeft % 60).toInt().toString().padLeft(2, '0');

    return Container(
      constraints: BoxConstraints(minHeight: height * 0.05, maxHeight: height * 0.1),
      width: width,
      padding: EdgeInsets.only(left: width * 0.05),
      margin: EdgeInsets.only(top: height * 0.05),
      child: Row(
        children: [
          SizedBox(
            width: width * 0.65,
            child: Text(
              contestName,
              style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Container(
            height: height * 0.035,
            width: width * 0.25,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(76, 175, 80, 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Bootstrap.stopwatch, size: 15, color: Colors.green, weight: 600),
                  SizedBox(width: 5),
                  Text(
                    "$minutes : $seconds",
                    style: TextStyle(color: Colors.green, fontFamily: Fonts.nunito, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTestProgress(double height, double width, List<ContestQuestion> questions) {
    return SizedBox(
      height: height * 0.05,
      width: width * 0.9,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: questions.length + 1,
        itemBuilder: (context, index) {
          if (index == questions.length) {
            return GestureDetector(
              onTap: () {
                BlocProvider.of<ContestQuestionBloc>(context).add(SubmitContestEvent());
              },
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: height * 0.04,
                  width: width * 0.2,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.green),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontFamily: Fonts.nunito, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );
          }
          return GestureDetector(
            onTap: () {
              pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
            },
            child: questionIcon(height, width, questions[index].ans != null, index + 1),
          );
        },
      ),
    );
  }

  Widget _buildQuestionSection(double height, double width, List<ContestQuestion> questions) {
    if (questions.isEmpty) return SizedBox();

    return Column(
      children: [
        SizedBox(
          height: height * 0.65,
          width: width,
          child: PageView.builder(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return _buildQuestion(height, width, questions[index], index, questions.length);
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
              child: queButton(height, width, false),
            ),
            SizedBox(width: width * 0.1),
            GestureDetector(
              onTap: () {
                if (pageController.page != null && pageController.page! < questions.length - 1) {
                  pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                }
              },
              child: queButton(height, width, true),
            )
          ],
        )
      ],
    );
  }

  Widget _buildQuestion(double height, double width, ContestQuestion question, int index, int totalQuestions) {
    String diff = question.difficulty;
    if (diff.isNotEmpty) {
      diff = diff[0].toUpperCase() + diff.substring(1);
    }

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
                    "Question ${index + 1} of $totalQuestions",
                    style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              SizedBox(width: width * 0.32),
              Expanded(
                child: Row(
                  children: [
                    Icon(Bootstrap.exclamation_circle, size: 15),
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
              textStyle: TextStyle(fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: 20),
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

  Widget _buildOption(ContestQuestion question, String optionText, int optionIndex, String label, double height, double width) {
    bool isSelected = question.ans == optionIndex;
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          BlocProvider.of<ContestQuestionBloc>(context).add(ClearContestOption(question: question));
        } else {
          BlocProvider.of<ContestQuestionBloc>(context).add(SelectContestOption(question: question, optionIndex: optionIndex));
        }
      },
      child: QuestionOption(optionText, height, width, isSelected, label),
    );
  }
}
