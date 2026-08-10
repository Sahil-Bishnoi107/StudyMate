import 'package:flutter/material.dart';

class Fonts {
  static const String alice = 'Alice';
  static const String lobster = 'Lobster';
  static const String nunito = 'Nunito';
  static const String permanentMarker = 'PermanentMarker';
  static const String bangers = 'Bangers';
  static const String concertOne = 'Concert-One';
  static const String eduSaHand = 'Edu-SA-Hand';
  static const String pacifico = 'Pacifico';
  static const String lobsterTwo = 'Lobster-Two';
  static const String inter = 'Inter';
  static const String outfit = 'OutFit';
}


class Responsive {
  static double scale(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width / 432).clamp(0.85, 1.15);
  }

  static double font(BuildContext context, double size) {
    return size * scale(context);
  }

  static double icon(BuildContext context, double size) {
    return size * scale(context);
  }
}