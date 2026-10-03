import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Contest/Data/ContestRepo.dart';
import 'package:study_mate/Contest/Domain/Contest.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestQuestions/ContestQuestionBloc.dart';
import 'package:study_mate/Contest/Presentation/Pages/ContestQuestionPage.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';
import 'package:study_mate/Test/Presentation/Widgets/stat_boc.dart';
import 'package:study_mate/fonts.dart';

class ContestOnboardingPage extends StatelessWidget {
  final Contest contest;

  const ContestOnboardingPage({super.key, required this.contest});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isUpcoming = DateTime.now().isBefore(contest.startTime);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: height*0.008,),
            _appBar(height, width, context),
            Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,width: width,),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerSection(height, width, contest, context),
                    SizedBox(height: height*0.015,),
                    _statsSection(height, width, contest, context),
                    _divider(height, width),
                    _aboutContest(height, width, context),
                    _divider(height, width),
                    _instructions(height, width, context),
                    _divider(height, width),
                    _scoringSystem(height, width, contest, context),
                    SizedBox(height: height*0.012,),
                    _ratingSystem(height, width, context),
                    SizedBox(height: height*0.04,),
                  ],
                ),
              ),
            ),
            Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,width: width,),
            SizedBox(height: height*0.015,),
            _startButton(height, width, context, contest, isUpcoming),
            SizedBox(height: height*0.015,),
          ],
        ),
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
          onTap: () => Navigator.pop(context),
          child: Icon(LucideIcons.chevronLeft400Dir,size: Responsive.icon(context, 25),)),
        SizedBox(width: width*0.05,),
        Expanded(child: Text("Contest Details",style: TextStyle(color: Colors.black,fontFamily: Fonts.rubik,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 20)),)),
      ],
    ),
  );
}

Widget _divider(double height,double width){
  return Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,margin: EdgeInsets.symmetric(horizontal: width*0.05,vertical: height*0.03),);
}

Widget _headerSection(double height,double width,Contest contest,BuildContext context){
  Map<String,Color> difficultyIndex = {
    "hard" : Colors.red,
    "medium" : Colors.orange,
    "easy" : Colors.green
  };
  Color color = difficultyIndex[contest.difficulty.toLowerCase()] ?? Colors.blue;

  return Padding(
    padding: EdgeInsets.only(top: height*0.03,left: width*0.05,right: width*0.05),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contest.subject.toUpperCase(),style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10),fontWeight: FontWeight.bold,color: Colors.blueGrey,letterSpacing: 1),),
              Text(contest.contestName,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.black,height: 1.15),),
              SizedBox(height: height*0.008,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.02,vertical: height*0.004),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1),borderRadius: BorderRadius.circular(Responsive.icon(context, 3))),
                child: Text(contest.difficulty.toUpperCase(),style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 9),fontWeight: FontWeight.bold,color: color,letterSpacing: 0.5),),
              ),
            ],
          ),
        ),
        SizedBox(width: width*0.03,),
        Container(height: height*0.07,width: height*0.07,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Responsive.icon(context, 10)),color: const Color.fromRGBO(30, 30, 30, 1)),
        child: Icon(LucideIcons.zap,color: Colors.white,size: Responsive.icon(context, 30),)
        ),
      ],
    ),
  );
}

Widget _statsSection(double height,double width,Contest contest,BuildContext context){
  String participants = contest.participants > 1000 ? "${(contest.participants / 1000).toStringAsFixed(1)}k" : contest.participants.toString();

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      children: [
        StatBox(height, width, LucideIcons.calendar400Dir, Colors.green, "Starts", DateFormat("d MMM, h:mm a").format(contest.startTime.toLocal()), "Date and time the contest opens",context),
        Container(color: const Color.fromRGBO(220, 220, 220, 0.5),height: 1,),
        StatBox(height, width, LucideIcons.timer400Dir, Colors.orange, "Duration", "${contest.duration} mins", "The timer cannot be paused",context),
        Container(color: const Color.fromRGBO(220, 220, 220, 0.5),height: 1,),
        StatBox(height, width, LucideIcons.users400Dir, Colors.blue, "Joined", participants, "Participants in this contest",context),
      ],
    ),
  );
}

Widget _aboutContest(double height,double width,BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.info400Dir,size: Responsive.icon(context, 20),),
            const SizedBox(width: 8),
            Text("About ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.green),),
            Text("Contest",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.black),),
          ],
        ),
        SizedBox(height: height*0.01,),
        Text("This mock cup is designed to simulate the rigorous environment of the actual exam. Questions focus on application-based concepts. Ensure a stable environment before starting.",
        style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 12),color: const Color.fromRGBO(110, 110, 110, 1),height: 1.5),
        ),
      ],
    ),
  );
}

