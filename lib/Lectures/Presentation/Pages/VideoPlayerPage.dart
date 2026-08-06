import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerBloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerEvents.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerStates.dart';
import 'package:study_mate/Lectures/Presentation/Widgets/PlayerControls.dart';
import 'package:study_mate/Lectures/Presentation/Widgets/DoubleTapOverlay.dart';
import 'package:study_mate/Lectures/Presentation/Widgets/BufferingWidget.dart';

class VideoPlayerPage extends StatefulWidget {
  final String streamUrl;

  const VideoPlayerPage({
    super.key,
    required this.streamUrl,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  @override
  void initState() {
    super.initState();
    // Default to landscape for fullscreen player
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();

    return WillPopScope(
      onWillPop: () async {
        if (bloc.state.fullscreen) {
          bloc.add(ExitFullscreen());
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<PlayerBloc, PlayerBlocState>(
          builder: (context, state) {
            return Stack(
              fit: StackFit.expand,
              children: [
                /// Video
                Center(
                  child: Video(
                    controller: bloc.mediaKit.controller,
                    controls: NoVideoControls, // We use custom controls
                  ),
                ),

                /// Double Tap Seeking Overlay & Background dimming & onTap toggling
                const Positioned.fill(
                  child: DoubleTapOverlay(),
                ),

                /// Buffering Indicator
                const Positioned.fill(
                  child: BufferingWidget(),
                ),

                /// Custom Controls
                const Positioned.fill(
                  child: PlayerControls(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}