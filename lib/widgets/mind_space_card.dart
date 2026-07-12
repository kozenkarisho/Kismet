import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MindSpaceCard extends StatelessWidget {
  final String title;

  const MindSpaceCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2113),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10), width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: GoogleFonts.inter(
            color: const Color(0xFFE3E4CE),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
