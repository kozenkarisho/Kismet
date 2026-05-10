import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/kismet_logo.dart';
import '../widgets/serenity_bar.dart';
import 'mind_vault_screen.dart';

// The main home screen - rebuilt to match the React prototype exactly
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Rotating greeting phrases - changes based on current second
  static const List<String> _greetings = [
    'what do you wanna rekindle today ....',
    'something has been waiting for you.',
    'your vault has been thinking.',
    'ready when you are.',
    'a few things worth revisiting.',
  ];

  // Picks a phrase based on current second so it feels alive
  String get _currentGreeting {
    final index = DateTime.now().second % _greetings.length;
    return _greetings[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F04),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Top bar - logo left, settings icon right
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SVG logo drawn in code
                  const KismetLogo(size: 34),
                  // Settings icon with circular border
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE3E4CE).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: Color(0xFFE3E4CE),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),

            // Section 2: Greeting
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, User',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFE3E4CE),
                      fontWeight: FontWeight.w900,
                      fontSize: 32,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _currentGreeting,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFC6C9AB),
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            // Section 3: Two cards side by side
            // IntrinsicHeight makes both cards the same height automatically
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: IntrinsicHeight(
                child: Row(
                  // CrossAxisAlignment.stretch makes both cards fill the IntrinsicHeight
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Dive in card - neon lime, takes 3 parts of space
                    Expanded(
                      flex: 3,
                      child: _buildDiveInCard(),
                    ),
                    const SizedBox(width: 12),
                    // Recent card - dark, takes 2 parts of space
                    Expanded(
                      flex: 2,
                      child: _buildRecentCard(),
                    ),
                  ],
                ),
              ),
            ),

            // Section 4: Ask Serenity bar - below the cards
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: const SerenityBar(),
            ),

            const SizedBox(height: 16),

            // Section 5: Mind Vault - takes all remaining space
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MindVaultScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2113),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mind Vault',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFE3E4CE),
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dive in card - neon lime with concentric circles pattern
  Widget _buildDiveInCard() {
    return Container(
      // Minimum height so the card is never too small
      constraints: const BoxConstraints(minHeight: 180),
      decoration: BoxDecoration(
        color: const Color(0xFFDFFF00),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Concentric circles pattern in top right corner
          Positioned(
            top: -20,
            right: -20,
            child: SizedBox(
              width: 140,
              height: 140,
              child: CustomPaint(
                painter: _ConcentricCirclesPainter(
                  // Dark lime color so circles are subtle
                  color: Colors.black.withOpacity(0.15),
                ),
              ),
            ),
          ),
          // Card title top left
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Dive in',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          // Arrow button bottom right
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_outward,
                color: Color(0xFFDFFF00),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Recent card - dark background
  Widget _buildRecentCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2113),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Card title top left
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Recent',
              style: GoogleFonts.inter(
                color: const Color(0xFFE3E4CE),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          // Arrow button bottom right
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward,
                color: const Color(0xFFE3E4CE).withOpacity(0.6),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Draws concentric circles pattern inside the Dive in card
class _ConcentricCirclesPainter extends CustomPainter {
  final Color color;

  const _ConcentricCirclesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      // Stroke = outline only, not filled
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw 7 circles with increasing radius
    for (int i = 1; i <= 7; i++) {
      canvas.drawCircle(
        center,
        i * 10.0 / 100 * size.width * 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ConcentricCirclesPainter oldDelegate) =>
      oldDelegate.color != color;
}