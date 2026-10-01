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
                  SizedBox(height: height*0.008,),
                  _appBar(height, width, context),
                  Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,width: width,),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ratingSection(height, width, context, state.rating.rating),
                          _statSection(height, width, context, state.rating.contestsGiven),
                          SizedBox(height: height*0.03,),
                          _contestsHeader(height, width, context),
                          SizedBox(height: height*0.015,),
                          _filters(height, width, state.selectedFilter, context),
                          SizedBox(height: height*0.015,),
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

// Same open, typographic block as the rating section on the profile page
Widget _ratingSection(double height,double width,BuildContext context,int rating){
  return Container(
    width: width,
    margin: EdgeInsets.only(top: height*0.03,left: width*0.05,right: width*0.05),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Contest",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 24),fontWeight: FontWeight.w600,color: Colors.green),),
                  Text(" Rating",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 24),fontWeight: FontWeight.w600,color: Colors.black),),
                ],
              ),
              Text(rating.toString(),style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 32),fontWeight: FontWeight.w600,color: Colors.black),),
              Text("Your rating moves after every rated contest",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 10),color: const Color.fromRGBO(110, 110, 110, 1)),),
            ],
          ),
        ),
        Icon(LucideIcons.trophy200Dir,color: Colors.green,size: Responsive.icon(context, 64),),
        SizedBox(width: width*0.03,),
      ],
    ),
  );
}

Widget _statSection(double height,double width,BuildContext context,int contestsGiven){
  return Column(
    children: [
      SizedBox(height: height*0.03,),
      _statRow(height, width, context, "Contests Given", "Number of Global Contests attempted by you", contestsGiven.toString(), "Contests"),
      SizedBox(height: height*0.015,),
      InkWell(
        onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider<MyContestBloc>(create: (context) => MyContestBloc(sl<ContestRepo>()), child: MyContestsPage()))); },
        child: _statRow(height, width, context, "My Contests", "Results and reviews of the contests you gave", null, "View"),
      ),
    ],
  );
}

Widget _statRow(double height,double width,BuildContext context,String name,String des,String? stat,String followUp){
  return Row(
    children: [
      SizedBox(width: width*0.06,),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name, style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 14),color: Colors.green,fontWeight: FontWeight.w400)),
            Text(des, style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 9),color: const Color.fromRGBO(120, 120, 120, 1),fontWeight: FontWeight.w400))
          ],
        )),
      if(stat != null) Text(stat,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 18),color: Colors.black,fontWeight: FontWeight.w400),),
      SizedBox(width: width*0.01,),
      Padding(
        padding: EdgeInsetsGeometry.only(top: height*0.003),
        child: Text(followUp,style: TextStyle(fontFamily: Fonts.rubik,fontSize: Responsive.font(context, 12),color: const Color.fromRGBO(120, 120, 120, 1),fontWeight: FontWeight.w400),),
      ),
      if(stat == null) Icon(LucideIcons.chevronRight400Dir,size: Responsive.icon(context, 18),color: const Color.fromRGBO(120, 120, 120, 1),),
      SizedBox(width: width*0.05,),
    ],
  );
}

Widget _contestsHeader(double height,double width,BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Row(
      children: [
        const SizedBox(width: 5,),
        Icon(LucideIcons.swords400Dir,size: Responsive.icon(context, 20),),
        const SizedBox(width: 8),
        Text("Active ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.green),),
        Text("Contests",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.black),),
      ],
    ),
  );
}

// Square buttons, same look as the previous / next buttons on the test page
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
          border: Border.all(color: isSelected ? Colors.green : const Color.fromRGBO(220, 220, 220, 0.7),width: 1.2),
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
