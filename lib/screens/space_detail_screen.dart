import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/space_item.dart';
import '../services/app_state.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';
import '../utils/time_utils.dart';
import '../widgets/edit_space_sheet.dart';
import '../widgets/patterns.dart';
import '../widgets/save_link_sheet.dart';
import 'in_app_browser_screen.dart';

class SpaceDetailScreen extends StatefulWidget {
  final SpaceItem space;
  final AppState appState;
  final GeminiService geminiService;

  const SpaceDetailScreen({
    super.key,
    required this.space,
    required this.appState,
    required this.geminiService,
  });

  @override
  State<SpaceDetailScreen> createState() => _SpaceDetailScreenState();
}

class _SpaceDetailScreenState extends State<SpaceDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Defer until after the first frame so notifyListeners()
    // doesn't fire during the build phase.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appState.recordSpaceVisit(widget.space.id);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _parseBannerColor(String? hex, Color fallback) {
    if (hex == null) return fallback;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return fallback;
    }
  }

  void _openInAppBrowser(LinkItem link) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InAppBrowserScreen(
          url: link.url,
          title: link.title,
        ),
      ),
    );
  }

  void _openSaveLinkSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SaveLinkSheet(
        appState: widget.appState,
        geminiService: widget.geminiService,
        preselectedSpaceId: widget.space.id,
      ),
    );
  }

  void _openEditSpaceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditSpaceSheet(
        appState: widget.appState,
        space: widget.appState.spaces.firstWhere(
          (s) => s.id == widget.space.id,
          orElse: () => widget.space,
        ),
      ),
    );
  }

  void _confirmDeleteLink(String linkId, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.cardBgDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Link?',
          style: GoogleFonts.inter(
            color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'This link will be removed from your vault.',
          style: GoogleFonts.inter(
            color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.appState.deleteLink(widget.space.id, linkId);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<LinkItem> _filteredLinks(List<LinkItem> links) {
    if (_searchQuery.isEmpty) return links;
    final q = _searchQuery.toLowerCase();
    return links.where((link) {
      final title = link.title.toLowerCase();
      final url = link.url.toLowerCase();
      final note = (link.note ?? '').toLowerCase();
      final keywords = (link.keywords ?? []).join(' ').toLowerCase();
      return title.contains(q) ||
          url.contains(q) ||
          note.contains(q) ||
          keywords.contains(q);
    }).toList();
  }

  String _extractDomain(String url) {
    try {
      return Uri.parse(url).host.replaceAll('www.', '');
    } catch (_) {
      return url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        // Fetch the space from AppState so it updates when edited
        final currentSpace = widget.appState.spaces.firstWhere(
          (s) => s.id == widget.space.id,
          orElse: () => widget.space,
        );

        final allLinks = widget.appState.linksForSpace(currentSpace.id);
        final links = _filteredLinks(allLinks);
        final bannerColor =
            _parseBannerColor(currentSpace.bannerColor, const Color(0xFF2A2D1A));

        return Scaffold(
          backgroundColor: isDark ? AppTheme.appBgDark : AppTheme.pageBgLight,
          body: Stack(
            children: [
              // Banner header
              _buildBannerHeader(currentSpace, bannerColor, isDark),

              SafeArea(
                child: Column(
                  children: [
                    // Top nav bar (transparent, over banner)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.3),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.15),
                                ),
                              ),
                              child: const Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _openEditSpaceSheet,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.15),
                                ),
                              ),
                              child: Text(
                                'Edit Space',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 80),

                    // Main content card
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTheme.appBgDark
                              : AppTheme.pageBgLight,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Space title + count
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(24, 24, 24, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      currentSpace.title,
                                      style: GoogleFonts.inter(
                                        color: isDark
                                            ? AppTheme.textMainDark
                                            : AppTheme.textMainLight,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 28,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppTheme.cardBgDark
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.white.withOpacity(0.07)
                                            : AppTheme.borderLight,
                                      ),
                                    ),
                                    child: Text(
                                      '${allLinks.length} link${allLinks.length == 1 ? '' : 's'}',
                                      style: GoogleFonts.inter(
                                        color: isDark
                                            ? AppTheme.textMutedDark
                                            : AppTheme.textMutedLight,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ── Search bar ───────────────────────────
                            if (allLinks.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20, 16, 20, 4),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (val) =>
                                      setState(() => _searchQuery = val),
                                  style: GoogleFonts.inter(
                                    color: isDark
                                        ? AppTheme.textMainDark
                                        : AppTheme.textMainLight,
                                    fontSize: 15,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search links...',
                                    hintStyle: GoogleFonts.inter(
                                      color: isDark
                                          ? const Color(0xFF555840)
                                          : AppTheme.textMutedLight,
                                      fontSize: 15,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: isDark
                                          ? AppTheme.textMutedDark
                                          : AppTheme.textMutedLight,
                                      size: 20,
                                    ),
                                    suffixIcon: _searchQuery.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              _searchController.clear();
                                              setState(
                                                  () => _searchQuery = '');
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: isDark
                                                  ? AppTheme.textMutedDark
                                                  : AppTheme.textMutedLight,
                                              size: 18,
                                            ),
                                          )
                                        : null,
                                    filled: true,
                                    fillColor: isDark
                                        ? AppTheme.cardBgDark
                                        : Colors.white,
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: isDark
                                            ? Colors.white.withOpacity(0.07)
                                            : AppTheme.borderLight,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: isDark
                                            ? AppTheme.accentDark
                                            : AppTheme.accentLight,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            // ── Links list ───────────────────────────
                            Expanded(
                              child: allLinks.isEmpty
                                  ? _buildEmptyState(isDark)
                                  : links.isEmpty
                                      ? _buildNoResultsState(isDark)
                                      : ListView.separated(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 16, 20, 100),
                                          itemCount: links.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 12),
                                          itemBuilder: (context, index) {
                                            return _buildLinkCard(
                                              links[index],
                                              isDark,
                                            );
                                          },
                                        ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // FAB to save link
              Positioned(
                bottom: 32,
                right: 24,
                child: GestureDetector(
                  onTap: _openSaveLinkSheet,
                  child: Container(
                    width: 60,
                    height: 60,
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
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Banner header ──────────────────────────────────────────────────────────

  Widget _buildBannerHeader(
    SpaceItem currentSpace,
    Color bannerColor,
    bool isDark,
  ) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: bannerColor.withOpacity(0.8),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  bannerColor.withOpacity(0.9),
                  bannerColor.withOpacity(0.5),
                ],
              ),
            ),
          ),
          if (currentSpace.bannerType == 'pattern' &&
              currentSpace.bannerValue == 'dots')
            PatternDots(color: Colors.white, opacity: 0.15),
          if (currentSpace.bannerType == 'pattern' &&
              currentSpace.bannerValue == 'circles')
            ConcentricCircles(color: Colors.white, opacity: 0.1),
          // Fade to background color at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    isDark ? AppTheme.appBgDark : AppTheme.pageBgLight,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardBgDark : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.07)
                      : AppTheme.borderLight,
                ),
              ),
              child: Icon(
                Icons.link_off,
                color: isDark
                    ? AppTheme.textMutedDark
                    : AppTheme.textMutedLight,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Nothing saved yet',
              style: GoogleFonts.inter(
                color:
                    isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to save your first link\nto this space',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color:
                    isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── No search results ──────────────────────────────────────────────────────

  Widget _buildNoResultsState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
            size: 40,
          ),
          const SizedBox(height: 16),
          Text(
            'No links match your search',
            style: GoogleFonts.inter(
              color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Link card ──────────────────────────────────────────────────────────────

  Widget _buildLinkCard(LinkItem link, bool isDark) {
    final domain = _extractDomain(link.url);
    final hasAiKeywords =
        link.keywords != null && link.keywords!.isNotEmpty;
    final savedTime = timeAgo(link.timestamp);

    return Dismissible(
      key: Key(link.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        _confirmDeleteLink(link.id, isDark);
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B6B).withOpacity(0.15),
          borderRadius: BorderRadius.circular(32),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Color(0xFFFF6B6B),
          size: 24,
        ),
      ),
      child: GestureDetector(
        onTap: () => _openInAppBrowser(link),
        onLongPress: () {
          HapticFeedback.mediumImpact();
          _confirmDeleteLink(link.id, isDark);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardBgDark : Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : AppTheme.borderLight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Row 1: favicon + title + AI dot ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Favicon
                  Container(
                    width: 28,
                    height: 28,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppTheme.appBgDark
                          : Colors.grey.shade100,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://www.google.com/s2/favicons?domain=$domain&sz=64',
                        width: 28,
                        height: 28,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.language,
                          size: 16,
                          color: isDark
                              ? AppTheme.textMutedDark
                              : AppTheme.textMutedLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title
                  Expanded(
                    child: Text(
                      link.title,
                      style: GoogleFonts.inter(
                        color: isDark
                            ? AppTheme.textMainDark
                            : AppTheme.textMainLight,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // AI-processed dot
                  if (hasAiKeywords)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6, left: 8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFDFFF00),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // ── Row 2: domain + time saved ──
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        domain,
                        style: GoogleFonts.inter(
                          color: isDark
                              ? AppTheme.textMutedDark
                              : AppTheme.textMutedLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (savedTime.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          '\u00B7',
                          style: GoogleFonts.inter(
                            color: isDark
                                ? AppTheme.textMutedDark.withOpacity(0.5)
                                : AppTheme.textMutedLight.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        savedTime,
                        style: GoogleFonts.inter(
                          color: isDark
                              ? AppTheme.textMutedDark
                              : AppTheme.textMutedLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ── Personal note ──
              if (link.note != null && link.note!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 8),
                  child: Text(
                    '"${link.note!}"',
                    style: GoogleFonts.inter(
                      color: isDark
                          ? AppTheme.textMutedDark
                          : AppTheme.textMutedLight,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
