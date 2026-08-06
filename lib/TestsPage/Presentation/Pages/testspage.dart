import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';
import 'package:study_mate/Home/Presentation/Widgets/drawer.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
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
      drawer: mainDrawer(height, width, context),
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      body: BlocBuilder<TestPageBloc,TestPagestates>(
        builder: (context,state){
           if(state is LoadingTestPageState){
            return Container(
              child: Center(
                child: LoadingLogo(),
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
            return SizedBox(
              height: height,width: width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height*0.06,),
                    _header(height, width,context),
                    SizedBox(height: height*0.015,),
                    Container(height: 1.3,width: width,color: const Color.fromRGBO(200, 200, 200, 0.5),),
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
    SizedBox(width: width*0.06,),
    InkWell(
      onTap: () => Scaffold.of(context).openDrawer(),
      child: Icon(Icons.menu_rounded,size: 30,)),
    SizedBox(width: width*0.07,),
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
 const Color greyColor = Color.fromRGBO(200, 200, 200, 0.8);
  return Container(
    height: height*0.03,
    padding: EdgeInsets.symmetric(horizontal: width*0.035),
    margin: EdgeInsets.symmetric(horizontal: width*0.01),
    decoration: BoxDecoration(
      color: isSelected ? Colors.green : const Color.fromRGBO(252, 252, 252, 1),
      border: Border.all(color: isSelected ? Colors.green : greyColor),
      borderRadius: BorderRadius.circular(width*0.1)
      ),
      child: Center(child: Text(optionName,style:  TextStyle(color: isSelected ? Colors.black : Colors.blueGrey, fontFamily: Fonts.nunito),)),
  );
}


Widget _testsWidget(double height,double width,List<TestInfo> tests){
  return Column(
    children: [
      Row(
        children: [
          SizedBox(width: width*0.06,),
          Text("Availabe Tests",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black,fontFamily: Fonts.nunito),),
          SizedBox(width: width*0.32,),
          Container(height: height*0.03,width: width*0.2,
          margin: EdgeInsets.only(right: width*0.05),
          padding: EdgeInsets.symmetric(vertical: height*0.005,horizontal: width*0.02),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: const Color.fromRGBO(200, 200, 200, 0.15)),
          child: Center(child: Text("${tests.length} Tests",style: TextStyle(color: Colors.blueGrey,fontFamily: Fonts.nunito,fontSize: 12,fontWeight: FontWeight.bold),)),)
        ],
      ),
      _testsList(height, width, tests)

    ],
  );
}


Widget _testsList(double height,double width,List<TestInfo> tests){
  List<IconData> icons = [Bootstrap.journal_check,Bootstrap.patch_check_fill,FontAwesome.brain_solid,FontAwesome.graduation_cap_solid,FontAwesome.clipboard_check_solid];
  return SizedBox(
  width: width*0.9,
  child: ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: tests.length,
    itemBuilder: (context,index){
     return _testOption(height, width, tests[index],context,icons[0]);
    }),
  );
}


Widget _testOption(double height,double width,TestInfo test,BuildContext context,IconData icon){
 const Color greenColor = Colors.green;
 
  Map<String,Color> difficultyIndex = {
    "hard" : Color.fromRGBO(255, 8, 0, 1),
    "medium" : const Color.fromRGBO(255, 193, 7, 1),
    "easy" : Colors.green
  };
  Map<String,Color> difficultyIndexBorder = {
    "hard" : const Color.fromRGBO(255, 8, 0, 0.4),
    "medium" : const Color.fromRGBO(255, 193, 7, 0.4),
    "easy" : const Color.fromRGBO(76, 175, 80, 0.4)
  };
  Map<String,Color> difficultyIndexBg = {
    "hard" : const Color.fromRGBO(255, 8, 0, 0.05),
    "medium" : const Color.fromRGBO(255, 193, 7, 0.05),
    "easy" : const Color.fromRGBO(76, 175, 80, 0.05)
  };
   
  return Container(
    margin: EdgeInsets.only(bottom: height*0.03),
    padding: EdgeInsets.symmetric(horizontal: width*0.02),
    height: height*0.21,width: width*0.9,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.5),width: 1.5),
      borderRadius: BorderRadius.circular(20)
    ),
    child: Column(
      children: [
        SizedBox(height: height*0.016,),

        SizedBox(
          height: height*0.08,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Container(height: height*0.05,width: width*0.15,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
              child: Icon(icon,size: 50,color: const Color.fromRGBO(120, 120, 120, 1),),
              ),
          
              SizedBox(width: width*0.01,),

              SizedBox(
                width: width*0.5,
                height: height*0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ 
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: height*0.12,maxWidth: width*0.5,minWidth: width*0.5,minHeight: height*0.03),
                      child: Text(test.name,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: 17),)),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: height*0.02,minWidth: width*0.5,maxWidth: width*0.5,maxHeight: height*0.05),
                      child: Text(test.subject,style: TextStyle(color: Colors.blueGrey,fontFamily: Fonts.nunito,fontSize: 12),))
                  ],
                ),
              ),
          
              Expanded(
                child: Container(
                  height: height*0.028,
                 // padding: EdgeInsets.symmetric(horizontal: width*0.0),
                  decoration: BoxDecoration(
                    color: difficultyIndexBg[test.diffiucluty.toLowerCase()],
                    border: Border.all(width: 1,color: difficultyIndexBorder[test.diffiucluty.toLowerCase()] ?? Colors.black),borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text(test.diffiucluty,style: TextStyle(color: difficultyIndex[test.diffiucluty.toLowerCase()] ?? Colors.black,fontFamily: Fonts.nunito,fontSize: 10,fontWeight: FontWeight.bold),)),
                ),
              )
            ],
          ),
        ),
        

        Row(
          children: [
            SizedBox(width: width*0.05,),
           Icon(FontAwesome.clock,size: 20,color: greenColor,),
           SizedBox(width: width*0.024,),
           SizedBox(
            width: width*0.2,
            child: Text("${test.time} mins",style: TextStyle(fontFamily: Fonts.nunito,color: Colors.blueGrey),)
            ),
            SizedBox(width: width*0.06,),
           Icon(FontAwesome.file_lines,size: 20,color: greenColor,),
           SizedBox(width: width*0.01,),
           Text("${test.totalQuestions} Ques",style: TextStyle(fontFamily: Fonts.nunito,color: Colors.blueGrey),)
          ],
        ),
        SizedBox(height: height*0.015,),
        Container(width: width*0.8, height: 1.5, color: const Color.fromRGBO(220, 220, 220, 0.5),),
         SizedBox(height: height*0.005,),
       SizedBox(width: width*0.8, height: height*0.06,
         child: Row(
           children: [
            SizedBox(width: width*0.025,),
             Text("Not Attempted Yet", style: TextStyle(color: Colors.blueGrey,fontSize: 12,fontStyle: FontStyle.italic),),
             SizedBox(width: width*0.175,),

             InkWell(
              onTap: () { 
          Navigator.push(context, MaterialPageRoute(builder: (context) => BlocProvider(
          create: (context) => sl<TestBloc>()..add(
            TestLoadingComplete(id: test.id, difficulty: test.diffiucluty, name: test.name, subject: test.subject, time: test.time, totalQuestions: test.totalQuestions)
          ),
          child: GiveTest())));},
               child: Container(height: height*0.04,
               padding: EdgeInsets.symmetric(horizontal: width*0.04),
               decoration: BoxDecoration(color: greenColor, borderRadius: BorderRadius.circular(40)),
               child: Center(child: Row(
                 children: [
                   Text("Start Now",style: TextStyle(color: Colors.black,fontFamily: Fonts.nunito),),
                   
                   Icon(Icons.arrow_forward_ios_outlined,size: 15,)
                 ],
               )),
               ),
             ),
           ],
         ),
       )
      ],
    ),
  );
}
