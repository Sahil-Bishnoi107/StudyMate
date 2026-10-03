import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:study_mate/Contest/Presentation/Bloc/ContestPage/ContestPageBloc.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestPage/ContestPageEvents.dart';

import 'package:study_mate/Contest/Presentation/Bloc/ContestPage/ContestPageStates.dart';
import 'package:study_mate/Contest/Presentation/Pages/ContestOnboardingPage.dart';
import 'package:study_mate/Contest/Presentation/Widgets/ContestCard.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContest/MyContestBloc.dart';
import 'package:study_mate/Contest/Presentation/Pages/MyContestsPage.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';
import 'package:study_mate/Contest/Data/ContestRepo.dart';
import 'package:study_mate/Contest/Domain/Contest.dart';
import 'package:study_mate/Contest/Domain/Rating.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
import 'package:study_mate/fonts.dart';

class ContestPage extends StatefulWidget {
  const ContestPage({super.key});

  @override
  State<ContestPage> createState() => _ContestPageState();
}

class _ContestPageState extends State<ContestPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ContestPageBloc>(context).add(LoadContestPageData());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ContestPageBloc, ContestPagestates>(
        builder: (context, state) {
          if (state is LoadingContestListState) {
            return Center(child: LoadingLogo());
          } else if (state is SuccessContestPageState) {
            return SafeArea(
              child: Column(
                children: [
                  SizedBox(height: height*0.004,),
                  _appBar(height, width, context),
                  Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,width: width,),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ratingSection(height, width, context, state.rating, state.contests, state.time),
                          SizedBox(height: height*0.012,),
                          _myContestsTile(height, width, context),
                          SizedBox(height: height*0.025,),
                          
                          _contestsHeader(height, width, context),
                          SizedBox(height: height*0.015,),
                          _filters(height, width, state.selectedFilter, context),
                          SizedBox(height: height*0.02,),
                          if (state.filteredList.isEmpty)
                            _emptyState(height, width, context)
                          else
                            ...state.filteredList.map((contest) {
                              return ContestCard(
                                contest: contest,
                                currentTime: state.time,
                                onJoin: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => ContestOnboardingPage(contest: contest)));
                                },
                              );
                            }),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text("Failed to load data.", style: TextStyle(color: Colors.red, fontFamily: Fonts.nunito)));
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
          onTap: () => Navigator.pop(context),
          child: Icon(LucideIcons.chevronLeft400Dir,size: Responsive.icon(context, 25),)),
        SizedBox(width: width*0.05,),
        Expanded(child: Text("Contests",style: TextStyle(color: Colors.black,fontFamily: Fonts.rubik,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 20)),)),
        InkWell(
          onTap: () => BlocProvider.of<ContestPageBloc>(context).add(RefreshContestDataEvent()),
          child: Icon(LucideIcons.refreshCw400Dir,size: Responsive.icon(context, 22),))
      ],
    ),
  );
}

Widget _ratingSection(double height,double width,BuildContext context,Rating rating,List<Contest> contests,DateTime time){
  int live = 0; int upcoming = 0;
  for(Contest c in contests){
    if(c.startTime.isAfter(time)){upcoming++;}
    else if(time.isBefore(c.startTime.add(Duration(minutes: c.duration)))){live++;}
  }
  return Container(
    width: width,
    margin: EdgeInsets.only(top: height*0.015,left: width*0.05,right: width*0.05),
    decoration: BoxDecoration(
      color: Colors.white,
     // border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),
      borderRadius: BorderRadius.circular(Responsive.icon(context, 3))
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width*0.04,vertical: height*0.018),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("CONTEST RATING",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10),fontWeight: FontWeight.bold,color: Colors.blueGrey,letterSpacing: 1),),
                    Text(rating.rating.toString(),style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 36),fontWeight: FontWeight.w600,color: Colors.black),),
                    Text("Your rating moves after every rated contest",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 10),color: const Color.fromRGBO(110, 110, 110, 1)),),
                  ],
                ),
              ),
              Container(height: height*0.07,width: height*0.07,
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(Responsive.icon(context, 3))),
              padding: EdgeInsets.all(height*0.008),
              child: Image.asset("assets/images/trophy (1).png"),
              ),
            ],
          ),
        ),
        Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,),
        SizedBox(
          height: height*0.075,
          child: Row(
            children: [
              Expanded(child: _ratingStat(width, LucideIcons.circleCheck400Dir, Colors.green, rating.contestsGiven.toString(), "Given", context)),
              Container(color: const Color.fromRGBO(220, 220, 220, 0.8),width: 1,),
              Expanded(child: _ratingStat(width, LucideIcons.timer400Dir, Colors.orange, live.toString(), "Live Now", context)),
              Container(color: const Color.fromRGBO(220, 220, 220, 0.8),width: 1,),
              Expanded(child: _ratingStat(width, LucideIcons.calendar400Dir, Colors.blue, upcoming.toString(), "Upcoming", context)),
            ],
          ),
        )
      ],
    ),
  );
}

