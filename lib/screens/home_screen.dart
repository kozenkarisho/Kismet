import '../theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/kismet_logo.dart';
import '../widgets/patterns.dart';
import '../widgets/save_link_sheet.dart';
import '../widgets/search_overlay.dart';
import '../services/app_state.dart';
import '../services/gemini_service.dart';
import '../models/space_item.dart';
import 'mind_vault_screen.dart';
import 'recent_screen.dart';
import 'dive_in_screen.dart';
import 'settings_screen.dart';
import 'space_detail_screen.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  final AppState appState;
  final GeminiService geminiService;

  const HomeScreen({
    super.key,
    required this.appState,
    required this.geminiService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty && value.first.type == SharedMediaType.text) {
        _handleSharedText(value.first.path);
      }
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty && value.first.type == SharedMediaType.text) {
        _handleSharedText(value.first.path);
      }
      ReceiveSharingIntent.instance.reset();
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  void _handleSharedText(String text) {
    if (text.startsWith('http')) {
      _openSaveLinkSheet(context, prefilledUrl: text);
    }
  }

  void _openSearch(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => SearchOverlay(appState: widget.appState, geminiService: widget.geminiService),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  void _openSaveLinkSheet(BuildContext context, {String? prefilledUrl}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SaveLinkSheet(
        appState: widget.appState,
        geminiService: widget.geminiService,
        prefilledUrl: prefilledUrl,
      ),
    );
  }

  void _openSpace(BuildContext context, SpaceItem space) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SpaceDetailScreen(
          space: space,
          appState: widget.appState,
          geminiService: widget.geminiService,
        ),
      ),
    );
  }

  Color _parseBannerColor(String? hex, Color fallback) {
    if (hex == null) return fallback;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final spaces = widget.appState.spaces;
        final previewSpaces = spaces.take(4).toList();

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0D0F04) : const Color(0xFFF2F4F0),
          body: SafeArea(
            child: Stack(
              children: [
                // Background glows
                Positioned(
                  top: -100, left: -100,
                  child: Container(
                    width: 256, height: 256,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFDFFF00).withOpacity(0.05),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.2, right: -50,
                  child: Container(
                    width: 192, height: 192,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFDFFF00).withOpacity(0.04),
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
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SettingsScreen(appState: widget.appState),
                              ),
                            ),
                            child: Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFFE3E4CE).withOpacity(0.1)
                                      : AppTheme.borderLight,
                                ),
                                color: isDark ? const Color(0xFF1F2113) : Colors.white,
                              ),
                              child: Icon(
                                Icons.settings_outlined,
                                color: isDark ? const Color(0xFFC6C9AB) : AppTheme.textMainLight,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Greeting
                      Text(
                        'Hi, ${widget.appState.userName}',
                        style: GoogleFonts.inter(
                          color: isDark ? const Color(0xFFE3E4CE) : AppTheme.textMainLight,
                          fontWeight: FontWeight.w900,
                          fontSize: 38,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'what do you wanna rekindle today ....',
                        style: GoogleFonts.inter(
                          color: isDark ? const Color(0xFFC6C9AB) : AppTheme.textMutedLight,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Serenity Search Bar (tappable → search overlay)
                      GestureDetector(
                        onTap: () => _openSearch(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1F2113) : Colors.white,
                            borderRadius: BorderRadius.circular(9999),
                            border: Border.all(
                              color: isDark ? const Color(0xFF454932) : AppTheme.borderLight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(isDark ? 0.15 : 0.08),
                                blurRadius: 40,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              Icon(Icons.search,
                                  color: isDark ? const Color(0xFFC6C9AB) : AppTheme.textMutedLight,
                                  size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Ask Serenity',
                                  style: GoogleFonts.inter(
                                    color: isDark ? const Color(0xFFC6C9AB) : AppTheme.textMutedLight,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.black.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(Icons.arrow_forward,
                                    color: isDark ? Colors.white : Colors.black,
                                    size: 16),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Action Cards Row
                      Row(
                        children: [
                          // Dive In card
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DiveInScreen(
                                      appState: widget.appState,
                                      geminiService: widget.geminiService,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFDFFF00), Color(0xFFBADD00)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(32),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFDFFF00).withOpacity(0.15),
                                        blurRadius: 30,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: -40, right: -40,
                                        child: SizedBox(
                                          width: 192, height: 192,
                                          child: ConcentricCircles(color: Colors.black, opacity: 0.25),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Dive in',
                                                style: GoogleFonts.inter(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 24)),
                                            const Spacer(),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                width: 48, height: 48,
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.9),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.north_east,
                                                    color: Color(0xFFDFFF00), size: 24),
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
                          // Recent card
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RecentScreen(
                                      appState: widget.appState,
                                      geminiService: widget.geminiService,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1F2113) : Colors.white,
                                    borderRadius: BorderRadius.circular(32),
                                    border: Border.all(
                                      color: isDark ? const Color(0x0DFFFFFF) : AppTheme.borderLight,
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Recent',
                                                style: GoogleFonts.inter(
                                                    color: isDark
                                                        ? const Color(0xFFE3E4CE)
                                                        : AppTheme.textMainLight,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 24)),
                                            const Spacer(),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                width: 48, height: 48,
                                                decoration: BoxDecoration(
                                                  color: isDark
                                                      ? Colors.white.withOpacity(0.05)
                                                      : Colors.white,
                                                  border: Border.all(
                                                    color: isDark
                                                        ? Colors.white.withOpacity(0.1)
                                                        : Colors.black.withOpacity(0.05),
                                                  ),
                                                  borderRadius: BorderRadius.circular(24),
                                                ),
                                                child: Icon(Icons.arrow_forward,
                                                    color: isDark
                                                        ? const Color(0xFFE3E4CE)
                                                        : Colors.black,
                                                    size: 20),
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
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MindVaultScreen(
                              appState: widget.appState,
                              geminiService: widget.geminiService,
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1A1C10).withOpacity(0.8)
                                : const Color(0xFFFAFBFA),
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.white.withOpacity(0.03)),
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
                                      color: isDark ? const Color(0xFFE3E4CE) : AppTheme.textMainLight,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${spaces.length} spaces',
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFFC6C9AB),
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.chevron_right,
                                          color: Color(0xFFC6C9AB), size: 18),
                                    ],
                                  ),
                                ],
                              ),
                              if (previewSpaces.isEmpty) ...[
                                const SizedBox(height: 24),
                                Center(
                                  child: Text(
                                    'No spaces yet — tap to create one',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF555840),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ] else ...[
                                const SizedBox(height: 20),
                                GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 2.2,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: previewSpaces.map((space) {
                                    return _buildPreviewSpaceCard(context, space, isDark);
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),

                // FAB: Save link
                Positioned(
                  bottom: 32,
                  right: 20,
                  child: GestureDetector(
                    onTap: () => _openSaveLinkSheet(context),
                    child: Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFFF00),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFDFFF00).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add, color: Colors.black, size: 28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreviewSpaceCard(BuildContext context, SpaceItem space, bool isDark) {
    final bannerColor = _parseBannerColor(space.bannerColor, const Color(0xFF2A2D1A));

    return GestureDetector(
      onTap: () => _openSpace(context, space),
      child: Container(
        decoration: BoxDecoration(
          color: space.bannerType == 'color' && space.bannerColor != null
              ? bannerColor.withOpacity(0.15)
              : isDark ? const Color(0xFF1F2113) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0x0DFFFFFF) : AppTheme.borderLight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Stack(
          children: [
            if (space.bannerType == 'pattern' && space.bannerValue == 'dots')
              PatternDots(color: Colors.white, opacity: 0.1),
            if (space.bannerType == 'pattern' && space.bannerValue == 'circles')
              Positioned(
                top: -12, right: -12,
                child: SizedBox(
                  width: 60, height: 60,
                  child: ConcentricCircles(color: Colors.white, opacity: 0.1),
                ),
              ),
            Text(
              space.title,
              style: GoogleFonts.inter(
                color: isDark ? const Color(0xFFE3E4CE) : AppTheme.textMainLight,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

