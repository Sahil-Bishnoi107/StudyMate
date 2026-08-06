import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerBloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerEvents.dart';

class DoubleTapOverlay extends StatefulWidget {
  const DoubleTapOverlay({super.key});

  @override
  State<DoubleTapOverlay> createState() => _DoubleTapOverlayState();
}

class _DoubleTapOverlayState extends State<DoubleTapOverlay> {
  bool _showLeft = false;
  bool _showRight = false;

  void _handleTap() {
    final bloc = context.read<PlayerBloc>();
    if (bloc.state.controlsVisible) {
      bloc.add(HideControls());
    } else {
      bloc.add(ShowControls());
    }
  }

  void _handleDoubleTapLeft() {
    context.read<PlayerBloc>().add(BackwardFiveSeconds());
    setState(() {
      _showLeft = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showLeft = false;
        });
      }
    });
  }

  void _handleDoubleTapRight() {
    context.read<PlayerBloc>().add(ForwardFiveSeconds());
    setState(() {
      _showRight = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showRight = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    final controlsVisible = context.select((PlayerBloc b) => b.state.controlsVisible);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background dimming
        AnimatedOpacity(
          opacity: controlsVisible ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: IgnorePointer(
            child: Container(
              color: Colors.black45,
            ),
          ),
        ),
        // Gesture Areas
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _handleTap,
                onDoubleTap: _handleDoubleTapLeft,
                child: AnimatedOpacity(
                  opacity: _showLeft ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.replay_5, color: Colors.white, size: 40),
                          SizedBox(height: 8),
                          Text("5 seconds", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _handleTap,
                onDoubleTap: _handleDoubleTapRight,
                child: AnimatedOpacity(
                  opacity: _showRight ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.forward_5, color: Colors.white, size: 40),
                          SizedBox(height: 8),
                          Text("5 seconds", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
