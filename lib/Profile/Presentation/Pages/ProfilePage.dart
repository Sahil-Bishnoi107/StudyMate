import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Profile/Presentation/Bloc/ProfileBloc.dart';
import 'package:study_mate/Profile/Presentation/Bloc/ProfileEvents.dart';
import 'package:study_mate/Profile/Presentation/Bloc/ProfileStates.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:study_mate/fonts.dart';

import 'package:study_mate/Profile/Presentation/Widgets/ProfileTopSection.dart';
import 'package:study_mate/Profile/Presentation/Widgets/RatingSection.dart';
import 'package:study_mate/Profile/Presentation/Widgets/RatingGraph.dart';
import 'package:study_mate/Profile/Presentation/Widgets/ContestHistorySection.dart';
import 'package:study_mate/Profile/Presentation/Widgets/QuestionStatsSection.dart';
import 'package:study_mate/Profile/Presentation/Widgets/PracticeRecordsSection.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // slightly off-white for better contrast with white cards
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "My Profile",
          style: TextStyle(
            color: Colors.black,
            fontFamily: Fonts.outfit,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: BlocBuilder<Profilebloc, Profilestates>(
        builder: (context, state) {
          if (state is InitialProfileState || state is LoadingProfileState) {
            return Center(
              child: LoadingAnimationWidget.beat(color: Colors.green, size: 50),
            );
          } else if (state is LoadedProfileState) {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<Profilebloc>(context).add(LoadProfileEvent());
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  ProfileTopSection(student: state.student),
                  const SizedBox(height: 30),
                  RatingSection(student: state.student, contests: state.contest),
                  const SizedBox(height: 25),
                  RatingGraph(contests: state.contest),
                  const SizedBox(height: 25),
                  QuestionStatsSection(questions: state.questions),
                  const SizedBox(height: 25),
                  ContestHistorySection(contests: state.contest),
                  const SizedBox(height: 25),
                  PracticeRecordsSection(questions: state.questions),
                  const SizedBox(height: 50),
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
