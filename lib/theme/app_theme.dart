import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color pageBgLight = Color(0xFFF2F4F0);
  static const Color pageBgDark = Color(0xFF0A0A0A);
  static const Color appBgDark = Color(0xFF0D0F04);
  static const Color cardBgDark = Color(0xFF1F2113);
  static const Color vaultBgDark = Color(0xFF1A1C10);
  static const Color inputBgDark = Color(0xFF353825);
  static const Color textMainLight = Color(0xFF1C1E14);
  static const Color textMainDark = Color(0xFFE3E4CE);
  static const Color textMutedDark = Color(0xFFC6C9AB);
  static const Color accentLight = Color(0xFFB8D900);
  static const Color accentDark = Color(0xFFDFFF00);
  static const Color borderLight = Color(0x111C1E14);
  static const Color borderDark = Color(0x0DFFFFFF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: pageBgLight,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: GoogleFonts.interTextTheme(),
      colorScheme: const ColorScheme.light(
        background: Colors.white,
        surface: Colors.white,
        primary: accentLight,
        onPrimary: textMainLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: pageBgDark,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          bodyLarge: TextStyle(color: textMainDark),
          bodyMedium: TextStyle(color: textMainDark),
          bodySmall: TextStyle(color: textMutedDark),
        ),
      ),
      colorScheme: const ColorScheme.dark(
        background: appBgDark,
        surface: cardBgDark,
        primary: accentDark,
        onPrimary: Colors.black,
      ),
    );
  }
}
