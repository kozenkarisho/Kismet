import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const KismetApp());
}

class KismetApp extends StatelessWidget {
  const KismetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kismet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0D0F04),
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        colorScheme: const ColorScheme.dark(
          background: Color(0xFF0D0F04),
          surface: Color(0xFF1F2113),
          primary: Color(0xFFDFFF00),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
