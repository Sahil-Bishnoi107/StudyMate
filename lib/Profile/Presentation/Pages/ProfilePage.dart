import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/Home/Presentation/Widgets/drawer.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
import 'package:study_mate/Notifications/Presentation/Pages/NotificationPage.dart';
import 'package:study_mate/Profile/Domain/student.dart';
import 'package:study_mate/Profile/Presentation/Bloc/ProfileBloc.dart';
import 'package:study_mate/Profile/Presentation/Bloc/ProfileEvents.dart';
import 'package:study_mate/Profile/Presentation/Bloc/ProfileStates.dart';
import 'package:study_mate/fonts.dart';

import 'package:study_mate/Profile/Presentation/Widgets/ProfileTopSection.dart';
import 'package:study_mate/Profile/Presentation/Widgets/RatingSection.dart';
import 'package:study_mate/Profile/Presentation/Widgets/RatingGraph.dart';
import 'package:study_mate/Profile/Presentation/Widgets/ContestHistorySection.dart';
import 'package:study_mate/Profile/Presentation/Widgets/QuestionStatsSection.dart';
import 'package:study_mate/Profile/Presentation/Widgets/RecentTestsSection.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<Profilebloc>(context).add(LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white, 
      drawer: mainDrawer(height, width, context),
     
      body: BlocBuilder<Profilebloc, Profilestates>(
        builder: (context, state) {
          if (state is InitialProfileState || state is LoadingProfileState) {
            return Center(
              child: LoadingLogo(),
            );
          } else if (state is LoadedProfileState) {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<Profilebloc>(context).add(LoadProfileEvent());
              },
              child: Column(
                
                children: [
                  SizedBox(height: height*0.05,),
                  _appBar(height, width, context),
                  Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,width: width,),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                     
                      _headerSection(height, width, state.student, state.contest),
                      _graphHeader(height, width),
                      const SizedBox(height: 20,),
                      _commonStatSection(height, width, 22, state.questions.length, state.student.testsGiven.length, state.contest.length),
                      SizedBox(height: height*0.02,),
                      
                     // const SizedBox(height: 25),
                      RatingGraph(contests: state.contest),
                      const SizedBox(height: 25),
                      ContestHistorySection(contests: state.contest,width: width,),
                      const SizedBox(height: 25),
                      QuestionStatsSection(questions: state.questions),
                      
                      const SizedBox(height: 25),
                      RecentTestsSection(tests: state.student.testsGiven,width: width,),
                      const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  )
                
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                "Failed to load profile",
                style: TextStyle(color: Colors.red, fontFamily: Fonts.nunito),
              ),
            );
          }
        },
      ),
    );
  }
}

Widget _appBar(double height,double width,BuildContext context){
  return Container(
    height: height*0.05,
    margin: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Row(
      children: [
        InkWell(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Icon(Icons.menu_sharp,size: 30,)),
          SizedBox(width: width*0.05,),
          Expanded(child: Text("Profile",style: TextStyle(color: Colors.black,fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: 18),)),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Notificationpage())),
            child: Icon(Icons.notifications_none_sharp))
      ],
    ),
  );
}



Widget _headerSection(double height, double width, Student student,List<MyContest> contests){
  return Row(
    children: [
      RatingSection(student: student, contests: contests,height: height,width: width,),
      ProfileTopSection(student: student,height: height,width: width,),
    ],
  );
}

Widget _graphHeader(double height, double width){
  final scale = (min(width, height) / 435).clamp(0.8, 1.2); 
  return Container(
    height: height*0.04,width: width,
    margin: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Row(
      children: [
      Text("Your",style: TextStyle(color: Colors.black,fontFamily: Fonts.outfit,fontSize: 20*scale,fontWeight: FontWeight.w600),),
      Text(" Progress ",style: TextStyle(color: Colors.green,fontFamily: Fonts.outfit,fontSize: 20*scale,fontWeight: FontWeight.w600),),
      Text("So Far",style: TextStyle(color: Colors.black,fontFamily: Fonts.outfit,fontSize: 20*scale,fontWeight: FontWeight.w600),),
      Text(".",style: TextStyle(color: Colors.green,fontFamily: Fonts.outfit,fontSize: 20*scale,fontWeight: FontWeight.w600),)
      ],
    ),
  );
}

Widget _commonStatSection(double height, double width,int rank,int questions,int tests,int contests){
  return Column(
    children: [
      Row(
        children: [
          Expanded(child: _commonStat(height, width, LucideIcons.medal400Dir, "Global Rank", "#$rank")),
          
          Expanded(child: _commonStat(height, width, LucideIcons.notebookPen400Dir, "Questions", questions.toString()))
        ],
      ),
      const SizedBox(height: 10,),
      Row(
        children: [
          Expanded(child: _commonStat(height, width, LucideIcons.notepadText400Dir, "Tests", tests.toString())),
          
          Expanded(child: _commonStat(height, width, LucideIcons.swords400Dir, "Contests", contests.toString()))
        ],
      )
    ],
  );
}
Widget _commonStat(double height,double width,IconData icon,String title,String stat){
  return Padding(
    padding:  EdgeInsets.symmetric(horizontal: width*0.05),
    child: Container(
      height: height*0.08,width: width*0.25,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color.fromRGBO(220, 220, 220, 0.8)),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          const SizedBox(width: 5,),
          Icon(icon,color: const Color.fromRGBO(40, 40, 40, 1),size: 30,),
          SizedBox(width: 15,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Text(title,style: TextStyle(fontFamily: Fonts.outfit,fontSize: 13,color: Colors.black,fontWeight: FontWeight.w400),),
               const SizedBox(height: 5,),
               Text(stat,style: TextStyle(fontFamily: Fonts.outfit,fontSize: 18,color: Colors.green,fontWeight: FontWeight.w600),)
              ],
            ),
          ),
         
         
        ],
      ),
    ),
  );
}