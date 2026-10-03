import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Contest/Data/ContestRepo.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContest/MyContestBloc.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContest/MyContestEvents.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContest/MyContestStates.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestResult/MyContestResultBloc.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestResult/MyContestResultEvents.dart';
import 'package:study_mate/Contest/Presentation/Pages/ContestResultPage.dart';
import 'package:study_mate/Contest/Presentation/Widgets/MyContestCard.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
import 'package:study_mate/fonts.dart';

class MyContestsPage extends StatefulWidget {
  const MyContestsPage({super.key});

  @override
  State<MyContestsPage> createState() => _MyContestsPageState();
}

class _MyContestsPageState extends State<MyContestsPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MyContestBloc>(context).add(LoadMyContestsEvent());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: height*0.008,),
            _appBar(height, width, context),
            Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,width: width,),
            Expanded(
              child: BlocBuilder<MyContestBloc, MyContestStates>(
                builder: (context, state) {
                  if (state is MyContestLoading || state is MyContestInitial) {
                    return Center(child: LoadingLogo());
                  }

                  if (state is MyContestError) {
                    return Center(child: Text(state.message, style: TextStyle(color: Colors.red, fontFamily: Fonts.nunito)));
                  }

                  if (state is MyContestLoaded) {
                    var list = state.myContests;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _headerSection(height, width, list, context),
                          SizedBox(height: height*0.025,),
                          Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,margin: EdgeInsets.symmetric(horizontal: width*0.05),),
                          SizedBox(height: height*0.025,),
                          _listHeader(height, width, list.length, context),
                          SizedBox(height: height*0.005,),
                          if (list.isEmpty)
                            _emptyState(height, width, context)
                          else
                            ...list.map((contest) {
                              return MyContestCard(
                                contest: contest,
                                onViewResult: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider(
                                    create: (context) => MyContestResultBloc(sl<ContestRepo>())..add(LoadContestResultEvent(contestId: contest.contestId)),
                                    child: ContestResultPage(contest: contest),
                                  )));
                                },
                              );
                            }),
                          SizedBox(height: height*0.08,),
                        ],
                      ),
                    );
                  }

                  return Container();
                },
              ),
            ),
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
        Expanded(child: Text("My Contests",style: TextStyle(color: Colors.black,fontFamily: Fonts.rubik,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 20)),)),
      ],
    ),
  );
}

Widget _headerSection(double height,double width,List<MyContest> contests,BuildContext context){
  int ratingChange = 0; int bestRank = 0;
  for(MyContest c in contests){
    ratingChange += c.ratingChnage;
    if(c.rank > 0 && (bestRank == 0 || c.rank < bestRank)){bestRank = c.rank;}
  }
  return Padding(
    padding: EdgeInsets.only(top: height*0.02,left: width*0.05,right: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Your",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.black),),
            Text(" Contest",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.green),),
            Text(" History",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.black),),
            Text(".",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.green),),
          ],
        ),
        Text("Results and reviews of every contest you gave",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 10),color: const Color.fromRGBO(110, 110, 110, 1)),),
        SizedBox(height: height*0.02,),
        Row(
          children: [
            Expanded(child: _headerStat(width, contests.length.toString(), "Attempts", Colors.black, context)),
            Expanded(child: _headerStat(width, "${ratingChange >= 0 ? '+' : ''}$ratingChange", "Rating", ratingChange >= 0 ? Colors.green : Colors.red, context)),
            Expanded(child: _headerStat(width, bestRank == 0 ? "-" : "#$bestRank", "Best Rank", Colors.black, context)),
          ],
        ),
      ],
    ),
  );
}

Widget _headerStat(double width,String stat,String name,Color color,BuildContext context){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(stat,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 28),fontWeight: FontWeight.w600,color: color,height: 1.1),),
      Text(name,style: TextStyle(fontFamily: Fonts.rubik,fontSize: Responsive.font(context, 12),color: const Color.fromRGBO(120, 120, 120, 1)),),
    ],
  );
}

Widget _listHeader(double height,double width,int count,BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Row(
      children: [
        Icon(LucideIcons.history400Dir,size: Responsive.icon(context, 20),),
        const SizedBox(width: 8),
        Text("Past ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.green),),
        Expanded(child: Text("Attempts",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.black),)),
        Text("$count shown",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),color: Colors.blueGrey),),
      ],
    ),
  );
}

Widget _emptyState(double height,double width,BuildContext context){
  return SizedBox(
    height: height*0.3,width: width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(LucideIcons.swords200Dir,size: Responsive.icon(context, 40),color: const Color.fromRGBO(120, 120, 120, 1),),
        SizedBox(height: height*0.01,),
        Text("No contests yet",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 16)),),
        Text("Contests you take part in will show up here",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 11),color: const Color.fromRGBO(110, 110, 110, 1)),),
      ],
    ),
  );
}
