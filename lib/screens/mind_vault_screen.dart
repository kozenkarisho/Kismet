import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/patterns.dart';
import '../models/space_item.dart';
import '../services/app_state.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';
import 'space_detail_screen.dart';

class MindVaultScreen extends StatefulWidget {
  final AppState appState;
  final GeminiService geminiService;

  const MindVaultScreen({
    super.key,
    required this.appState,
    required this.geminiService,
  });

  @override
  State<MindVaultScreen> createState() => _MindVaultScreenState();
}

class _MindVaultScreenState extends State<MindVaultScreen> {
  bool _isEditing = false;

  Color _parseBannerColor(String? hex, Color fallback) {
    if (hex == null) return fallback;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return fallback;
    }
  }

  void _addNewSpace(bool isDark) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.cardBgDark : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: isDark ? const Color(0x0DFFFFFF) : AppTheme.borderLight),
        ),
        title: Text('New Space',
            style: GoogleFonts.inter(
                color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight, fontWeight: FontWeight.w700)),
        content: TextField(
          controller: controller,
          style: TextStyle(color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight),
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter space name...',
            hintStyle: TextStyle(color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: isDark ? const Color(0x0DFFFFFF) : AppTheme.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: isDark ? AppTheme.accentDark : AppTheme.accentLight),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.inter(color: const Color(0xFFC6C9AB))),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                widget.appState.addSpace(SpaceItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: name,
                  bannerType: 'color',
                  bannerValue: '#2A2D1A',
                ));
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppTheme.accentDark : AppTheme.accentLight,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Create',
                style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSpace(String id, String title, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.cardBgDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete "$title"?',
            style: GoogleFonts.inter(color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight, fontWeight: FontWeight.w700)),
        content: Text('All links in this space will also be deleted.',
            style: GoogleFonts.inter(color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.inter(color: const Color(0xFFC6C9AB))),
          ),
          ElevatedButton(
            onPressed: () {
              widget.appState.deleteSpace(id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Delete', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final spaces = widget.appState.spaces;

        return Scaffold(
          backgroundColor: isDark ? AppTheme.appBgDark : AppTheme.pageBgLight,
          body: SafeArea(
            child: Stack(
              children: [
                // Background glow
                Positioned(
                  top: -50, right: -50,
                  child: Container(
                    width: 300, height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFDFFF00).withOpacity(0.04),
                    ),
                  ),
                ),
                Column(
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
                                border: Border.all(color: isDark ? const Color(0x0DFFFFFF) : AppTheme.borderLight),
                              ),
                              child: Icon(Icons.chevron_left,
                                  color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight, size: 24),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('Mind Vault',
                              style: GoogleFonts.inter(
                                  color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => setState(() => _isEditing = !_isEditing),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: _isEditing ? (isDark ? AppTheme.accentDark : AppTheme.accentLight) : (isDark ? AppTheme.cardBgDark : Colors.white),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: isDark ? const Color(0x0DFFFFFF) : AppTheme.borderLight),
                              ),
                              child: Text(
                                _isEditing ? 'Done' : 'Edit',
                                style: GoogleFonts.inter(
                                  color: _isEditing ? Colors.black : (isDark ? AppTheme.textMainDark : AppTheme.textMainLight),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Spaces grid
                    Expanded(
                      child: spaces.isEmpty
                          ? _buildEmptyState(isDark)
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.6,
                              ),
                              itemCount: spaces.length,
                              itemBuilder: (context, index) {
                                final space = spaces[index];
                                return _buildSpaceCard(context, space, isDark);
                              },
                            ),
                    ),
                  ],
                ),

                // Permanent Add Space FAB
                  Positioned(
                    bottom: 32, right: 24,
                    child: GestureDetector(
                      onTap: () => _addNewSpace(isDark),
                      child: Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.accentDark : AppTheme.accentLight,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (isDark ? AppTheme.accentDark : AppTheme.accentLight).withOpacity(0.3),
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

  Widget _buildSpaceCard(BuildContext context, SpaceItem space, bool isDark) {
    final bannerColor = _parseBannerColor(space.bannerColor, const Color(0xFF2A2D1A));
    final linkCount = widget.appState.linksForSpace(space.id).length;

    return GestureDetector(
      onTap: _isEditing
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SpaceDetailScreen(
                    space: space,
                    appState: widget.appState,
                    geminiService: widget.geminiService,
                  ),
                ),
              ),
      onLongPress: _isEditing
          ? () => _confirmDeleteSpace(space.id, space.title, isDark)
          : null,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: space.bannerType == 'color' && space.bannerColor != null
                  ? bannerColor.withOpacity(0.18)
                  : (isDark ? AppTheme.cardBgDark : Colors.white),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: isDark ? const Color(0x0DFFFFFF) : AppTheme.borderLight),
            ),
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                if (space.bannerType == 'pattern' && space.bannerValue == 'dots')
                  PatternDots(color: Colors.white, opacity: 0.12),
                if (space.bannerType == 'pattern' && space.bannerValue == 'circles')
                  Positioned(
                    top: -24, left: -24,
                    child: SizedBox(
                      width: 100, height: 100,
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
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$linkCount link${linkCount == 1 ? '' : 's'}',
                          style: GoogleFonts.inter(
                            color: isDark ? AppTheme.textMutedDark.withOpacity(0.6) : AppTheme.textMutedLight,
                            fontSize: 12,
                          ),
                        ),
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            _isEditing ? Icons.delete_outline : Icons.north_east,
                            color: _isEditing
                                ? const Color(0xFFFF6B6B).withOpacity(0.7)
                                : (isDark ? AppTheme.textMainDark : AppTheme.textMainLight),
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Delete overlay when editing
          if (_isEditing)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _confirmDeleteSpace(space.id, space.title, isDark),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Center(
                    child: Icon(Icons.delete_outline, color: Color(0xFFFF6B6B), size: 28),
                  ),
                ),
              ),
            ),
        ],
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
            child: Icon(Icons.folder_open_outlined,
                color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight, size: 32),
          ),
          const SizedBox(height: 20),
          Text('No spaces yet',
              style: GoogleFonts.inter(
                  color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 18)),
          const SizedBox(height: 8),
          Text('Tap Edit → New Space to create\nyour first Mind Space',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight, fontSize: 14, height: 1.6)),
        ],
      ),
    );
  }
}

