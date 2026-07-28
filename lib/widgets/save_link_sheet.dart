import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/space_item.dart';
import '../services/app_state.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';

class SaveLinkSheet extends StatefulWidget {
  final AppState appState;
  final GeminiService geminiService;
  final String? preselectedSpaceId;
  final String? prefilledUrl;

  const SaveLinkSheet({
    super.key,
    required this.appState,
    required this.geminiService,
    this.preselectedSpaceId,
    this.prefilledUrl,
  });

  @override
  State<SaveLinkSheet> createState() => _SaveLinkSheetState();
}

class _SaveLinkSheetState extends State<SaveLinkSheet> {
  final _urlController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedSpaceId;
  bool _isSaving = false;
  String? _urlError;

  @override
  void initState() {
    super.initState();
    _selectedSpaceId = widget.preselectedSpaceId ?? widget.appState.spaces.firstOrNull?.id;
    if (widget.prefilledUrl != null) {
      _urlController.text = widget.prefilledUrl!;
    } else {
      _tryPasteFromClipboard();
    }
  }

  Future<void> _tryPasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      final text = data!.text!.trim();
      if (text.startsWith('http://') || text.startsWith('https://')) {
        setState(() => _urlController.text = text);
      }
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool _isValidUrl(String url) {
    return url.trim().startsWith('http://') || url.trim().startsWith('https://');
  }

  String _extractTitle(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceAll('www.', '');
    } catch (_) {
      return url;
    }
  }

  Future<void> _save() async {
    final url = _urlController.text.trim();
    if (!_isValidUrl(url)) {
      setState(() => _urlError = 'Please enter a valid URL (starting with http:// or https://)');
      return;
    }
    if (_selectedSpaceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Mind Space')),
      );
      return;
    }

    setState(() { _isSaving = true; _urlError = null; });

    try {
      // Generate AI summary + tags
      final enriched = await widget.geminiService.enrichLink(
        url: url,
        title: _extractTitle(url),
        note: _noteController.text.trim(),
      );

      final link = LinkItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _extractTitle(url),
        url: url,
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        summary: enriched.summary,
        keywords: enriched.tags,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      await widget.appState.addLink(_selectedSpaceId!, link);

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving link: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final spaces = widget.appState.spaces;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.vaultBgDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Save a Link',
                    style: GoogleFonts.inter(
                      color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Serenity will summarize it for you ✨',
                    style: GoogleFonts.inter(
                      color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // URL Field
                  _label('URL', isDark),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _urlController,
                    style: GoogleFonts.inter(
                        color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight, 
                        fontSize: 15),
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    onChanged: (_) { if (_urlError != null) setState(() => _urlError = null); },
                    decoration: _inputDecoration(
                      hint: 'https://',
                      prefixIcon: Icon(Icons.link, color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight, size: 18),
                      errorText: _urlError,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Note Field
                  _label('Personal Note (optional)', isDark),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    style: GoogleFonts.inter(
                        color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight, 
                        fontSize: 15),
                    maxLines: 3,
                    decoration: _inputDecoration(hint: 'What caught your eye?', isDark: isDark),
                  ),
                  const SizedBox(height: 24),

                  // Space Selector
                  _label('Mind Space', isDark),
                  const SizedBox(height: 12),
                  if (spaces.isEmpty)
                    Text(
                      'No spaces yet. Create one in Mind Vault.',
                      style: GoogleFonts.inter(
                          color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight, 
                          fontSize: 14),
                    )
                  else
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: spaces.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final space = spaces[index];
                          final isSelected = space.id == _selectedSpaceId;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedSpaceId = space.id),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDark ? AppTheme.accentDark : AppTheme.accentLight)
                                    : (isDark ? AppTheme.cardBgDark : Colors.white),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: isSelected
                                      ? (isDark ? AppTheme.accentDark : AppTheme.accentLight)
                                      : (isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderLight),
                                ),
                              ),
                              child: Text(
                                space.title,
                                style: GoogleFonts.inter(
                                  color: isSelected ? Colors.black : (isDark ? AppTheme.textMutedDark : AppTheme.textMainLight),
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppTheme.accentDark : AppTheme.accentLight,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: (isDark ? AppTheme.accentDark : AppTheme.accentLight).withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Serenity is summarizing...',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Save to Vault',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Colors.black,
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
    );
  }

  Widget _label(String text, bool isDark) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
        fontWeight: FontWeight.w600,
        fontSize: 13,
        letterSpacing: 0.5,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    Widget? prefixIcon,
    String? errorText,
    required bool isDark,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: isDark ? const Color(0xFF555840) : AppTheme.textMutedLight, fontSize: 15),
      prefixIcon: prefixIcon,
      errorText: errorText,
      errorStyle: GoogleFonts.inter(color: const Color(0xFFFF6B6B), fontSize: 12),
      filled: true,
      fillColor: isDark ? AppTheme.cardBgDark : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: isDark ? Colors.white.withOpacity(0.07) : AppTheme.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: isDark ? AppTheme.accentDark : AppTheme.accentLight, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
      ),
    );
  }
}

