import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';

import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsBloc.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsEvents.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsStates.dart';
import 'package:study_mate/QuestionsSection/Presentation/Pages/QuestionPage.dart';
import 'package:study_mate/QuestionsSection/Presentation/Widgets/difficulty_selection.dart';
import 'package:study_mate/QuestionsSection/Presentation/Widgets/filter_selection.dart';
import 'package:study_mate/fonts.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocConsumer<Questionsbloc,Questionsstates>(
      listener: (context, state) {
        if(state is QuestionFetchFailed){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar( 
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
              ));
        }

        if(state is LoadQuestionsState){
          Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionsPage()));
        }
      },
      builder: (context, state) {
        if(state is FetchingQuestionsState){
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
             child: LoadingLogo(),
            ),
          );
        }
        if(state is QuestionsInitialState){
        return Scaffold(
          backgroundColor: Colors.white,
          body:  SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height*0.05,),
              _header(height, width, context),
              Container(height: 1.75, width: width, color: const Color.fromRGBO(220, 220, 220, 0.8),),
              SizedBox(height: height*0.03,),
              FilterSelection(filterOptions:state.filters.subjects, type: "SUBJECT", filterIndex: 0, icon: FontAwesome.atom_solid,),
              SizedBox(height: height*0.02,),
              FilterSelection(filterOptions: state.filters.examType, type: "Exam", filterIndex: 1, icon: FontAwesome.hand_fist_solid),
              SizedBox(height: height*0.02,),
              _difficultySelector(height, width,context),
              SizedBox(height: height*0.03,),
              _proTip(height, width,context),
              SizedBox(height: height*0.04,),
              Container(height: 1, width: width, color: const Color.fromRGBO(220, 220, 220, 0.8),),
              SizedBox(height: height*0.02,),
               GestureDetector(
                onTap: () {
                  BlocProvider.of<Questionsbloc>(context).add(SearchQuestions());
                },
                child: _startButton(height, width,context))
              ],
            ),
          ),
        );
        }

        else{
          return SizedBox.shrink();
        }
      }
    );
  }
}


Widget _header(double height,double width,BuildContext context){
  return SizedBox(
    height: height*0.063,
    child: Row(
      children: [
       SizedBox(width: width*0.07,),
       Padding(
         padding: EdgeInsetsGeometry.only(bottom: height*0.015),
         child: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios)),
       ),
       SizedBox(width: width*0.05,),
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Practice Questions",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 19),fontWeight: FontWeight.w600),),
          Text("Choose filters to generate your questions",style: TextStyle(color: const Color.fromRGBO(118, 118, 118, 1),fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 12)),)
        ],
       )
      ],
    ),
  );
}

Widget _difficultySelector(double height, double width,BuildContext context){
  return Container(
    height: height*0.22,width: width*0.9,
    margin: EdgeInsets.symmetric(horizontal: width*0.05),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 1.5, color: const Color.fromRGBO(220, 220, 220, 0.8))
    ),
    child: Column(
      children: [
        SizedBox(height: height*0.01,),
       Row(
        children: [
          SizedBox(width: width*0.05,),
          Icon(FontAwesome.bullseye_solid, color: Colors.green,),
          SizedBox(width: width*0.02,),
          SizedBox(width: width*0.54, child: Text("DIFFICULTY LEVEL", style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600),)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width*0.03,vertical: height*0.004),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color.fromRGBO(76, 175, 80, 0.2),
              border: Border.all(color: Colors.green)
            ),
            child: Text("Default",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 12))),
          )
        ],
       ),
       SizedBox(height: height*0.01,),
       CustomOverlayWidget(),

       SizedBox(height: height*0.015,),
       Padding(
         padding: EdgeInsetsGeometry.symmetric(horizontal: width*0.05),
         child: Text("Mixed difficulty provides a balanced set of questions ranging from foundational concepts to advanced problem solving",
         style: TextStyle(color: const Color.fromRGBO(100, 100, 100, 1),fontFamily: Fonts.nunito),
         ),
       )
      ],
    ),
  );
}


Widget _proTip(double height, double width,BuildContext context){
  return Container(
    height: height*0.1, width: width*0.9,
    decoration: BoxDecoration(
      color: const Color.fromRGBO(76, 175, 80, 0.06),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color.fromRGBO(76, 175, 80, 0.2),width: 1.5)
    ),
    child: Center(
      child: Row(
        children: [
          SizedBox(width: width*0.05,), 
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
             
              color: const Color.fromRGBO(76, 175, 80, 0.1)
            ),
            child: Icon(FontAwesome.lightbulb_solid,color: Colors.green,)),

          SizedBox(width: width*0.02,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height*0.01,),
            Text("Pro Tip",style: TextStyle(color: Colors.green,fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 16)),),
            SizedBox(
              width: width*0.7,
              child: Text("Selecting Multiple Subjects generates a more comprehensive mock test environment",
              style: TextStyle(color: const Color.fromRGBO(100, 100, 100, 1), fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 12)),
              ))
          ],)
        ],
      ),
    ),
  );
}

Widget _startButton(double height, double width,BuildContext context){
  return Container(
    height: height*0.06, width: width*0.9,
    decoration: BoxDecoration(color: Colors.green,
    borderRadius: BorderRadius.circular(100),
    ),
    child: Center(
      child: Text("Start Test", style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 16)),),
    ),
  );
}

