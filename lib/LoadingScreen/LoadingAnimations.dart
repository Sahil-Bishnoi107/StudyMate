import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/fonts.dart';

class LoadingLogo extends StatefulWidget {
  const LoadingLogo({
    super.key,
    this.size = 80,
  });

  final double size;

  @override
  State<LoadingLogo> createState() => _LoadingLogoState();
}

class _LoadingLogoState extends State<LoadingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;

  static const List<Map<String, String>> _quotes = [
    {
      "quote":
          "Success is the sum of small efforts, repeated day in and day out.",
      "author": "Robert Collier",
    },
    {
      "quote": "The expert in anything was once a beginner.",
      "author": "Helen Hayes",
    },
    {
      "quote": "It always seems impossible until it's done.",
      "author": "Nelson Mandela",
    },
    {
      "quote":
          "Discipline is choosing between what you want now and what you want most.",
      "author": "Abraham Lincoln",
    },
    {
      "quote": "Dreams don't work unless you do.",
      "author": "John C. Maxwell",
    },
    {
      "quote": "The future depends on what you do today.",
      "author": "Mahatma Gandhi",
    },
    {
      "quote":
          "Great things are done by a series of small things brought together.",
      "author": "Vincent van Gogh",
    },
    {
      "quote": "Learning never exhausts the mind.",
      "author": "Leonardo da Vinci",
    },
    {
      "quote": "Don't watch the clock; do what it does. Keep going.",
      "author": "Sam Levenson",
    },
    {
      "quote":
          "The beautiful thing about learning is that nobody can take it away from you.",
      "author": "B. B. King",
    },
  ];

  late final Map<String, String> _selectedQuote;

  @override
  void initState() {
    super.initState();
    

    _selectedQuote = _quotes[Random().nextInt(_quotes.length)];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _rotation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    while (mounted) {
      await _controller.forward(from: 0);

      // Pause for half a second after each cycle
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _rotation,
          builder: (_, child) {
            return Transform.rotate(
              angle: _rotation.value * 4 * math.pi,
              child: child,
            );
          },
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(20, 20, 20, 1),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(
              LucideIcons.zap,
              color: Colors.white,
              size: widget.size * 0.58,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            '"${_selectedQuote["quote"]!}"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontFamily: Fonts.outfit,
              fontWeight: FontWeight.w500,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "- ${_selectedQuote["author"]!}",
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
            fontFamily: Fonts.outfit,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}