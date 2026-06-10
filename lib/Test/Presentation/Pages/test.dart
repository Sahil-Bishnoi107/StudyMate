import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/Test/Presentation/Bloc/test_bloc.dart';
import 'package:study_mate/Test/Presentation/Bloc/testevents.dart';
import 'package:study_mate/Test/Presentation/Bloc/teststates.dart';
import 'package:study_mate/Test/Presentation/Pages/test_submitted_page.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_button.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_icon.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_option.dart';
import 'package:study_mate/fonts.dart';

class Test extends StatefulWidget {

 const Test({super.key});

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
      backgroundColor: Colors.white,
      body: BlocConsumer<TestBloc,Teststates>(

      listener: (context, state) {
          if(state is TestSubmitted){
            Navigator.push(context, MaterialPageRoute(builder: (context) => TestSubmittedPage()));
          }
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
        return Container(
          height: height, width: width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                 _header(height, width, state.timeLeft, state.test.name),
                 SizedBox(height: height*0.01,),
                // Container(color: const Color.fromRGBO(200, 200, 200, 0.6), height: 2, width: width,),
               
                 _testProgress(height, width, context, state.test.questions, pageController),
                 
                 Container(height: 2,width: width,color: const Color.fromRGBO(200, 200, 200, 0.6),),
                 SizedBox(height: height*0.02,),
                 _questionSection(height, width, state.test.questions, pageController)
                
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
  String minutes = (timeLeft / 60).toInt() < 10 ? "0${(timeLeft / 60).toInt().toString()}" : (timeLeft / 60).toInt().toString();

  String seconds = (timeLeft % 60 ) < 10 ? "0${(timeLeft % 60 ).toString()}"    : (timeLeft % 60 ).toString();
  return Container(
    constraints: BoxConstraints(minHeight: height*0.05,maxHeight: height*0.1),
    width: width,
    padding: EdgeInsets.only(left: width*0.05),
    margin: EdgeInsets.only(top: height*0.05),
    child: Row(
    children: [
      Container(
        width: width*0.65,
        child: Text(testName,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: 20),)
        ),

      Container(
        height: height*0.035,
        width: width*0.25,
        decoration: BoxDecoration(color: const Color.fromRGBO(76, 175, 80, 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green)
        ),
        child: Center(
          child: Row(
            children: [
              SizedBox(width: width*0.02,),
              Icon(Bootstrap.stopwatch,size: 15,color: Colors.green,fontWeight: FontWeight.bold,),
              SizedBox(width: width*0.015,),
              Text("$minutes : $seconds",style: TextStyle(color: Colors.green,fontFamily: Fonts.nunito,fontWeight: FontWeight.bold),),
            ],
          )),
        )  

    ],
    ),
  );
}

Widget _questionSection(double height,double width, List<Question> questions,PageController pageController){
  return Column(
    children: [
     Container(
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
          child: queButton(height, width, false)),
          SizedBox(width: width*0.1,),
        GestureDetector(
          onTap: () {
            pageController.nextPage(duration: Duration(microseconds: 300), curve: Curves.easeOut);
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

        //header
        Row(
          children: [
            Container(
              height: height*0.034,width: width*0.36,
              decoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(180, 180, 180, 0.7),width: 1.5),borderRadius: BorderRadius.circular(20)),
              child: Center(child: Text("Question ${(currQue+1).toString()} of $totalQuestions",style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: 12),)),
            ),
            SizedBox(width: width*0.35,),
            Expanded(child: Text(question.difficulty,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold),)),
          ],
        ),
        SizedBox(height: height*0.01,),
        //Question
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: height*0.03, maxHeight: height*0.5,minWidth: width*0.9,maxWidth: width*0.9),
          
          child: Text(question.description,style: TextStyle(fontFamily: Fonts.inter,fontWeight: FontWeight.bold, fontSize: 20),)),

        //Options
        Container(
          height: height*0.4,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  if(question.selectedOption == question.options[0]){BlocProvider.of<TestBloc>(context).add(TestOptionCleared(que: question));}  
                  else{
                    BlocProvider.of<TestBloc>(context).add(TestOptionSelected(que: question, optionSelected: question.options[0]));
                  }            
                },
                child: QuestionOption(question.options[0], height, width, question.selectedOption == question.options[0],"A")),
          
          
              GestureDetector(
                onTap: () {
                  if(question.selectedOption == question.options[1]){BlocProvider.of<TestBloc>(context).add(TestOptionCleared(que: question));}  
                  else{
                    BlocProvider.of<TestBloc>(context).add(TestOptionSelected(que: question, optionSelected: question.options[1]));
                  } 
                },
                child: QuestionOption(question.options[1], height, width, question.selectedOption == question.options[1],"B")),
          
          
              GestureDetector(
                onTap: () {
                  if(question.selectedOption == question.options[2]){BlocProvider.of<TestBloc>(context).add(TestOptionCleared(que: question));}  
                  else{
                    BlocProvider.of<TestBloc>(context).add(TestOptionSelected(que: question, optionSelected: question.options[2]));
                  } 
                },
                child: QuestionOption(question.options[2], height, width, question.selectedOption == question.options[2],"C")),
          
          
              GestureDetector(
                onTap: () {
                  if(question.selectedOption == question.options[3]){BlocProvider.of<TestBloc>(context).add(TestOptionCleared(que: question));}  
                  else{
                    BlocProvider.of<TestBloc>(context).add(TestOptionSelected(que: question, optionSelected: question.options[3]));
                  } 
                },
                child: QuestionOption(question.options[3], height, width, question.selectedOption == question.options[3],"D"))
            ],
          ),
        )
      ],
    ),
  );
}


Widget _testProgress(double height, double width,BuildContext context,List<Question> questions,PageController pageController){
  return Container(
    
    height: height*0.05,width: width*0.9,
    child: ListView.builder(
     scrollDirection: Axis.horizontal,
     itemCount: questions.length + 1,
     itemBuilder: (context, index) {
       if(index == questions.length){
        return GestureDetector(
          onTap: () {
            BlocProvider.of<TestBloc>(context).add(TestSubmittedEvent());
          },
          child: Align(
            alignment: Alignment.center,
            child: Container(height: height*0.04,width: width*0.2,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.green),
            child: Center(child: Text("Submit",style: TextStyle(color: Colors.white,fontFamily: Fonts.nunito),),),
            ),
          ),
        );
       }
       return GestureDetector(
        onTap: () {
          pageController.animateToPage(index, duration: Duration(microseconds: 300), curve: Curves.bounceIn);
        },
        child: questionIcon(height, width, questions[index].selectedOption != null, index + 1));
     },

    ),

  );
}