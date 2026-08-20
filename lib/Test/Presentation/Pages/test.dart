import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';

import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
import 'package:study_mate/Test/Data/test_repo.dart';
import 'package:study_mate/Test/Presentation/Bloc/SubmitBloc/SubmitBloc.dart';
import 'package:study_mate/Test/Presentation/Bloc/SubmitBloc/SubmitEvents.dart';

import 'package:study_mate/Test/Presentation/Bloc/test_bloc.dart';
import 'package:study_mate/Test/Presentation/Bloc/testevents.dart';
import 'package:study_mate/Test/Presentation/Bloc/teststates.dart';
import 'package:study_mate/Test/Presentation/Pages/test_submitted_page.dart';
import 'package:study_mate/Test/Presentation/Widgets/fixedTextWidget.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_button.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_icon.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_option.dart';
import 'package:study_mate/fonts.dart';

class GiveTest extends StatefulWidget {

 const GiveTest({super.key});

  @override
  State<GiveTest> createState() => _TestState();
}

class _TestState extends State<GiveTest> {
  PageController pageController =  PageController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<TestBloc,Teststates>(

      listener: (context,state){   
         if(state is TestSubmitState){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BlocProvider(
              create: (context) => Submitbloc(sl<TestRepo>())..add(TestSubmittedEvent(test: state.test, timeLeft: state.timeLeft)),
              child: TestSubmittedPage())));
          }
      },

      builder: (context, state) {
        if(state is TestLoading){
          return Container(
            child: Center(
              child: LoadingLogo(),
            ),
          );
        }

        
        if(state is TestLoaded){
        return SizedBox(
          height: height, width: width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                 _header(height, width, state.timeLeft, state.test.name,context),
                 SizedBox(height: height*0.01,),
                 Container(height: 1,width: width,color: const Color.fromRGBO(200, 200, 200, 0.6),),
                // Container(color: const Color.fromRGBO(200, 200, 200, 0.6), height: 2, width: width,),
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
            child: SizedBox.shrink()
          ),
        );
      },
      ),
    );
  }
}




Widget _header(double height,double width,int timeLeft,String testName,BuildContext context){
  String minutes = (timeLeft / 60).toInt() < 10 ? "0${(timeLeft / 60).toInt().toString()}" : (timeLeft / 60).toInt().toString();

  String seconds = (timeLeft % 60 ) < 10 ? "0${(timeLeft % 60 ).toString()}"    : (timeLeft % 60 ).toString();
  return Container(
    constraints: BoxConstraints(minHeight: height*0.05,maxHeight: height*0.1),
    width: width,
    padding: EdgeInsets.only(left: width*0.05),
    margin: EdgeInsets.only(top: height*0.05),
    child: Row(
    children: [
      SizedBox(
        width: width*0.65,
        child: Text(testName,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 20)),)
        ),

      Container(
        height: height*0.035,
        width: width*0.25,
        decoration: BoxDecoration(color: const Color.fromRGBO(76, 175, 80, 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green)
        ),
        child: Center(
          child: Row(
            children: [
              SizedBox(width: width*0.02,),
              Icon(Bootstrap.stopwatch,size: Responsive.icon(context, 15),color: Colors.green,fontWeight: FontWeight.bold,),
              SizedBox(width: width*0.015,),
              Text("$minutes : $seconds",style: TextStyle(color: Colors.green,fontFamily: Fonts.nunito,fontWeight: FontWeight.bold),),
            ],
          )),
        )  

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
          return SingleChildScrollView(child: _question(height, width, questions[index], index, questions.length, context));
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
 late String difficulty;
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
            SizedBox(width: width*0.32,),
            Expanded(child: Row(
              children: [
                Icon(Bootstrap.exclamation_circle,size: Responsive.icon(context, 15),),
                const SizedBox(width: 5,),
                Text(difficulty,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold),),
              ],
            )),
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
              GestureDetector(
                onTap: () {
                  if(question.selectedOption == question.options[0]){BlocProvider.of<TestBloc>(context).add(TestOptionCleared(que: question));}  
                  else{
                    BlocProvider.of<TestBloc>(context).add(TestOptionSelected(que: question, optionSelected: question.options[0]));
                  }            
                },
                child: QuestionOption(question.options[0], height, width, question.selectedOption == question.options[0],"A",context)),
          
          
              GestureDetector(
                onTap: () {
                  if(question.selectedOption == question.options[1]){BlocProvider.of<TestBloc>(context).add(TestOptionCleared(que: question));}  
                  else{
                    BlocProvider.of<TestBloc>(context).add(TestOptionSelected(que: question, optionSelected: question.options[1]));
                  } 
                },
                child: QuestionOption(question.options[1], height, width, question.selectedOption == question.options[1],"B",context)),
          
          
              GestureDetector(
                onTap: () {
                  if(question.selectedOption == question.options[2]){BlocProvider.of<TestBloc>(context).add(TestOptionCleared(que: question));}  
                  else{
                    BlocProvider.of<TestBloc>(context).add(TestOptionSelected(que: question, optionSelected: question.options[2]));
                  } 
                },
                child: QuestionOption(question.options[2], height, width, question.selectedOption == question.options[2],"C",context)),
          
          
              GestureDetector(
                onTap: () {
                  if(question.selectedOption == question.options[3]){BlocProvider.of<TestBloc>(context).add(TestOptionCleared(que: question));}  
                  else{
                    BlocProvider.of<TestBloc>(context).add(TestOptionSelected(que: question, optionSelected: question.options[3]));
                  } 
                },
                child: QuestionOption(question.options[3], height, width, question.selectedOption == question.options[3],"D",context)),

                SizedBox(height: height*0.02,)
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
     itemCount: questions.length + 1,
     itemBuilder: (context, index) {
       if(index == questions.length){
        return GestureDetector(
          onTap: () {
            BlocProvider.of<TestBloc>(context).add(TestSubmitEvent());
          },
          child: Align(
            alignment: Alignment.center,
            child: Container(height: height*0.04,width: width*0.2,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.green),
            child: Center(child: Text("Submit",style: TextStyle(color: Colors.white,fontFamily: Fonts.outfit),),),
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