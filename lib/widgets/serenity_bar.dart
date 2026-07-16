import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SerenityBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final String hintText;

  const SerenityBar({
    super.key,
    required this.controller,
    required this.onTap,
    this.hintText = 'Ask Serenity',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2113) : Colors.white,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: isDark ? const Color(0xFF454932) : const Color(0x111C1E14),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.15 : 0.08),
              blurRadius: 40,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: isDark ? const Color(0xFFC6C9AB) : const Color(0x661C1E14),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hintText,
                style: GoogleFonts.inter(
                  color: isDark
                      ? const Color(0xFFC6C9AB)
                      : const Color(0x661C1E14),
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: isDark ? Colors.white : Colors.black,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
