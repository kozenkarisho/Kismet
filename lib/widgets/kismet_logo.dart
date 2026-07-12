// kismet_logo.dart
// This widget is the official app wordmark, displayed in the header of the Home Screen.
// Think of it as the neon sign hanging above the entrance of our building.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// KismetLogo is a StatelessWidget because it never changes on its own.
// A neon sign just sits there and glows; it does not need to remember anything.
class KismetLogo extends StatelessWidget {
  const KismetLogo({super.key});

  @override
  Widget build(BuildContext context) {
    // A Row lays out its children horizontally, left to right.
    // We use a Row so we can place the text and the accent dot side by side.
    return Row(
      // Keep everything packed tightly together at the start (left side).
      mainAxisSize: MainAxisSize.min,

      // Align items along the vertical center of the Row.
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        // --- The "K" letter with a yellow tint to set it apart ---
        // We split the word "Kismet" into "K" and "ismet" so we can style
        // the first letter differently, like a decorative drop cap.
        Text(
          'K',
          style: GoogleFonts.inter(
            // The vibrant electric yellow that defines the Kismet brand.
            color: const Color(0xFFDFFF00),

            // Thin weight gives it a modern, editorial feel.
            fontWeight: FontWeight.w300,

            // Large enough to be a clear wordmark.
            fontSize: 28,

            // Wide letter spacing makes it feel airy and premium.
            letterSpacing: 4,
          ),
        ),

        // --- The rest of the wordmark "ismet" in the standard off-white ---
        Text(
          'ismet',
          style: GoogleFonts.inter(
            // The primary off-white text color used throughout the app.
            color: const Color(0xFFE3E4CE),

            // Matching weight and size to the "K" for visual consistency.
            fontWeight: FontWeight.w300,
            fontSize: 28,
            letterSpacing: 4,
          ),
        ),

        // --- A small gap before the accent dot ---
        // SizedBox acts as an invisible spacer. This pushes the dot a little
        // away from the last letter, so it does not feel cramped.
        const SizedBox(width: 6),

        // --- The accent dot: a tiny yellow circle ---
        // This is the "subtle vibrant yellow accent" requested in the brief.
        // Think of it like the dot on a lowercase 'i', but for the whole brand.
        Container(
          // Width and height together create a perfect circle shape.
          width: 6,
          height: 6,

          decoration: const BoxDecoration(
            // Fill the circle with our brand yellow.
            color: Color(0xFFDFFF00),

            // BoxShape.circle makes it a perfect dot, with no corners.
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
