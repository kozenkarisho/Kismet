import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// The Kismet logo widget - draws the star and KISMET text in code
// No image file needed - everything is drawn programmatically
// This means it scales perfectly on any screen size
class KismetLogo extends StatelessWidget {
  // Size controls how big the logo appears
  final double size;

  const KismetLogo({
    super.key,
    // Default size of 34, same as the prototype
    this.size = 34,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment.baseline aligns all text to the same baseline
      // This keeps K, ı, SMET all sitting on the same invisible line
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      mainAxisSize: MainAxisSize.min,
      children: [
        // The letter K
        Text(
          'K',
          style: GoogleFonts.inter(
            fontSize: size,
            // w300 is light weight - matches the prototype's font-[300]
            fontWeight: FontWeight.w300,
            color: const Color(0xFFE3E4CE),
            // Wide letter spacing matches the prototype's tracking-[0.2em]
            letterSpacing: size * 0.2,
            height: 1.0,
          ),
        ),
        // The dotless i with the star above it
        // Stack layers the star on top of the ı character
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // The dotless ı character
            Text(
              'ı',
              style: GoogleFonts.inter(
                // Slightly smaller than the other letters, matches prototype's text-[30px]
                fontSize: size * 0.88,
                fontWeight: FontWeight.w300,
                color: const Color(0xFFE3E4CE),
                height: 1.0,
              ),
            ),
            // The star positioned above the ı
            // Positioned.fill with a negative bottom pushes it up
            Positioned(
              // Negative bottom moves the star upward above the letter
              bottom: size * 0.35,
              child: SizedBox(
                // Star is 1.4x the font size, same as prototype's w-[1.4em]
                width: size * 1.4 * 0.88,
                height: size * 1.4 * 0.88,
                child: CustomPaint(
                  painter: _StarPainter(
                    color: const Color(0xFFE3E4CE),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Small spacing between ı and SMET
        SizedBox(width: size * 0.1),
        // The letters SMET
        Text(
          'SMET',
          style: GoogleFonts.inter(
            fontSize: size,
            fontWeight: FontWeight.w300,
            color: const Color(0xFFE3E4CE),
            // Same wide letter spacing as K
            letterSpacing: size * 0.2,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

// CustomPainter that draws the 8-point star shape
// This is the same star path from the React prototype
// M50,-10 L52,46 L66,34 L54,48 L90,50 L54,52 L66,66 L52,54 L50,95 L48,54 L34,66 L46,52 L10,50 L46,48 L34,34 L48,46 Z
class _StarPainter extends CustomPainter {
  // The color of the star, passed in from outside
  final Color color;

  const _StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Paint defines how the shape looks - color and fill style
    final paint = Paint()
      // The color passed in from KismetLogo
      ..color = color
      // fill means the shape is solid, not just an outline
      ..style = PaintingStyle.fill;

    // Path defines the shape we're drawing
    // The SVG coordinates go from 0-100, so we scale them to the actual widget size
    final path = Path();

    // Helper function that converts SVG coordinates (0-100) to actual pixel positions
    // SVG x=50 means center horizontally, SVG y=50 means center vertically
    double x(double svgX) => svgX / 100 * size.width;
    double y(double svgY) => svgY / 100 * size.height;

    // Drawing the star path point by point
    // M = move to starting point (no line drawn)
    path.moveTo(x(50), y(-10));
    // L = draw a line to this point
    path.lineTo(x(52), y(46));
    path.lineTo(x(66), y(34));
    path.lineTo(x(54), y(48));
    path.lineTo(x(90), y(50));
    path.lineTo(x(54), y(52));
    path.lineTo(x(66), y(66));
    path.lineTo(x(52), y(54));
    path.lineTo(x(50), y(95));
    path.lineTo(x(48), y(54));
    path.lineTo(x(34), y(66));
    path.lineTo(x(46), y(52));
    path.lineTo(x(10), y(50));
    path.lineTo(x(46), y(48));
    path.lineTo(x(34), y(34));
    path.lineTo(x(48), y(46));
    // Z = close the path, draws a line back to the starting point
    path.close();

    // Actually draws the path on the canvas
    canvas.drawPath(path, paint);
  }

  // shouldRepaint tells Flutter if it needs to redraw the star
  // false means the star never changes so Flutter doesn't waste time redrawing it
  @override
  bool shouldRepaint(_StarPainter oldDelegate) => oldDelegate.color != color;
}