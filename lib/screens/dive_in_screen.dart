import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/app_state.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';

class DiveInScreen extends StatefulWidget {
  final AppState appState;
  final GeminiService geminiService;

  const DiveInScreen({
    super.key,
    required this.appState,
    required this.geminiService,
  });

  @override
  State<DiveInScreen> createState() => _DiveInScreenState();
}

class _DiveInScreenState extends State<DiveInScreen> {
  List<Map<String, String>> _insights = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    setState(() => _isLoading = true);
    final allLinks = widget.appState.allLinks;
    final insights = await widget.geminiService.generateDiveInInsights(allLinks: allLinks);
    if (mounted) {
      setState(() {
        _insights = insights;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.appBgDark : AppTheme.pageBgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                  Text('Dive In',
                      style: GoogleFonts.inter(
                          color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                          fontWeight: FontWeight.w900,
                          fontSize: 30)),
                  const Spacer(),
                  GestureDetector(
                    onTap: _isLoading ? null : _loadInsights,
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppTheme.cardBgDark : Colors.white,
                        border: Border.all(
                          color: isDark ? const Color(0x0DFFFFFF) : AppTheme.borderLight,
                        ),
                      ),
                      child: _isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: isDark ? AppTheme.accentDark : AppTheme.accentLight,
                              ),
                            )
                          : Icon(Icons.refresh,
                              color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                              size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Subheading
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: isDark ? AppTheme.accentDark : AppTheme.accentLight, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    'Serenity\'s insights from your vault',
                    style: GoogleFonts.inter(
                      color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Insights grid
            Expanded(
              child: _isLoading
                  ? _buildLoadingState(isDark)
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: _insights.length,
                      itemBuilder: (context, index) {
                        return _buildInsightCard(_insights[index], isDark, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 0.85,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
      children: List.generate(6, (index) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardBgDark : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isDark ? Colors.white.withOpacity(0.06) : AppTheme.borderLight),
          ),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: isDark ? AppTheme.accentDark : AppTheme.accentLight,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInsightCard(Map<String, String> insight, bool isDark, int index) {
    // Alternate between two subtle accent colors
    final isAccented = index % 3 == 0;

    return Container(
      decoration: BoxDecoration(
        color: isAccented
            ? (isDark ? AppTheme.accentDark : AppTheme.accentLight).withOpacity(0.06)
            : isDark ? AppTheme.vaultBgDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isAccented
              ? (isDark ? AppTheme.accentDark : AppTheme.accentLight).withOpacity(0.15)
              : (isDark ? Colors.white.withOpacity(0.06) : AppTheme.borderLight),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            insight['emoji'] ?? '💡',
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 12),
          Text(
            insight['title'] ?? '',
            style: GoogleFonts.inter(
              color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              insight['insight'] ?? '',
              style: GoogleFonts.inter(
                color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                fontSize: 12,
                height: 1.5,
              ),
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }
}


