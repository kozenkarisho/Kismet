import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/kismet_logo.dart';
import '../widgets/serenity_bar.dart';
import '../widgets/patterns.dart';
import '../models/space_item.dart';
import 'mind_vault_screen.dart';
import 'recent_screen.dart';
import 'dive_in_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<SpaceItem> _spaces = [
    SpaceItem(
      id: '1',
      title: 'Movies',
      bannerType: 'color',
      bannerValue: 'bg-blue-500/20',
    ),
    SpaceItem(
      id: '2',
      title: 'Recipes',
      bannerType: 'pattern',
      bannerValue: 'dots',
      bannerColor: '#f87171',
    ),
    SpaceItem(
      id: '3',
      title: 'Education',
      bannerType: 'color',
      bannerValue: 'bg-green-500/20',
    ),
    SpaceItem(
      id: '4',
      title: 'Religion',
      bannerType: 'pattern',
      bannerValue: 'circles',
      bannerColor: '#60a5fa',
    ),
    SpaceItem(
      id: '5',
      title: 'Memes',
      bannerType: 'color',
      bannerValue: 'bg-purple-500/20',
    ),
    SpaceItem(
      id: '6',
      title: 'Songs',
      bannerType: 'pattern',
      bannerValue: 'dots',
      bannerColor: '#fbbf24',
    ),
  ];

  String _userName = 'User';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D0F04) : const Color(0xFFF2F4F0),
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDark
                          ? const Color(0xFFDFFF00)
                          : const Color(0xFFB8D900))
                      .withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              right: -50,
              child: Container(
                width: 192,
                height: 192,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDark
                          ? const Color(0xFFDFFF00)
                          : const Color(0xFFB8D900))
                      .withOpacity(0.05),
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 56),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const KismetLogo(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFFE3E4CE).withOpacity(0.1)
                                  : const Color(0x111C1E14),
                              width: 1,
                            ),
                            color:
                                isDark ? const Color(0xFF1F2113) : Colors.white,
                          ),
                          child: Icon(
                            Icons.settings_outlined,
                            color: isDark
                                ? const Color(0xFFC6C9AB)
                                : const Color(0xFF1C1E14),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Greeting
                  Text(
                    'Hi, $_userName',
                    style: GoogleFonts.inter(
                      color: isDark
                          ? const Color(0xFFE3E4CE)
                          : const Color(0xFF1C1E14),
                      fontWeight: FontWeight.w900,
                      fontSize: 38,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'what do you wanna rekindle today ....',
                    style: GoogleFonts.inter(
                      color: isDark
                          ? const Color(0xFFC6C9AB)
                          : const Color(0x661C1E14),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Serenity Search Bar
                  SerenityBar(
                    controller: _searchController,
                    onTap: () {
                      // TODO: Implement search
                    },
                  ),

                  const SizedBox(height: 32),

                  // Cards Grid
                  Row(
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DiveInScreen(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isDark
                                      ? [
                                          const Color(0xFFDFFF00),
                                          const Color(0xFFBADD00),
                                        ]
                                      : [
                                          const Color(0xFFDFFF00),
                                          const Color(0xFFBADD00),
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFDFFF00,
                                    ).withOpacity(isDark ? 0.15 : 0.4),
                                    blurRadius: 30,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: -40,
                                    right: -40,
                                    child: SizedBox(
                                      width: 192,
                                      height: 192,
                                      child: ConcentricCircles(
                                        color: Colors.black,
                                        opacity: 0.25,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dive in',
                                          style: GoogleFonts.inter(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 24,
                                          ),
                                        ),
                                        const Spacer(),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.9,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.north_east,
                                              color: const Color(0xFFDFFF00),
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RecentScreen(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1F2113)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0x0DFFFFFF)
                                      : const Color(0x111C1E14),
                                  width: 1,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  PatternDots(
                                    color: isDark ? Colors.white : Colors.black,
                                    opacity: isDark ? 0.2 : 0.03,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Recent',
                                          style: GoogleFonts.inter(
                                            color: isDark
                                                ? const Color(0xFFE3E4CE)
                                                : const Color(0xFF1C1E14),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24,
                                          ),
                                        ),
                                        const Spacer(),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? Colors.white.withOpacity(
                                                      0.05,
                                                    )
                                                  : Colors.white,
                                              border: Border.all(
                                                color: isDark
                                                    ? Colors.white.withOpacity(
                                                        0.1,
                                                      )
                                                    : Colors.black.withOpacity(
                                                        0.05,
                                                      ),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: isDark
                                                  ? const Color(0xFFE3E4CE)
                                                  : Colors.black,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Mind Vault Preview
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MindVaultScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1A1C10).withOpacity(0.8)
                            : const Color(0xFFFAFBFA),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.03),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mind Vault',
                                style: GoogleFonts.inter(
                                  color: isDark
                                      ? const Color(0xFFE3E4CE)
                                      : const Color(0xFF1C1E14),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                ),
                              ),
                              Icon(
                                Icons.chevron_left,
                                color: isDark
                                    ? const Color(0xFFC6C9AB)
                                    : const Color(0x661C1E14),
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          ..._spaces.take(2).map(
                                (space) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1F2113)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(32),
                                      border: Border.all(
                                        color: isDark
                                            ? const Color(0x0DFFFFFF)
                                            : const Color(0x111C1E14),
                                        width: 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(24),
                                    child: Text(
                                      space.title,
                                      style: GoogleFonts.inter(
                                        color: isDark
                                            ? const Color(0xFFE3E4CE)
                                            : const Color(0xFF1C1E14),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
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
