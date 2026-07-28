import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/space_item.dart';
import '../services/app_state.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';
import '../widgets/patterns.dart';
import 'space_detail_screen.dart';

class RecentScreen extends StatelessWidget {
  final AppState appState;
  final GeminiService geminiService;

  const RecentScreen({
    super.key,
    required this.appState,
    required this.geminiService,
  });

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final recentSpaces = appState.recentSpaces;

        return Scaffold(
          backgroundColor: isDark ? AppTheme.appBgDark : AppTheme.pageBgLight,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? AppTheme.cardBgDark : Colors.white,
                            border: Border.all(
                              color: isDark ? const Color(0x0DFFFFFF) : AppTheme.borderLight,
                            ),
                          ),
                          child: Icon(Icons.chevron_left,
                              color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                              size: 24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Recent Spaces',
                          style: GoogleFonts.inter(
                              color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                              fontWeight: FontWeight.w900,
                              fontSize: 30)),
                    ],
                  ),
                ),
                Expanded(
                  child: recentSpaces.isEmpty
                      ? _buildEmptyState(isDark)
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.4,
                          ),
                          itemCount: recentSpaces.length,
                          itemBuilder: (context, index) {
                            return _buildSpaceCard(context, recentSpaces[index], isDark);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpaceCard(BuildContext context, SpaceItem space, bool isDark) {
    final bannerColor = _parseBannerColor(space.bannerColor, const Color(0xFF2A2D1A));
    final linkCount = appState.linksForSpace(space.id).length;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SpaceDetailScreen(
            space: space,
            appState: appState,
            geminiService: geminiService,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: space.bannerType == 'color' && space.bannerColor != null
              ? bannerColor.withOpacity(0.18)
              : (isDark ? AppTheme.cardBgDark : Colors.white),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark ? const Color(0x0DFFFFFF) : AppTheme.borderLight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            if (space.bannerType == 'pattern' && space.bannerValue == 'dots')
              PatternDots(color: Colors.white, opacity: 0.1),
            if (space.bannerType == 'pattern' && space.bannerValue == 'circles')
              Positioned(
                top: -20, right: -20,
                child: SizedBox(
                  width: 80, height: 80,
                  child: ConcentricCircles(color: Colors.white, opacity: 0.1),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  space.title,
                  style: GoogleFonts.inter(
                    color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$linkCount link${linkCount == 1 ? '' : 's'}',
                  style: GoogleFonts.inter(
                    color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: isDark ? AppTheme.cardBgDark : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.07) : AppTheme.borderLight),
            ),
            child: Icon(Icons.history, color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight, size: 32),
          ),
          const SizedBox(height: 20),
          Text('No recent spaces',
              style: GoogleFonts.inter(
                  color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 18)),
          const SizedBox(height: 8),
          Text('Visit a Mind Space to see it here',
              style: GoogleFonts.inter(
                  color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                  fontSize: 14)),
        ],
      ),
    );
  }
}