Widget _ratingStat(double width,IconData icon,Color color,String stat,String name,BuildContext context){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon,size: Responsive.icon(context, 18),color: color,),
      SizedBox(width: width*0.02,),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(stat,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 16),fontWeight: FontWeight.w600,color: Colors.black),),
          Text(name,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10),color: Colors.blueGrey),),
        ],
      )
    ],
  );
}

Widget _myContestsTile(double height,double width,BuildContext context){
  return InkWell(
    onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider<MyContestBloc>(create: (context) => MyContestBloc(sl<ContestRepo>()), child: MyContestsPage()))); },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: width*0.05),
      padding: EdgeInsets.symmetric(horizontal: width*0.04,vertical: height*0.012),
      decoration: BoxDecoration(
        color: Colors.white,
       // border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),
        borderRadius: BorderRadius.circular(Responsive.icon(context, 3))
      ),
      child: Row(
        children: [
          Container(height: height*0.045,width: height*0.045,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Responsive.icon(context, 3)),color: const Color.fromRGBO(30, 30, 30, 1)),
          child: Icon(LucideIcons.history400Dir,color: Colors.white,size: Responsive.icon(context, 20),)
          ),
          SizedBox(width: width*0.03,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("My Contests",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 14),fontWeight: FontWeight.w600,color: Colors.black),),
                Text("Results and reviews of the contests you gave",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 10),color: const Color.fromRGBO(110, 110, 110, 1)),)
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight400Dir,size: Responsive.icon(context, 18),color: const Color.fromRGBO(120, 120, 120, 1),),
        ],
      ),
    ),
  );
}

Widget _contestsHeader(double height,double width,BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Row(
      children: [
        Icon(LucideIcons.swords400Dir,size: Responsive.icon(context, 20),),
        const SizedBox(width: 8),
        Text("Active ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.green),),
        Text("Contests",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.black),),
      ],
    ),
  );
}

Widget _filters(double height,double width,int selectedFilter,BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Row(
      children: [
        _buildFilterButton("Current", 0, selectedFilter, height, context),
        SizedBox(width: width*0.02,),
        _buildFilterButton("Upcoming", 1, selectedFilter, height, context),
        SizedBox(width: width*0.02,),
        _buildFilterButton("Ended", 2, selectedFilter, height, context),
      ],
    ),
  );
}

Widget _buildFilterButton(String text,int index,int selectedIndex,double height,BuildContext context){
  bool isSelected = index == selectedIndex;
  return Expanded(
    child: GestureDetector(
      onTap: () {
        BlocProvider.of<ContestPageBloc>(context).add(ChnageFilter(newFilter: index));
      },
      child: Container(
        height: height*0.045,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.icon(context, 3)),
          border: Border.all(color: isSelected ? Colors.green : const Color.fromRGBO(220, 220, 220, 0.7),width: 1),
        ),
        child: Center(
          child: Text(text,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,color: isSelected ? Colors.white : Colors.black,fontSize: Responsive.font(context, 13)),),
        ),
      ),
    ),
  );
}

Widget _emptyState(double height,double width,BuildContext context){
  return SizedBox(
    height: height*0.25,width: width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(LucideIcons.swords200Dir,size: Responsive.icon(context, 40),color: const Color.fromRGBO(120, 120, 120, 1),),
        SizedBox(height: height*0.01,),
        Text("No contests found",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 16)),),
        Text("Try another tab or refresh the list",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 11),color: const Color.fromRGBO(110, 110, 110, 1)),),
      ],
    ),
  );
}
