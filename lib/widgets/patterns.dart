import 'package:flutter/material.dart';

class PatternDots extends StatelessWidget {
  final Color? color;
  final double opacity;

  const PatternDots({super.key, this.color, this.opacity = 0.2});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: DotsPainter(color: color ?? Colors.white, opacity: opacity),
    );
  }
}

class DotsPainter extends CustomPainter {
  final Color color;
  final double opacity;

  DotsPainter({required this.color, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    const spacing = 12.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ConcentricCircles extends StatelessWidget {
  final Color? color;
  final double opacity;

  const ConcentricCircles({super.key, this.color, this.opacity = 0.1});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: CirclesPainter(color: color ?? Colors.white, opacity: opacity),
    );
  }
}

class CirclesPainter extends CustomPainter {
  final Color color;
  final double opacity;

  CirclesPainter({required this.color, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(center, maxRadius * (i / 5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
