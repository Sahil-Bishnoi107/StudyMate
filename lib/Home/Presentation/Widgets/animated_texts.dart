import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class TypingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration delay;
  final Duration charDuration;
  final VoidCallback? onComplete;

  const TypingText({
    super.key,
    required this.text,
    required this.style,
    this.delay = Duration.zero,
    this.charDuration = const Duration(milliseconds: 45),
    this.onComplete,
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  int _currentIndex = 0;
  Timer? _timer;
  Timer? _delayTimer;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _startTyping();
    } else {
      _delayTimer = Timer(widget.delay, _startTyping);
    }
  }

  void _startTyping() {
    if (!mounted) return;
    setState(() {
      _started = true;
    });
    if (widget.text.isEmpty) {
      widget.onComplete?.call();
      return;
    }
    _timer = Timer.periodic(widget.charDuration, (timer) {
      if (!mounted) return;
      setState(() {
        _currentIndex++;
      });
      if (_currentIndex >= widget.text.length) {
        _timer?.cancel();
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _delayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Invisible text to maintain exact layout size
        Text(
          widget.text,
          style: widget.style.copyWith(color: Colors.transparent),
        ),
        // Visible typing text
        Text(
          !_started ? "" : widget.text.substring(0, _currentIndex),
          style: widget.style,
        ),
      ],
    );
  }
}

class ScrambleText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration delay;
  final Duration duration;

  const ScrambleText({
    super.key,
    required this.text,
    required this.style,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<ScrambleText> createState() => _ScrambleTextState();
}

class _ScrambleTextState extends State<ScrambleText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _currentText = "";
  final String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#@%^&*()_+-=[]{}|;:,.<>?';
  final Random _random = Random();
  Timer? _delayTimer;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _currentText = _generateRandomString(widget.text.length);
    _controller = AnimationController(vsync: this, duration: widget.duration);
    
    _controller.addListener(() {
      if (!mounted) return;
      int lockLength = (_controller.value * widget.text.length).floor();
      String lockedPart = widget.text.substring(0, lockLength);
      String scrambledPart = _generateRandomString(widget.text.length - lockLength);
      setState(() {
        _currentText = lockedPart + scrambledPart;
      });
    });

    if (widget.delay == Duration.zero) {
      _startScramble();
    } else {
      _delayTimer = Timer(widget.delay, _startScramble);
    }
  }

  void _startScramble() {
    if (!mounted) return;
    setState(() {
      _started = true;
    });
    _controller.forward();
  }

  String _generateRandomString(int length) {
    if (length <= 0) return "";
    return String.fromCharCodes(Iterable.generate(
      length, 
      (_) => _chars.codeUnitAt(_random.nextInt(_chars.length))
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _delayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Invisible text to maintain exact layout size
        Text(
          widget.text,
          style: widget.style.copyWith(color: Colors.transparent),
        ),
        // Scrambling text
        Text(
          !_started ? "" : _currentText,
          style: widget.style,
        ),
      ],
    );
  }
}
