import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerBloc.dart';

class BufferingWidget extends StatelessWidget {
  const BufferingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();

    return StreamBuilder<bool>(
      stream: bloc.mediaKit.player.stream.buffering,
      builder: (context, snapshot) {
        final isBuffering = snapshot.data ?? false;

        if (!isBuffering) return const SizedBox.shrink();

        return const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        );
      },
    );
  }
}
