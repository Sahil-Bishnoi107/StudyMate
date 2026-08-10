import 'package:study_mate/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerBloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerEvents.dart';

class SpeedBottomSheet extends StatelessWidget {
  const SpeedBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    final currentSpeed = bloc.state.playbackSpeed;

    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Playback Speed",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.font(context, 18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...speeds.map((speed) {
                final isSelected = speed == currentSpeed;
                return ListTile(
                  title: Text(
                    "${speed}x",
                    style: TextStyle(
                      color: isSelected ? Colors.red : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.red)
                      : null,
                  onTap: () {
                    bloc.add(ChangePlaybackSpeed(speed));
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
