import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsBloc.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsEvents.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsStates.dart';
import 'package:study_mate/QuestionsSection/Presentation/Pages/QuestionPage.dart';
import 'package:study_mate/QuestionsSection/Presentation/Widgets/difficulty_selection.dart';
import 'package:study_mate/QuestionsSection/Presentation/Widgets/filter_selection.dart';

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
        if(state is QuestionsInitialState){
        return Scaffold(
          body:  SingleChildScrollView(
            child: Column(
              children: [
              _header(height, width),
              Container(height: 1.5, width: width, color: const Color.fromRGBO(220, 220, 220, 0.8),),
              FilterSelection(filterOptions:state.filters.subjects, type: "Difficulty", filterIndex: 0, icon: FontAwesome.atom_solid,),
              SizedBox(height: height*0.04,),
              FilterSelection(filterOptions: state.filters.examType, type: "Exam", filterIndex: 1, icon: FontAwesome.hand_fist_solid),
              SizedBox(height: height*0.05,),
              _difficultySelector(height, width),
              _proTip(height, width),
              Container(height: 1, width: width, color: const Color.fromRGBO(220, 220, 220, 0.8),),
              if(state is FetchingQuestionsState) _loadingButton(height, width),
              if(state is! FetchingQuestionsState) GestureDetector(
                onTap: () {
                  BlocProvider.of<Questionsbloc>(context).add(SearchQuestions());
                },
                child: _startButton(height, width))
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


Widget _header(double height,double width){
  return SizedBox(
    height: height*0.1,
    child: Row(
      children: [
       SizedBox(width: width*0.07,),
       Icon(Icons.arrow_back_ios),
       SizedBox(width: width*0.05,),
       Column(
        children: [
          Text("Practice Questions"),
          Text("Choose filters to generate your questions")
        ],
       )
      ],
    ),
  );
}

Widget _difficultySelector(double height, double width){
  return Container(
    height: height*0.25,width: width*0.9,
    margin: EdgeInsets.symmetric(horizontal: width*0.05),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(width: 1.5, color: const Color.fromRGBO(220, 220, 220, 0.8))
    ),
    child: Column(
      children: [
       Row(
        children: [
          Icon(FontAwesome.bullseye_solid),
          SizedBox(width: width*0.05,),
          SizedBox(width: width*0.6, child: Text("DIFFICULTY LEVEL")),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width*0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(76, 175, 80, 0.3)
            ),
            child: Text("Default"),
          )
        ],
       ),

       CustomOverlayWidget(),

       SizedBox(height: height*0.02,),
       Text("Mixed difficulty provides a balanced set of questions ranging from foundational concepts to advanced problem solving",
       
       )
      ],
    ),
  );
}


Widget _proTip(double height, double width){
  return Container(
    height: height*0.15, width: width*0.9,
    decoration: BoxDecoration(
      color: const Color.fromRGBO(76, 175, 80, 0.4),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.green)
    ),
    child: Center(
      child: Row(
        children: [
          SizedBox(width: width*0.05,), Icon(Bootstrap.book),
          SizedBox(width: width*0.02,),
          Column(children: [
            Text("Pro Tip"),
            Text("Selecting Multiple Subjects generates a more comprehensive mock test environment")
          ],)
        ],
      ),
    ),
  );
}

Widget _startButton(double height, double width){
  return Container(
    height: height*0.06, width: width*0.9,
    decoration: BoxDecoration(color: Colors.green,
    borderRadius: BorderRadius.circular(20),
    ),
    child: Center(
      child: Text("Start Test"),
    ),
  );
}

Widget _loadingButton(double height, double width){
  return Container(
     height: height*0.06, width: width*0.9,
    decoration: BoxDecoration(color: Colors.green,
    borderRadius: BorderRadius.circular(20),
    ),
    child: Center(
      child: Row(
        children: [
          LoadingAnimationWidget.flickr(leftDotColor: Colors.green,rightDotColor: Colors.yellow,size: 20),
          SizedBox(width: width*0.04,),
          Text("Start Test"),
        ],
      ),
    ),
  );
}