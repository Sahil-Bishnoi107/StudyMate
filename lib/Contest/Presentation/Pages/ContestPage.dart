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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load data initially
    BlocProvider.of<ContestPageBloc>(context).add(LoadContestPageData());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Bootstrap.lightning_fill, color: Colors.white, size: 16),
            ),
            SizedBox(width: 10),
            Text("Contests", style: TextStyle(color: Colors.black, fontFamily: Fonts.inter, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Bootstrap.three_dots_vertical, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: BlocBuilder<ContestPageBloc, ContestPagestates>(
        builder: (context, state) {
          if (state is LoadingContestListState) {
            return Center(child: LoadingAnimationWidget.beat(color: Colors.green, size: 50));
          } else if (state is SuccessContestPageState) {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<ContestPageBloc>(context).add(RefreshContestDataEvent());
              },
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Search Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          BlocProvider.of<ContestPageBloc>(context).add(SearchContestEvent(query: val));
                        },
                        decoration: InputDecoration(
                          hintText: "Search contests...",
                          hintStyle: TextStyle(color: Colors.grey, fontFamily: Fonts.nunito),
                          prefixIcon: Icon(Bootstrap.search, color: Colors.grey, size: 18),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ),

                  // Stats Cards
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard(
                          width * 0.42,
                          "MY CONTESTS",
                          "12",
                          "3 ongoing", // We'd realistically compute this from list
                          Bootstrap.clock_history,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => BlocProvider<MyContestBloc>(
                                create: (context) => MyContestBloc(sl<ContestRepo>()),
                                child: MyContestsPage(),
                              )
                            ));
                          }
                        ),
                        _buildStatCard(
                          width * 0.42,
                          "MY RATING",
                          state.rating.rating.toString(), // Use actual rating
                          "Global Top 5%",
                          Bootstrap.trophy,
                          isRating: true,
                        ),
                      ],
                    ),
                  ),

                  // Active Contests Section Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Active Contests",
                          style: TextStyle(fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        )
                      ],
                    ),
                  ),

                  // Filters
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          _buildFilterButton("Current", 0, state.selectedFilter, width),
                          _buildFilterButton("Upcoming", 1, state.selectedFilter, width),
                          _buildFilterButton("Ended", 2, state.selectedFilter, width),
                        ],
                      ),
                    ),
                  ),
                  
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
                  
                  SizedBox(height: 30),
                ],
              ),
            );
          }
          return Center(child: Text("Failed to load data.", style: TextStyle(color: Colors.red)));
        },
      ),
    );
  }

  Widget _buildStatCard(double width, String title, String value, String subtitle, IconData icon, {bool isRating = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: width,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.green, size: 20),
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
          SizedBox(height: 15),
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

  Widget _buildFilterButton(String text, int index, int selectedIndex, double screenWidth) {
    bool isSelected = index == selectedIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<ContestPageBloc>(context).add(ChnageFilter(newFilter: index));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
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
}
