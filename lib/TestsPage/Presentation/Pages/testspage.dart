import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:study_mate/Test/Presentation/Bloc/test_bloc.dart';
import 'package:study_mate/Test/Presentation/Bloc/testevents.dart';
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
      backgroundColor: Colors.white,
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
            return Container(
              height: height,width: width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height*0.05,),
                    _header(height, width,context),
                    SizedBox(height: height*0.015,),
                    _filterOptions(height, width, state.filters, state.slectedFilter,context),
                    SizedBox(height: height*0.025,),
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
    SizedBox(width: width*0.25,),
    Text("Practice Tests",style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: 18),)
    ],
  );
}

Widget _filterOptions(double height,double width,List<String> optionList,int selected,BuildContext context){
  return Container(
    height: height*0.05,width: width,
    margin: EdgeInsets.only(left: width*0.05),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: optionList.length,
      padding: EdgeInsets.symmetric(vertical: height*0.007),
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
    height: height*0.02,
    padding: EdgeInsets.symmetric(horizontal: width*0.025),
    margin: EdgeInsets.symmetric(horizontal: width*0.01),
    decoration: BoxDecoration(
      color: isSelected ? Colors.green : Colors.white,
      border: Border.all(color: Colors.green),
      borderRadius: BorderRadius.circular(width*0.1)
      ),
      child: Center(child: Text(optionName,style:  TextStyle(color: isSelected ? Colors.white : Colors.green, fontFamily: Fonts.nunito),)),
  );
}


Widget _testsWidget(double height,double width,List<TestInfo> tests){
  return Column(
    children: [
      Row(
        children: [
          SizedBox(width: width*0.05,),
          Text("Availabe Tests",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),),
          SizedBox(width: width*0.35,),
          Container(height: height*0.03,width: width*0.2,
          margin: EdgeInsets.only(right: width*0.05),
          padding: EdgeInsets.symmetric(vertical: height*0.005,horizontal: width*0.02),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),border: Border.all(color: Colors.blueGrey),color: const Color.fromRGBO(250, 250, 250, 1)),
          child: Center(child: Text("${tests.length} Tests",style: TextStyle(color: Colors.blueGrey,fontFamily: Fonts.nunito,fontSize: 12,fontWeight: FontWeight.bold),)),)
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
    padding: EdgeInsets.symmetric(horizontal: width*0.02),
    height: height*0.21,width: width*0.9,
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(180, 180, 180, 1)),
      borderRadius: BorderRadius.circular(20)
    ),
    child: Column(
      children: [
        SizedBox(height: height*0.016,),

        Container(
          height: height*0.08,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Container(height: height*0.05,width: width*0.15,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
              child: Icon(Icons.book,size: 55,),
              ),
          
             // SizedBox(width: width*0.02,),

              Container(
                width: width*0.5,
                height: height*0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: height*0.12,maxWidth: width*0.4,minWidth: width*0.4,minHeight: height*0.03),
                      child: Text(test.name,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: 17),)),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: height*0.02,minWidth: width*0.4,maxWidth: width*0.4,maxHeight: height*0.05),
                      child: Text(test.subject,style: TextStyle(color: Colors.blueGrey,fontFamily: Fonts.nunito,fontSize: 12),))
                  ],
                ),
              ),
          
              Expanded(
                child: Container(
                  height: height*0.03,
                  padding: EdgeInsets.symmetric(horizontal: width*0.015),
                  decoration: BoxDecoration(border: Border.all(color: difficultyIndex[test.diffiucluty.toLowerCase()] ?? Colors.black),borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text(test.diffiucluty,style: TextStyle(color: difficultyIndex[test.diffiucluty.toLowerCase()] ?? Colors.black,fontFamily: Fonts.nunito,fontSize: 12),)),
                ),
              )
            ],
          ),
        ),
        

        Row(
          children: [
            SizedBox(width: width*0.05,),
           Icon(Bootstrap.clock,size: 20,color: Colors.green,),
           SizedBox(width: width*0.024,),
           Container(
            width: width*0.2,
            child: Text("${test.time} mins",style: TextStyle(fontFamily: Fonts.nunito,color: Colors.blueGrey),)
            ),
            SizedBox(width: width*0.06,),
           Icon(Bootstrap.book,size: 20,color: Colors.green,),
           SizedBox(width: width*0.01,),
           Text("${test.totalQuestions} Ques",style: TextStyle(fontFamily: Fonts.nunito,color: Colors.blueGrey),)
          ],
        ),
        SizedBox(height: height*0.015,),
        Container(width: width*0.8, height: 1, color: Colors.grey,),

       InkWell(
        onTap: () { 
          Navigator.push(context, MaterialPageRoute(builder: (context) => BlocProvider(
          create: (context) => TestBloc()..add(
            TestLoadingComplete(id: test.id, difficulty: test.diffiucluty, name: test.name, subject: test.subject, time: test.time, totalQuestions: test.totalQuestions)
          ),
          child: GiveTest())));},

         child: Container(width: width*0.8, height: height*0.06,
           child: Row(
             children: [
               Text("Not Attempted Yet", style: TextStyle(color: Colors.blueGrey,fontSize: 12,fontStyle: FontStyle.italic),),
               SizedBox(width: width*0.23,),
               Container(height: height*0.04,
               padding: EdgeInsets.symmetric(horizontal: width*0.04),
               decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(40)),
               child: Center(child: Text("Start Now >",style: TextStyle(color: Colors.black,fontFamily: Fonts.nunito),)),
               ),
             ],
           ),
         ),
       )
      ],
    ),
  );
}
