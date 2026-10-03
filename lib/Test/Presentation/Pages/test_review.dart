import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/Test/Presentation/Bloc/ReviewBloc/ReviewBloc.dart';
import 'package:study_mate/Test/Presentation/Bloc/ReviewBloc/ReviewStates.dart';
import 'package:study_mate/Test/Presentation/Widgets/fixedTextWidget.dart';

import 'package:study_mate/Test/Presentation/Widgets/question_button.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_icon.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_option.dart';
import 'package:study_mate/fonts.dart';

class TestReview extends StatefulWidget {

 const TestReview({super.key});

  @override
  State<TestReview> createState() => _TestState();
}

class _TestState extends State<TestReview> {
  PageController pageController =  PageController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ReviewBloc,ReviewStates>(

      builder: (context, state) {


        if(state is ReviewLoadedState){
        return SizedBox(
          height: height, width: width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                 _header(height, width, state.test.name,context),
                 SizedBox(height: height*0.01,),
                 Container(height: 1,width: width,color: const Color.fromRGBO(200, 200, 200, 0.6),),
                 SizedBox(height: height*0.005,),
                 _testProgress(height, width, context, state.test.questions, pageController),


                 SizedBox(height: height*0.01,),
                 _questionSection(height, width, state.test.questions, pageController,context)

              ],
            ),
          ),
        );
        }

        return Container(
          child: Center(
            child: Text("Failed to load the test, Please try again",style:  TextStyle(color: Colors.red,fontFamily: Fonts.nunito),),
          ),
        );
      },
      ),
    );
  }
}




Widget _header(double height,double width,String testName,BuildContext context){

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
        child: Text(testName,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 20)),)
        ),
    ],
    ),
  );
}

Widget _questionSection(double height,double width, List<Question> questions,PageController pageController,BuildContext context){
  return Column(
    children: [
     SizedBox(
      height: height*0.68,width: width,
      child: PageView.builder(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: questions.length,
        itemBuilder: (context,index){
          return SingleChildScrollView(child: _question(height, width, questions[index], index, questions.length, context));
        }),
     ),

     Container(height: 1,width: width,color: const Color.fromRGBO(220, 220, 220, 0.7),),
     SizedBox(height: height*0.01,),
     Row(
      children: [
        SizedBox(width: width*0.05,),
        GestureDetector(
          onTap: () {
            pageController.previousPage(duration: Duration(microseconds: 300), curve: Curves.easeOut);
          },
          child: queButton(height, width, false,context)),
          SizedBox(width: width*0.1,),
        GestureDetector(
          onTap: () {
            pageController.nextPage(duration: Duration(microseconds: 300), curve: Curves.easeOut);
          },
          child: queButton(height, width, true,context))
      ],
     )
    ],
  );
}


Widget _question(double height,double width, Question question,int currQue,int totalQuestions,BuildContext context){
 String difficulty = question.difficulty;
 if(question.difficulty.length > 2)difficulty = question.difficulty[0].toUpperCase() + question.difficulty.substring(1);
  return Container(
    width: width,
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      children: [

        //header
        Row(
          children: [
            Text("Question ${currQue + 1} of ${totalQuestions}",style: TextStyle(fontFamily: Fonts.inter,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 16)),),
            const Spacer(),
            Text(difficulty,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,color: Colors.blueGrey,fontSize: Responsive.font(context, 14)),),
          ],
        ),
        SizedBox(height: height*0.01,),
        //Question
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: height*0.03, maxHeight: height*0.6,minWidth: width*0.9,maxWidth: width*0.9),

          child: MixedMathText(text: question.description, textStyle: TextStyle(fontFamily: Fonts.rubik,fontWeight: FontWeight.w700,color: const Color.fromRGBO(60, 60, 60, 1), fontSize: Responsive.font(context, 16)),)),


        SizedBox(height: height*0.03,),
        //Options
        SizedBox(

          child: Column(

            children: [
              _reviewOption(height, width, question, 0, "A"),


              _reviewOption(height, width, question, 1, "B"),


              _reviewOption(height, width, question, 2, "C"),


              _reviewOption(height, width, question, 3, "D"),

              if(question.selectedOption != question.correctOption)
              Row(
                children: [
                  Icon(Icons.check_circle_outline,color: Colors.green,size: Responsive.icon(context, 15),),
                  const SizedBox(width: 5),
                  Expanded(child: Text(question.selectedOption == null ? "You skipped this question, the correct answer is marked green" : "Your answer is marked red, the correct answer green",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),color: Colors.blueGrey),)),
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
Widget _reviewOption(double height,double width,Question question,int index,String optionNum){
  String option = question.options[index];
  if(option == question.correctOption){
    return QuestionReviewOption(option, height, width, true, optionNum, true);
  }
  return QuestionReviewOption(option, height, width, question.selectedOption == option, optionNum, false);
}


Widget _testProgress(double height, double width,BuildContext context,List<Question> questions,PageController pageController){
  return SizedBox(

    height: height*0.05,width: width*0.9,
    child: ListView.builder(
     scrollDirection: Axis.horizontal,
     itemCount: questions.length,
     itemBuilder: (context, index) {

       return GestureDetector(
        onTap: () {
          pageController.animateToPage(index, duration: Duration(microseconds: 300), curve: Curves.bounceIn);
        },
        child: questionIcon(height, width, questions[index].selectedOption != null, index + 1,color: questions[index].selectedOption == questions[index].correctOption ? Colors.green : Colors.red));
     },

    ),

  );
}
