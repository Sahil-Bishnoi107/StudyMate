import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/Test/Presentation/Bloc/test_bloc.dart';
import 'package:study_mate/Test/Presentation/Bloc/testevents.dart';
import 'package:study_mate/Test/Presentation/Bloc/teststates.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_button.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_option.dart';
import 'package:study_mate/fonts.dart';

class Test extends StatefulWidget {
 final String testId;
 const Test({super.key,required this.testId});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  PageController pageController =  PageController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocConsumer(

      listener: (context, state) {
          
      },


      builder: (context, state) {
        if(state is TestLoading){
          return Container(
            child: Center(
              child: LoadingAnimationWidget.beat(color: Colors.green, size: 50),
            ),
          );
        }

        if(state is TestLoaded){
        return SingleChildScrollView(
          child: Container(
            height: height, width: width,
            child: Column(
              children: [
                 _header(height, width, state.timeLeft, state.test.name),
                 Container(color: const Color.fromRGBO(180, 180, 180, 1), height: 1, width: width,),
                 SizedBox(height: height*0.05,),
                
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




Widget _header(double height,double width,int timeLeft,String testName){
  String minutes = (timeLeft / 60).toString();
  String seconds = (timeLeft % 60).toString();
  return Container(
    height: height*0.1,width: width,
    padding: EdgeInsets.only(left: width*0.05),
    child: Row(
    children: [
      Container(
        width: width*0.6,
        child: Text(testName,style: TextStyle(fontFamily: Fonts.nunito),)
        ),

      Container(
        height: height*0.02,width: width*0.06,
        child: Text("$minutes : $seconds",style: TextStyle(color: Colors.green,fontFamily: Fonts.nunito),),
        )  

    ],
    ),
  );
}

Widget _questionSection(double height,double width, List<Question> questions,PageController pageController){
  return Column(
    children: [
     Container(height: height*0.6,width: width,
      child: PageView.builder(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: questions.length,
        itemBuilder: (context,index){
          return _question(height, width, questions[index], index, questions.length, context);
        }),
     ),

     Container(height: 1,width: width,color: const Color.fromRGBO(180, 180, 180, 1),),

     Row(
      children: [
        GestureDetector(
          onTap: () {
            pageController.nextPage(duration: Duration(microseconds: 300), curve: Curves.easeOut);
          },
          child: queButton(height, width, false)),
        GestureDetector(
          onTap: () {
            pageController.previousPage(duration: Duration(microseconds: 300), curve: Curves.easeOut);
          },
          child: queButton(height, width, true))
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
        Row(
          children: [
            Container(
              height: height*0.02,width: width*0.06,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(5)),
              child: Text("Question ${(currQue+1).toString()} of $totalQuestions",style: TextStyle(fontFamily: Fonts.nunito),),
            ),
            SizedBox(width: width*0.7,),
            Text(question.difficulty,style: TextStyle(fontFamily: Fonts.nunito),),
          ],
        ),

        Text(question.description,style: TextStyle(fontFamily: Fonts.nunito),),

        ListView(
          children: [
            GestureDetector(
              onTap: () {
                if(question.selectedOption == question.options[0]){BlocProvider.of<TestBloc>(context).add(TestOptionCleared(que: question));}  
                else{
                  BlocProvider.of<TestBloc>(context).add(TestOptionSelected(que: question, optionSelected: question.options[0]));
                }            
              },
              child: QuestionOption(question.options[0], height, width, question.selectedOption == question.options[0])),


            GestureDetector(
              onTap: () {
                if(question.selectedOption == question.options[1]){BlocProvider.of<TestBloc>(context).add(TestOptionCleared(que: question));}  
                else{
                  BlocProvider.of<TestBloc>(context).add(TestOptionSelected(que: question, optionSelected: question.options[1]));
                } 
              },
              child: QuestionOption(question.options[1], height, width, question.selectedOption == question.options[1])),


            GestureDetector(
              onTap: () {
                if(question.selectedOption == question.options[2]){BlocProvider.of<TestBloc>(context).add(TestOptionCleared(que: question));}  
                else{
                  BlocProvider.of<TestBloc>(context).add(TestOptionSelected(que: question, optionSelected: question.options[2]));
                } 
              },
              child: QuestionOption(question.options[2], height, width, question.selectedOption == question.options[2])),


            GestureDetector(
              onTap: () {
                if(question.selectedOption == question.options[3]){BlocProvider.of<TestBloc>(context).add(TestOptionCleared(que: question));}  
                else{
                  BlocProvider.of<TestBloc>(context).add(TestOptionSelected(que: question, optionSelected: question.options[3]));
                } 
              },
              child: QuestionOption(question.options[3], height, width, question.selectedOption == question.options[3]))
          ],
        )
      ],
    ),
  );
}