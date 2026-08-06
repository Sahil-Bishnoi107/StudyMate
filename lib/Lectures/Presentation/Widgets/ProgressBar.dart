import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerBloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerEvents.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();

    return StreamBuilder<Duration>(
      stream: bloc.mediaKit.player.stream.duration,
      builder: (context, durationSnapshot) {
        final duration = durationSnapshot.data ?? Duration.zero;

        return StreamBuilder<Duration>(
          stream: bloc.mediaKit.player.stream.buffer,
          builder: (context, bufferSnapshot) {
            Duration buffer = bufferSnapshot.data ?? Duration.zero;

            return StreamBuilder<Duration>(
              stream: bloc.mediaKit.player.stream.position,
              builder: (context, positionSnapshot) {
                var position = positionSnapshot.data ?? Duration.zero;

                if (position > duration) position = duration;
                if (buffer > duration) buffer = duration;

                return SizedBox(
                  height: 20,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Buffered Progress
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6, elevation: 0, pressedElevation: 0),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                          activeTrackColor: Colors.white30,
                          inactiveTrackColor: Colors.white12,
                          thumbColor: Colors.transparent,
                          overlayColor: Colors.transparent,
                        ),
                        child: Slider(
                          min: 0,
                          max: duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1,
                          value: buffer.inMilliseconds.toDouble().clamp(0, duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1),
                          onChanged: (value) {},
                        ),
                      ),
                      // Current Progress
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                          activeTrackColor: Colors.red,
                          inactiveTrackColor: Colors.transparent,
                          thumbColor: Colors.red,
                          overlayColor: Colors.red.withOpacity(0.3),
                        ),
                        child: Slider(
                          min: 0,
                          max: duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1,
                          value: position.inMilliseconds.toDouble().clamp(0, duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1),
                          onChanged: (value) {
                            bloc.add(SeekTo(Duration(milliseconds: value.toInt())));
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
