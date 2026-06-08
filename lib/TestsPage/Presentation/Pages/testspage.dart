import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:study_mate/Test/Presentation/Pages/test.dart';
import 'package:study_mate/TestsPage/Domain/entities/Test.dart';
import 'package:study_mate/TestsPage/Presentation/Bloc/TestBloc.dart';
import 'package:study_mate/TestsPage/Presentation/Bloc/TestEvents.dart';
import 'package:study_mate/TestsPage/Presentation/Bloc/TestStates.dart';
import 'package:study_mate/fonts.dart';

class TestsPage extends StatelessWidget {
  const TestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocBuilder<TestPageBloc,TestPagestates>(
        builder: (context,state){
           if(state is LoadingTestPageState){
            return Container(
              child: Center(
                child: LoadingAnimationWidget.hexagonDots(color: Colors.greenAccent, size: 50),
              ),
            );
           }
           if(state is FailureTestPageState){
              return Container(
                child: Center(
                  child: Text("Failure to Load Tests",style: TextStyle(color: Colors.red),),
                ),
              );
            }
            state as LoadedTestPageState;
            return SingleChildScrollView(
              child: Container(
                height: height,width: width,
                child: Column(
                  children: [
                    _header(height, width,context),
                    _filterOptions(height, width, state.filters, state.slectedFilter,context),
                    _testsWidget(height, width, state.filteredTests)
                  ],
                ),
              ),
            );
        })
    );
  }
}







Widget _header(double height,double width,BuildContext context){
  return Row(
    children: [
    SizedBox(width: width*0.05,),
    InkWell(
      onTap: () => Navigator.pop(context),
      child: Icon(Icons.arrow_back_ios_new)),
    SizedBox(width: width*0.05,),
    Text("Practice Tests")
    ],
  );
}

Widget _filterOptions(double height,double width,List<String> optionList,int selected,BuildContext context){
  return Container(
    height: height*0.05,width: width,
    child: ListView.builder(
      itemCount: optionList.length,
      itemBuilder: (context,index){
        return GestureDetector(
          onTap: () {
            BlocProvider.of<TestPageBloc>(context).add(FilterTests(filter: index));
          },
          child: _filterBox(height, width, index == selected , optionList[index]));
      }
      ),
  );
}

Widget _filterBox(double height,double width,bool isSelected,String optionName){
  return Container(
    height: height*0.02,width: width*0.06,
    decoration: BoxDecoration(
      color: isSelected ? Colors.green : Colors.white,
      border: Border.all(color: Colors.green),
      borderRadius: BorderRadius.circular(10)
      ),
      child: Text(optionName,style:  TextStyle(color: isSelected ? Colors.white : Colors.green, fontFamily: Fonts.nunito),),
  );
}


Widget _testsWidget(double height,double width,List<TestInfo> tests){
  return Column(
    children: [
      Row(
        children: [
          SizedBox(width: width*0.05,),
          Text("Availabe Tests"),
          SizedBox(width: width*0.5,),
          Container(height: height*0.02,width: width*0.04,child: Text("${tests.length} Tests"),)
        ],
      ),
      _testsList(height, width, tests)

    ],
  );
}


Widget _testsList(double height,double width,List<TestInfo> tests){
  return Container(
  width: width*0.9,
  child: ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: tests.length,
    itemBuilder: (context,index){
     return _testOption(height, width, tests[index],context);
    }),
  );
}


Widget _testOption(double height,double width,TestInfo test,BuildContext context){
  Map<String,Color> difficultyIndex = {
    "hard" : Colors.red,
    "medium" : Colors.amber,
    "easy" : Colors.green
  };
   
  return Container(
    margin: EdgeInsets.only(bottom: height*0.03),
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    height: height*0.25,width: width*0.9,
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(180, 180, 180, 1)),
      borderRadius: BorderRadius.circular(20)
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(height: height*0.1,width: width*0.15,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            child: Icon(Icons.book),
            ),

            Container(
              width: width*0.5,
              height: height*0.15,
              child: Column(
                children: [
                  Text(test.name),
                  Text(test.subject)
                ],
              ),
            ),

            Container(
              height: height*0.01,width: width*0.03,
              decoration: BoxDecoration(border: Border.all(color: difficultyIndex[test.diffiucluty.toLowerCase()] ?? Colors.black),borderRadius: BorderRadius.circular(5)),
              child: Text(test.diffiucluty,style: TextStyle(color: difficultyIndex[test.diffiucluty.toLowerCase()] ?? Colors.black,fontFamily: Fonts.nunito),),
            )
          ],
        ),

        Row(
          children: [
           Icon(Bootstrap.clock),
           SizedBox(width: width*0.01,),
           Container(
            width: width*0.2,
            child: Text("${test.time} minutes",style: TextStyle(fontFamily: Fonts.nunito),)
            ),
           Icon(Bootstrap.book),
           SizedBox(width: width*0.01,),
           Text("${test.totalQuestions} Ques",style: TextStyle(fontFamily: Fonts.nunito),)
          ],
        ),

        Container(width: width*0.8, height: 1, color: Colors.grey,),

       InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Test(testId: test.id))),
         child: Container(width: width*0.8, height: height*0.1, alignment: Alignment.centerRight,
           child: Container(height: height*0.06,width: width*0.3,
           decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(15)),
           child: Text("Start Now >",style: TextStyle(color: Colors.black,fontFamily: Fonts.nunito),),
           ),
         ),
       )
      ],
    ),
  );
}
