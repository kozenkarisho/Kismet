import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SerenityBar extends StatelessWidget {
  const SerenityBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2113),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: const Color(0xFF454932), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFFC6C9AB), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: GoogleFonts.inter(color: const Color(0xFFE3E4CE)),
              decoration: InputDecoration(
                hintText: 'Ask Serenity',
                hintStyle: GoogleFonts.inter(color: const Color(0xFFC6C9AB)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
