import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerBloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerEvents.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerStates.dart';

class QualityBottomSheet extends StatelessWidget {
  const QualityBottomSheet({super.key});

  String _getQualityName(VideoQuality quality) {
    switch (quality) {
      case VideoQuality.auto:
        return "Auto";
      case VideoQuality.p1080:
        return "1080p";
      case VideoQuality.p720:
        return "720p";
      case VideoQuality.p480:
        return "480p";
      case VideoQuality.p360:
        return "360p";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    final currentQuality = bloc.state.quality;

    final qualities = VideoQuality.values;

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
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Video Quality",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...qualities.map((quality) {
                final isSelected = quality == currentQuality;
                return ListTile(
                  title: Text(
                    _getQualityName(quality),
                    style: TextStyle(
                      color: isSelected ? Colors.red : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.red)
                      : null,
                  onTap: () {
                    bloc.add(ChangeQuality(quality));
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