Widget _instructions(double height,double width,BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.notepadText400Dir,size: Responsive.icon(context, 20),),
            const SizedBox(width: 8),
            Text("Before ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.green),),
            Text("You Start",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.black),),
          ],
        ),
        SizedBox(height: height*0.015,),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),
            borderRadius: BorderRadius.circular(Responsive.icon(context, 3))
          ),
          child: Column(
            children: [
              _instructionRow(height, width, LucideIcons.timer400Dir, Colors.orange, "Timer cannot be paused", context),
              Container(color: const Color.fromRGBO(220, 220, 220, 0.5),height: 1,),
              _instructionRow(height, width, LucideIcons.wifi400Dir, Colors.blue, "Internet connection required", context),
              Container(color: const Color.fromRGBO(220, 220, 220, 0.5),height: 1,),
              _instructionRow(height, width, LucideIcons.target400Dir, Colors.red, "Negative marking active", context),
              Container(color: const Color.fromRGBO(220, 220, 220, 0.5),height: 1,),
              _instructionRow(height, width, LucideIcons.logOut400Dir, Colors.orange, "Don't leave the screen", context),
              Container(color: const Color.fromRGBO(220, 220, 220, 0.5),height: 1,),
              _instructionRow(height, width, LucideIcons.circleCheck400Dir, Colors.green, "Detailed results shown immediately after submission", context),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _instructionRow(double height,double width,IconData icon,Color color,String text,BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.04,vertical: height*0.014),
    child: Row(
      children: [
        Icon(icon,color: color,size: Responsive.icon(context, 18),),
        SizedBox(width: width*0.035,),
        Expanded(child: Text(text,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 13),color: Colors.black),)),
      ],
    ),
  );
}

Widget _scoringSystem(double height,double width,Contest contest,BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.trendingUp400Dir,size: Responsive.icon(context, 20),),
            const SizedBox(width: 8),
            Text("Scoring ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.green),),
            Text("System",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.black),),
          ],
        ),
        SizedBox(height: height*0.02,),
        Row(
          children: [
            Expanded(child: _scoreBox(height, width, "+${contest.marksPerQuestion}", "Correct", Colors.green, context)),
            Container(color: const Color.fromRGBO(220, 220, 220, 0.8),width: 1,height: height*0.05,),
            Expanded(child: _scoreBox(height, width, "-${contest.negativeMarking.abs()}", "Wrong", Colors.red, context)),
            Container(color: const Color.fromRGBO(220, 220, 220, 0.8),width: 1,height: height*0.05,),
            Expanded(child: _scoreBox(height, width, "0", "Skipped", Colors.blueGrey, context)),
          ],
        ),
      ],
    ),
  );
}

Widget _scoreBox(double height,double width,String score,String label,Color color,BuildContext context){
  return Column(
    children: [
      Text(score,style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 26),color: color,height: 1.1),),
      Text(label,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),color: Colors.blueGrey),),
    ],
  );
}

Widget _ratingSystem(double height,double width,BuildContext context){
  return Container(
    margin: EdgeInsets.only(top: height*0.02,left: width*0.05,right: width*0.05),
    padding: EdgeInsets.symmetric(horizontal: width*0.04,vertical: height*0.014),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),
      borderRadius: BorderRadius.circular(Responsive.icon(context, 3))
    ),
    child: Row(
      children: [
        SizedBox(height: height*0.05,width: height*0.05,
        child: Image.asset("assets/images/trophy (1).png"),
        ),
        SizedBox(width: width*0.035,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Rating System",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 14),fontWeight: FontWeight.w600,color: Colors.black),),
              Text("Your platform rating will be adjusted based on your performance relative to other participants.",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 10),color: const Color.fromRGBO(110, 110, 110, 1)),)
            ],
          ),
        )
      ],
    ),
  );
}

Widget _startButton(double height,double width,BuildContext context,Contest contest,bool isUpcoming){
  if(isUpcoming){
    return Container(
      height: height*0.05,
      margin: EdgeInsets.symmetric(horizontal: width*0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.icon(context, 3)),
        border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8))
      ),
      child: Center(child: Text("This contest has not started yet",style: TextStyle(color: Colors.blueGrey,fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 14)),)),
    );
  }
  return GestureDetector(
    onTap: () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BlocProvider(
        create: (context) => ContestQuestionBloc(sl<ContestRepo>(), contest),
        child: ContestQuestionPage(),
      )));
    },
    child: Container(
      height: height*0.05,
      margin: EdgeInsets.symmetric(horizontal: width*0.05),
      decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(Responsive.icon(context, 3))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.swords400Dir,color: Colors.white,size: Responsive.icon(context, 18),),
          SizedBox(width: width*0.02,),
          Text("Start Contest",style: TextStyle(color: Colors.white,fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 14)),),
        ],
      ),
    ),
  );
}
