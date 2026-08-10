import 'package:study_mate/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerBloc.dart';

class TimeIndicator extends StatelessWidget {
  const TimeIndicator({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();

    return StreamBuilder<Duration>(
      stream: bloc.mediaKit.player.stream.duration,
      builder: (context, durationSnapshot) {
        final duration = durationSnapshot.data ?? Duration.zero;

        return StreamBuilder<Duration>(
          stream: bloc.mediaKit.player.stream.position,
          builder: (context, positionSnapshot) {
            var position = positionSnapshot.data ?? Duration.zero;
            
            if (position > duration) position = duration;

            return Text(
              "${_formatDuration(position)} / ${_formatDuration(duration)}",
              style:  TextStyle(
                color: Colors.white,
                fontSize: Responsive.font(context, 12),
                fontWeight: FontWeight.w500,
              ),
            );
          },
        );
      },
    );
  }
}
