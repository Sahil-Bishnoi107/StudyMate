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
               
               
                 _testProgress(height, width, context, state.test.questions, pageController),
                 
                 Container(height: 2,width: width,color: const Color.fromRGBO(200, 200, 200, 0.6),),
                 SizedBox(height: height*0.02,),
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
        child: Icon(Icons.arrow_back_ios_new)),
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
      height: height*0.65,width: width,
      child: PageView.builder(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: questions.length,
        itemBuilder: (context,index){
          return _question(height, width, questions[index], index, questions.length, context);
        }),
     ),

     Container(height: 2,width: width,color: const Color.fromRGBO(200, 200, 200, 0.6),),
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
 
  return Container(
    width: width,height: height*0.6,
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      children: [

        //header
        Row(
          children: [
            Container(
              height: height*0.034,width: width*0.36,
              decoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(180, 180, 180, 0.7),width: 1.5),borderRadius: BorderRadius.circular(20)),
              child: Center(child: Text("Question ${(currQue+1).toString()} of $totalQuestions",style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 12)),)),
            ),
            SizedBox(width: width*0.35,),
            Expanded(child: Text(question.difficulty,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold),)),
          ],
        ),
        SizedBox(height: height*0.01,),
        //Question
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: height*0.03, maxHeight: height*0.5,minWidth: width*0.9,maxWidth: width*0.9),
          
          child: MixedMathText(text:  question.description,textStyle:  TextStyle(fontFamily: Fonts.inter,fontWeight: FontWeight.bold, fontSize: Responsive.font(context, 20)),)),

        //Options
        SizedBox(
          height: height*0.4,
          child: ListView(
            children: [
              QuestionReviewOption(question.options[0], height, width, question.selectedOption == question.options[0],"A",question.selectedOption == question.correctOption),
          
          
              QuestionReviewOption(question.options[1], height, width, question.selectedOption == question.options[1],"B",question.selectedOption == question.correctOption),
          
          
              QuestionReviewOption(question.options[2], height, width, question.selectedOption == question.options[2],"C",question.selectedOption == question.correctOption),
          
          
              QuestionReviewOption(question.options[3], height, width, question.selectedOption == question.options[3],"D",question.selectedOption == question.correctOption)
            ],
          ),
        )
      ],
    ),
  );
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
        child: questionIcon(height, width, questions[index].selectedOption != null, index + 1));
     },

    ),

  );
}