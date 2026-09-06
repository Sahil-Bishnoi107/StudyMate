import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';


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
  final TextEditingController searchController = TextEditingController();

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
            return Column(
            
              children: [
                SizedBox(height: height*0.05,),
                _appBar(height, width, context),
                Container(height: 1,width: width,color: const Color.fromRGBO(220, 220, 220, 0.8),),
                Expanded(child: SingleChildScrollView(
                  child: Column(
                    children: [

                      SizedBox(height: height*0.01,),
                     // _searchBar(height, width, searchController, context),
               
                      _statSection(height, width, context, state.rating.rating, state.rating.contestsGiven),
                
                      _activeContestsHeader(height, width, context),

                      _filters(height, width, state.selectedFilter, context),
                       SizedBox(height: 10),

                 
                  if (state.filteredList.isEmpty)
                    SizedBox(
                      height: height * 0.3,
                      child: Center(
                        child: Text("No contests found.", style: TextStyle(fontFamily: Fonts.nunito, color: Colors.grey)),
                      ),
                    )
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
                  
                  SizedBox(height: 100),
                  ],),
                )),
                
                ],
              );
          }
          return Center(child: Text("Failed to load data.", style: TextStyle(color: Colors.red)));
        },
      ),
    );
  }




}


Widget _searchBar(double height,double width, TextEditingController searchController, BuildContext context){
  return  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.01),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.75),width: 1.25),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (val) {
                          BlocProvider.of<ContestPageBloc>(context).add(SearchContestEvent(query: val));
                        },
                        decoration: InputDecoration(
                          hintText: "Search contests...",
                          hintStyle: TextStyle(color: Colors.grey, fontFamily: Fonts.nunito),
                          prefixIcon: Icon(Bootstrap.search, color: Colors.black, size: Responsive.icon(context, 18)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  );
}


Widget _appBar(double height,double width,BuildContext context){
  return SizedBox(
        height: height*0.05,
        width: width, 
        child: Row(
          children: [
            SizedBox(width: 5,),
            IconButton(icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.black), onPressed: () => Navigator.pop(context)),
            Text("Contests", style: TextStyle(color: Colors.black, fontFamily: Fonts.outfit, fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18))),
          ],
        ),
        
      );
}


Widget _statSection(double height, double width,BuildContext context,int rating,int contestsGiven){
  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard(width * 0.42, "MY CONTESTS", contestsGiven.toString(), "3 ongoing", Bootstrap.clock_history, context,
                         onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider<MyContestBloc>(create: (context) => MyContestBloc(sl<ContestRepo>()), child: MyContestsPage()))); }),

                        _buildStatCard(width * 0.42, "MY RATING", rating.toString(), "Global Top 5%", Bootstrap.trophy,context, isRating: true),
                      ],
                    ),
                  );
}




    Widget _buildStatCard(double width, String title, String value, String subtitle, IconData icon,BuildContext context, {bool isRating = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(width*0.01),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromRGBO(158, 158, 158, 0.2))
        ),
        child: Material(
          elevation : 0.5,
          color : Colors.white,
        
          child: Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            //borderRadius: BorderRadius.circular(15),
           // border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.7),width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(76, 175, 80, 0.05),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Icon(icon, color: Colors.green, size: Responsive.icon(context, 20))),
          
                  if (isRating)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Bootstrap.graph_up_arrow, size: Responsive.icon(context, 10), color: Colors.green),
                          SizedBox(width: 3),
                          Text("+12", style: TextStyle(color: Colors.green, fontSize: Responsive.font(context, 10), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                ],
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(fontSize: Responsive.font(context, 22), fontWeight: FontWeight.bold, fontFamily: Fonts.inter),
              ),
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(fontSize: Responsive.font(context, 10), color: Colors.grey[600], fontWeight: FontWeight.bold, fontFamily: Fonts.nunito),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  ),
                  SizedBox(width: 5),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: Responsive.font(context, 10), color: Colors.grey[500], fontFamily: Fonts.nunito),
                  )
                ],
              )
            ],
          ),
          ),
        ),
      ),
    );
  }


  Widget _activeContestsHeader(double height,double width,BuildContext context){
    return    Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Active Contests",
                          style: TextStyle(fontFamily: Fonts.outfit, fontWeight: FontWeight.w600, fontSize: Responsive.font(context, 18)),
                        ),
                       
                        IconButton(icon: Icon(Icons.refresh, color: Colors.black), onPressed: () => BlocProvider.of<ContestPageBloc>(context).add(RefreshContestDataEvent())),
                      ],
                    ),
                  );
  }


  Widget _filters(double height,double width,int selectedFilter,BuildContext context)
  {
    return  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(220, 220, 220, 0.05),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.6),width: 1.5)
                      ),
                      child: Row(
                        children: [
                          _buildFilterButton("Current", 0, selectedFilter, width,context),
                          _buildFilterButton("Upcoming", 1, selectedFilter, width,context),
                          _buildFilterButton("Ended", 2, selectedFilter, width,context),
                        ],
                      ),
                    ),
                  );
  }


    Widget _buildFilterButton(String text, int index, int selectedIndex, double screenWidth,BuildContext context) {
    bool isSelected = index == selectedIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<ContestPageBloc>(context).add(ChnageFilter(newFilter: index));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontFamily: Fonts.nunito,
                fontSize: Responsive.font(context, 14),
              ),
            ),
          ),
        ),
      ),
    );
  }