import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = true;

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
                    'Settings',
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
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1F2113) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark
                            ? const Color(0x0DFFFFFF)
                            : const Color(0x111C1E14),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? const Color(0xFF1A1C10)
                                : const Color(0xFFF7F9F4),
                          ),
                          child: Icon(
                            Icons.person_outline,
                            color: isDark
                                ? const Color(0xFFC6C9AB)
                                : const Color(0xFF1C1E14),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Profile',
                                style: GoogleFonts.inter(
                                  color: isDark
                                      ? const Color(0xFFE3E4CE)
                                      : const Color(0xFF1C1E14),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Edit your profile',
                                style: GoogleFonts.inter(
                                  color: isDark
                                      ? const Color(0xFFC6C9AB)
                                      : const Color(0x661C1E14),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: isDark
                              ? const Color(0xFFC6C9AB)
                              : const Color(0x661C1E14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1F2113) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark
                            ? const Color(0x0DFFFFFF)
                            : const Color(0x111C1E14),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dark Mode',
                                style: GoogleFonts.inter(
                                  color: isDark
                                      ? const Color(0xFFE3E4CE)
                                      : const Color(0xFF1C1E14),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Switch between themes',
                                style: GoogleFonts.inter(
                                  color: isDark
                                      ? const Color(0xFFC6C9AB)
                                      : const Color(0x661C1E14),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isDarkMode,
                          onChanged: (value) =>
                              setState(() => _isDarkMode = value),
                          activeColor: isDark
                              ? const Color(0xFFDFFF00)
                              : const Color(0xFFB8D900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
