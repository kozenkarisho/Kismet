import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class KismetLogo extends StatelessWidget {
  final double? size;
  final Color? color;

  const KismetLogo({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? const Color(0xFFE3E4CE);
    final logoSize = size ?? 34.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'K',
          style: GoogleFonts.inter(
            color: textColor,
            fontWeight: FontWeight.w300,
            fontSize: logoSize,
            letterSpacing: 0.2 * logoSize / 10,
          ),
        ),
        SizedBox(
          width: logoSize * 0.35,
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Text(
                'ı',
                style: GoogleFonts.inter(
                  color: textColor,
                  fontWeight: FontWeight.w300,
                  fontSize: logoSize * 0.85,
                ),
              ),
              Positioned(
                bottom: logoSize * 0.3,
                child: CustomPaint(
                  size: Size(logoSize * 0.4, logoSize * 0.4),
                  painter: StarPainter(color: textColor),
                ),
              ),
            ],
          ),
        ),
        Text(
          'SMET',
          style: GoogleFonts.inter(
            color: textColor,
            fontWeight: FontWeight.w300,
            fontSize: logoSize,
            letterSpacing: 0.2 * logoSize / 10,
          ),
        ),
      ],
    );
  }
}

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.4;

    // Draw 8-point star
    final path = Path();
    for (int i = 0; i < 16; i++) {
      final angle = (i * 22.5) * 3.14159 / 180;
      final radius = i % 2 == 0 ? outerRadius : innerRadius;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
