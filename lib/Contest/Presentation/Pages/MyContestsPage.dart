import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:study_mate/Contest/Data/ContestRepo.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContest/MyContestBloc.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContest/MyContestEvents.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContest/MyContestStates.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestResult/MyContestResultBloc.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContestResult/MyContestResultEvents.dart';
import 'package:study_mate/Contest/Presentation/Pages/ContestResultPage.dart';
import 'package:study_mate/Contest/Presentation/Widgets/MyContestCard.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';
import 'package:study_mate/fonts.dart';

class MyContestsPage extends StatefulWidget {
  const MyContestsPage({Key? key}) : super(key: key);

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
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Bootstrap.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("My Contests", style: TextStyle(color: Colors.black, fontFamily: Fonts.inter, fontSize: 18, fontWeight: FontWeight.bold)),
        
      ),
      body: Column(
        children: [
         
          Container(height: 1, width: width, color: Colors.grey.withOpacity(0.2)),

          Expanded(
            child: BlocBuilder<MyContestBloc, MyContestStates>(
              builder: (context, state) {
                if (state is MyContestLoading || state is MyContestInitial) {
                  return Center(child: LoadingAnimationWidget.beat(color: Colors.green, size: 50));
                }
                
                if (state is MyContestError) {
                  return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
                }
                
                if (state is MyContestLoaded) {
                 
                  var list = state.myContests;
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 15),
                        child: Text(
                          "SHOWING ${list.length} ATTEMPTS",
                          style: TextStyle(color: Colors.grey[600], fontSize: 10, fontWeight: FontWeight.bold, fontFamily: Fonts.inter),
                        ),
                      ),
                      Expanded(
                        child: list.isEmpty ? 
                        Center(child: Text("No contests found.", style: TextStyle(fontFamily: Fonts.nunito, color: Colors.grey))) :
                        ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return MyContestCard(
                              
                              contest: list[index],
                              onViewResult: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (context) => MyContestResultBloc(sl<ContestRepo>())..add(LoadContestResultEvent(contestId: list[index].contestId)),
                                      child: ContestResultPage(contest: list[index]),
                                    )
                                  )
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }


}
