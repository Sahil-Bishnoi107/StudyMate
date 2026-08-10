import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/LecturesPage/LecturesPageBloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/LecturesPage/LecturesPageEvents.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/LecturesPage/LecturesPageStates.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerBloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerEvents.dart';
import 'package:study_mate/Lectures/Presentation/Pages/VideoPlayerPage.dart';
import 'package:study_mate/Lectures/Presentation/Widgets/LectureCard.dart';
import 'package:study_mate/Lectures/Services/MediaKitService.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
import 'package:study_mate/fonts.dart';

class Lecturespage extends StatefulWidget {
  const Lecturespage({super.key});

  @override
  State<Lecturespage> createState() => _LecturespageState();
}

class _LecturespageState extends State<Lecturespage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<LecturesPageBloc>(context).add(LoadLecturesData());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<LecturesPageBloc, LecturesPageStates>(
        builder: (context, state) {
          if (state is LoadingLecturesState) {
            return Center(child: LoadingLogo());
          } else if (state is ErrorLecturesState) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.red, fontFamily: Fonts.nunito),
              ),
            );
          } else if (state is SuccessLecturesState) {
            return Column(
              children: [
                SizedBox(height: height * 0.05),
                _appBar(height, width, context),
                Container(height: 1, width: width, color: const Color.fromRGBO(220, 220, 220, 0.8)),
                Expanded(
                  child: state.videos.isEmpty
                      ? Center(
                          child: Text(
                            "No lectures found.",
                            style: TextStyle(fontFamily: Fonts.nunito, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: 100, top: 10),
                          itemCount: state.videos.length,
                          itemBuilder: (context, index) {
                            final video = state.videos[index];
                            return LectureCard(
                              video: video,
                              onTap: () {
                                if (video.streamUrl != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider<PlayerBloc>(
                                        create: (context) => PlayerBloc(MediaKitService())..add(OpenVideo(video.streamUrl!)),
                                        child: VideoPlayerPage(streamUrl: video.streamUrl!),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Video stream URL is not available.")),
                                  );
                                }
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }
          return Center(
            child: Text(
              "Initializing...",
              style: TextStyle(color: Colors.grey, fontFamily: Fonts.nunito),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(double height, double width, BuildContext context) {
    return SizedBox(
      height: height * 0.05,
      width: width,
      child: Row(
        children: [
          SizedBox(width: 5),
          IconButton(
            icon: Icon(LucideIcons.chevronLeft, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            "Lectures",
            style: TextStyle(
              color: Colors.black,
              fontFamily: Fonts.outfit,
              fontWeight: FontWeight.w600,
              fontSize: Responsive.font(context, 18),
            ),
          ),
        ],
      ),
    );
  }
}