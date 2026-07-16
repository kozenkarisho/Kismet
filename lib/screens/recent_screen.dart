import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0D0F04)
          : const Color(0xFFF2F4F0),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 32),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF1F2113) : Colors.white,
                        border: Border.all(
                          color: isDark
                              ? const Color(0x0DFFFFFF)
                              : const Color(0x111C1E14),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: isDark
                            ? const Color(0xFFE3E4CE)
                            : const Color(0xFF1C1E14),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Recent Spaces',
                    style: GoogleFonts.inter(
                      color: isDark
                          ? const Color(0xFFE3E4CE)
                          : const Color(0xFF1C1E14),
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.6,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1F2113) : Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: isDark
                            ? const Color(0x0DFFFFFF)
                            : const Color(0x111C1E14),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Space ${index + 1}',
                          style: GoogleFonts.inter(
                            color: isDark
                                ? const Color(0xFFE3E4CE)
                                : const Color(0xFF1C1E14),
                            fontWeight: FontWeight.w600,
                            fontSize: 21,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
