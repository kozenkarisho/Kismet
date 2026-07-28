import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/space_item.dart';
import '../services/app_state.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';

class SearchOverlay extends StatefulWidget {
  final AppState appState;
  final GeminiService geminiService;

  const SearchOverlay({
    super.key,
    required this.appState,
    required this.geminiService,
  });

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  List<({LinkItem link, SpaceItem space})> _results = [];
  List<LinkItem> _aiResults = [];
  bool _isAiSearching = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _animController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    final query = _controller.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() { _results = []; _hasSearched = false; });
      return;
    }
    _localSearch(query);
  }

  void _localSearch(String query) {
    final allLinks = widget.appState.allLinks;
    final spaces = widget.appState.spaces;

    final filtered = <({LinkItem link, SpaceItem space})>[];
    for (final link in allLinks) {
      final matchTitle = link.title.toLowerCase().contains(query);
      final matchSummary = link.summary?.toLowerCase().contains(query) ?? false;
      final matchNote = link.note?.toLowerCase().contains(query) ?? false;
      final matchTags = link.keywords?.any((k) => k.toLowerCase().contains(query)) ?? false;
      final matchUrl = link.url.toLowerCase().contains(query);

      if (matchTitle || matchSummary || matchNote || matchTags || matchUrl) {
        // Find which space this link belongs to
        for (final space in spaces) {
          final spaceLinks = widget.appState.linksForSpace(space.id);
          if (spaceLinks.any((l) => l.id == link.id)) {
            filtered.add((link: link, space: space));
            break;
          }
        }
      }
    }

    setState(() { _results = filtered; _hasSearched = true; });
  }

  Future<void> _askSerenity() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() { _isAiSearching = true; });
    final allLinks = widget.appState.allLinks;
    final results = await widget.geminiService.searchSemantically(
      query: query,
      allLinks: allLinks,
    );
    setState(() { _aiResults = results; _isAiSearching = false; });
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeAnim,
      child: Scaffold(
        backgroundColor: isDark ? AppTheme.appBgDark : AppTheme.pageBgLight,
        body: SafeArea(
          child: Column(
            children: [
              // Search bar row
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.cardBgDark : Colors.white,
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                              color: isDark ? AppTheme.accentDark : AppTheme.accentLight, 
                              width: 1.5),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: isDark ? AppTheme.accentDark : AppTheme.accentLight, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                autofocus: true,
                                style: GoogleFonts.inter(
                                  color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                                  fontSize: 15,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search or ask Serenity...',
                                  hintStyle: GoogleFonts.inter(
                                    color: isDark ? const Color(0xFF555840) : AppTheme.textMutedLight,
                                    fontSize: 15,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                                onSubmitted: (_) => _askSerenity(),
                              ),
                            ),
                            if (_controller.text.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _controller.clear();
                                  setState(() { _results = []; _aiResults = []; _hasSearched = false; });
                                },
                                child: Icon(Icons.close, color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight, size: 18),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Ask Serenity AI button
              if (_controller.text.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: GestureDetector(
                    onTap: _isAiSearching ? null : _askSerenity,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.cardBgDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: (isDark ? AppTheme.accentDark : AppTheme.accentLight).withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.auto_awesome, color: isDark ? AppTheme.accentDark : AppTheme.accentLight, size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _isAiSearching ? 'Serenity is thinking...' : 'Ask Serenity: "${_controller.text.trim()}"',
                              style: GoogleFonts.inter(
                                color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_isAiSearching)
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 1.5, color: isDark ? AppTheme.accentDark : AppTheme.accentLight),
                            )
                          else
                            Icon(Icons.north_east, color: isDark ? AppTheme.accentDark : AppTheme.accentLight, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              // Results
              Expanded(
                child: _buildResults(isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(bool isDark) {
    if (!_hasSearched && _controller.text.isEmpty) {
      return _buildEmptyHint(isDark);
    }

    // AI results section
    final hasAiResults = _aiResults.isNotEmpty;

    if (_results.isEmpty && !hasAiResults && _hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, color: Color(0xFF555840), size: 48),
            const SizedBox(height: 16),
            Text(
              'Nothing found',
              style: GoogleFonts.inter(color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight, fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Try asking Serenity above for a\nsemantic search across your vault',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight, fontSize: 14, height: 1.5),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      children: [
        if (hasAiResults) ...[
          _sectionHeader('Serenity found', isDark: isDark, icon: Icons.auto_awesome),
          ...(_aiResults.map((link) {
            // Find the space for this link
            SpaceItem? space;
            for (final s in widget.appState.spaces) {
              if (widget.appState.linksForSpace(s.id).any((l) => l.id == link.id)) {
                space = s;
                break;
              }
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildResultCard(link, space, isDark),
            );
          })),
          const SizedBox(height: 16),
        ],
        if (_results.isNotEmpty) ...[
          _sectionHeader('In your vault', count: _results.length, isDark: isDark),
          ...(_results.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildResultCard(r.link, r.space, isDark),
              ))),
        ],
      ],
    );
  }

  Widget _buildEmptyHint(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isDark ? AppTheme.cardBgDark : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.07) : AppTheme.borderLight),
            ),
            child: Icon(Icons.search, color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight, size: 30),
          ),
          const SizedBox(height: 20),
          Text(
            'Search your vault',
            style: GoogleFonts.inter(
              color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Or ask Serenity anything\nabout your saved links',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight, fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, {int? count, IconData? icon, required bool isDark}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, color: isDark ? AppTheme.accentDark : AppTheme.accentLight, size: 14), const SizedBox(width: 6)],
          Text(
            count != null ? '$title ($count)' : title,
            style: GoogleFonts.inter(
              color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(LinkItem link, SpaceItem? space, bool isDark) {
    String domain = '';
    try { domain = Uri.parse(link.url).host.replaceAll('www.', ''); } catch (_) {}

    return GestureDetector(
      onTap: () => _openLink(link.url),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.vaultBgDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? Colors.white.withOpacity(0.06) : AppTheme.borderLight),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (space != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (isDark ? AppTheme.accentDark : AppTheme.accentLight).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      space.title,
                      style: GoogleFonts.inter(color: isDark ? AppTheme.accentDark : AppTheme.accentLight, fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    domain,
                    style: GoogleFonts.inter(color: isDark ? const Color(0xFF555840) : AppTheme.textMutedLight, fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.north_east, color: isDark ? const Color(0xFF555840) : AppTheme.textMutedLight, size: 14),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              link.title,
              style: GoogleFonts.inter(
                color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (link.summary != null && link.summary!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                link.summary!,
                style: GoogleFonts.inter(color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight, fontSize: 12, height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

