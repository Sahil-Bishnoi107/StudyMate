import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:study_mate/Contest/Presentation/Bloc/ContestPageBloc.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestPageEvents.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestPageStates.dart';
import 'package:study_mate/Contest/Presentation/Pages/ContestOnboardingPage.dart';
import 'package:study_mate/Contest/Presentation/Widgets/ContestCard.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestBloc.dart';
import 'package:study_mate/Contest/Presentation/Pages/MyContestsPage.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';
import 'package:study_mate/Contest/Data/ContestRepo.dart';
import 'package:study_mate/fonts.dart';

class ContestPage extends StatefulWidget {
  const ContestPage({Key? key}) : super(key: key);

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
            return Center(child: LoadingAnimationWidget.beat(color: Colors.green, size: 50));
          } else if (state is SuccessContestPageState) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: height*0.025,),
                _appBar(height, width, context),
                Container(height: 1.5,width: width,color: const Color.fromRGBO(220, 220, 220, 0.7),),
                SizedBox(height: height*0.01,),
                _searchBar(height, width, searchController, context),
               
                _statSection(height, width, context, state.rating.rating, state.rating.contestsGiven),
                
                _activeContestsHeader(height, width, context),

                _filters(height, width, state.selectedFilter, context),
             

                  // Filters
                 
                  
                  SizedBox(height: 10),

                  // Contest List
                  if (state.filteredList.isEmpty)
                    Container(
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
                    }).toList(),
                  
                  SizedBox(height: 100),
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
                          prefixIcon: Icon(Bootstrap.search, color: Colors.black, size: 18),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  );
}


Widget _appBar(double height,double width,BuildContext context){
  return Container(
        height: height*0.06,
        width: width, 
        child: Row(
          children: [
            SizedBox(width: 10,),
            IconButton(icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.black), onPressed: () => Navigator.pop(context)),
            Text("Contests", style: TextStyle(color: Colors.black, fontFamily: Fonts.outfit, fontWeight: FontWeight.w400,fontSize: 22)),
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
                        _buildStatCard(width * 0.42, "MY CONTESTS", contestsGiven.toString(), "3 ongoing", Bootstrap.clock_history, 
                         onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider<MyContestBloc>(create: (context) => MyContestBloc(sl<ContestRepo>()), child: MyContestsPage()))); }),

                        _buildStatCard(width * 0.42, "MY RATING", rating.toString(), "Global Top 5%", Bootstrap.trophy, isRating: true),
                      ],
                    ),
                  );
}




    Widget _buildStatCard(double width, String title, String value, String subtitle, IconData icon, {bool isRating = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.7),width: 1.5),
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
                child: Icon(icon, color: Colors.green, size: 20)),

              if (isRating)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Bootstrap.graph_up_arrow, size: 10, color: Colors.green),
                      SizedBox(width: 3),
                      Text("+12", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: Fonts.inter),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.bold, fontFamily: Fonts.nunito),
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
                style: TextStyle(fontSize: 10, color: Colors.grey[500], fontFamily: Fonts.nunito),
              )
            ],
          )
        ],
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
                          style: TextStyle(fontFamily: Fonts.outfit, fontWeight: FontWeight.w600, fontSize: 18),
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
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }