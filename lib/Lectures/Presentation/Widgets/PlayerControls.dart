import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerBloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerEvents.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerStates.dart';
import 'package:study_mate/Lectures/Presentation/Widgets/ProgressBar.dart';
import 'package:study_mate/Lectures/Presentation/Widgets/TimeIndicator.dart';
import 'package:study_mate/Lectures/Presentation/Widgets/SpeedBottomSheet.dart';
import 'package:study_mate/Lectures/Presentation/Widgets/QualityBottomSheet.dart';


class PlayerControls extends StatefulWidget {
  const PlayerControls({super.key});

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  @override
  void didUpdateWidget(covariant PlayerControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isVisible = context.read<PlayerBloc>().state.controlsVisible;
    if (isVisible) {
      _startHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.read<PlayerBloc>().add(HideControls());
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _showSpeedSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<PlayerBloc>(),
        child: const SpeedBottomSheet(),
      ),
    ).then((_) => _startHideTimer());
  }

  void _showQualitySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<PlayerBloc>(),
        child: const QualityBottomSheet(),
      ),
    ).then((_) => _startHideTimer());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerBlocState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity: state.controlsVisible ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: IgnorePointer(
            ignoring: !state.controlsVisible,
            child: SafeArea(
              child: Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:  Icon(
                            LucideIcons.chevronLeft,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            _hideTimer?.cancel();
                            _showQualitySheet(context);
                          },
                          icon: const Icon(
                            Icons.high_quality,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _hideTimer?.cancel();
                            _showSpeedSheet(context);
                          },
                          icon: const Icon(
                            Icons.speed,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Center Controls
                  StreamBuilder<bool>(
                    stream: context.read<PlayerBloc>().mediaKit.player.stream.completed,
                    builder: (context, completedSnapshot) {
                      final isCompleted = completedSnapshot.data ?? false;
                      
                      if (isCompleted) {
                        return IconButton(
                          iconSize: 60,
                          color: Colors.white,
                          onPressed: () {
                            context.read<PlayerBloc>().add(SeekTo(Duration.zero));
                            context.read<PlayerBloc>().add(PlayPressed());
                            _startHideTimer();
                          },
                          icon: const Icon(Icons.replay),
                        );
                      }

                      return StreamBuilder<bool>(
                        stream: context.read<PlayerBloc>().mediaKit.player.stream.playing,
                        builder: (context, playingSnapshot) {
                          final playing = playingSnapshot.data ?? false;

                          return IconButton(
                            iconSize: 60,
                            color: Colors.white,
                            onPressed: () {
                              if (playing) {
                                context.read<PlayerBloc>().add(PausePressed());
                              } else {
                                context.read<PlayerBloc>().add(PlayPressed());
                              }
                              _startHideTimer();
                            },
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                              child: Icon(
                                playing ? Icons.pause_circle : Icons.play_circle,
                                key: ValueKey<bool>(playing),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const Spacer(),
                  // Bottom Bar
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                    child: Row(
                      children: [
                        const TimeIndicator(),
                        const SizedBox(width: 16),
                        Expanded(child: const ProgressBar()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
