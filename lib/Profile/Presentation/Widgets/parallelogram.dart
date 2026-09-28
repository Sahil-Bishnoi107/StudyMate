import 'package:flutter/material.dart';

class Parallelogram extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final double borderWidth;
  final double angle;
  final double height;
  final double width;

  const Parallelogram({
    super.key,
    required this.child,
    this.borderColor = Colors.black,
    this.borderWidth = 1,
    this.angle = 20,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _ParallelogramPainter(
          borderColor: borderColor,
          borderWidth: borderWidth,
          angle: angle,
        ),
        child: ClipPath(
          clipper: _ParallelogramClipper(angle),
          child: SizedBox(
            width: width,
            height: height,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _ParallelogramClipper extends CustomClipper<Path> {
  final double angle;

  const _ParallelogramClipper(this.angle);

  @override
  Path getClip(Size size) {
    final slant = size.height * (angle / 45);

    return Path()
      ..moveTo(slant, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - slant, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _ParallelogramClipper oldClipper) {
    return oldClipper.angle != angle;
  }
}

class _ParallelogramPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final double angle;

  const _ParallelogramPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final slant = size.height * (angle / 45);

    final path = Path()
      ..moveTo(slant, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - slant, size.height)
      ..lineTo(0, size.height)
      ..close();

    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ParallelogramPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.angle != angle;
  }
}