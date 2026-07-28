import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/space_item.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import 'patterns.dart';

class EditSpaceSheet extends StatefulWidget {
  final AppState appState;
  final SpaceItem space;

  const EditSpaceSheet({
    super.key,
    required this.appState,
    required this.space,
  });

  @override
  State<EditSpaceSheet> createState() => _EditSpaceSheetState();
}

class _EditSpaceSheetState extends State<EditSpaceSheet> {
  late TextEditingController _titleController;
  late String _bannerType;
  late String _bannerValue;
  late String _bannerColor;

  final List<String> _colors = [
    '#2A2D1A', // Default dark greenish
    '#3B1F2B', // Burgundy
    '#1A2B3C', // Deep Blue
    '#3C2A1A', // Brown/Orange
    '#1A3C2B', // Forest Green
    '#2B1A3C', // Deep Purple
    '#3A3B1F', // Olive
    '#1F3A3B', // Teal
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.space.title);
    _bannerType = widget.space.bannerType;
    _bannerValue = widget.space.bannerValue ?? '';
    _bannerColor = widget.space.bannerColor ?? '#2A2D1A';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _save() {
    widget.appState.updateSpaceBanner(
      widget.space.id,
      title: _titleController.text.trim().isEmpty ? widget.space.title : _titleController.text.trim(),
      bannerType: _bannerType,
      bannerValue: _bannerValue,
      bannerColor: _bannerColor,
    );
    Navigator.pop(context);
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF2A2D1A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.appBgDark : AppTheme.pageBgLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInsets),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Space',
                  style: GoogleFonts.inter(
                    color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.cardBgDark : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: isDark ? const Color(0x0DFFFFFF) : AppTheme.borderLight),
                    ),
                    child: Icon(Icons.close, color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Name
            Text(
              'NAME',
              style: GoogleFonts.inter(
                color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: TextStyle(color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight),
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AppTheme.cardBgDark : Colors.white,
                hintText: 'Space Name',
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
            const SizedBox(height: 24),

            // Banner Type
            Text(
              'BANNER STYLE',
              style: GoogleFonts.inter(
                color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildChoiceChip('Solid Color', _bannerType == 'color', () {
                    setState(() {
                      _bannerType = 'color';
                      _bannerValue = _bannerColor;
                    });
                  }, isDark),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildChoiceChip('Pattern', _bannerType == 'pattern', () {
                    setState(() {
                      _bannerType = 'pattern';
                      if (_bannerValue != 'dots' && _bannerValue != 'circles') {
                        _bannerValue = 'dots';
                      }
                    });
                  }, isDark),
                ),
              ],
            ),
            
            // Pattern Selection
            if (_bannerType == 'pattern') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildPatternPreview('Dots', 'dots', isDark),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPatternPreview('Circles', 'circles', isDark),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Color Selection
            Text(
              'COLOR',
              style: GoogleFonts.inter(
                color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _colors.map((hex) => _buildColorPicker(hex, isDark)).toList(),
            ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppTheme.accentDark : AppTheme.accentLight,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? (isDark ? AppTheme.accentDark : AppTheme.accentLight).withOpacity(0.15) : (isDark ? AppTheme.cardBgDark : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? (isDark ? AppTheme.accentDark : AppTheme.accentLight) : (isDark ? const Color(0x0DFFFFFF) : AppTheme.borderLight),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? (isDark ? AppTheme.accentDark : AppTheme.accentLight) : (isDark ? AppTheme.textMainDark : AppTheme.textMainLight),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPatternPreview(String label, String value, bool isDark) {
    final isSelected = _bannerValue == value;
    final bgColor = _parseColor(_bannerColor);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _bannerValue = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 60,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? (isDark ? AppTheme.accentDark : AppTheme.accentLight) : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
        ),
        child: Stack(
          children: [
            if (value == 'dots') PatternDots(color: Colors.white, opacity: 0.15),
            if (value == 'circles') ConcentricCircles(color: Colors.white, opacity: 0.1),
            Center(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(String hex, bool isDark) {
    final isSelected = _bannerColor == hex;
    final color = _parseColor(hex);

    return GestureDetector(
      onTap: () {
        setState(() {
          _bannerColor = hex;
          if (_bannerType == 'color') {
            _bannerValue = hex;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? (isDark ? AppTheme.accentDark : AppTheme.accentLight) : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: (isDark ? AppTheme.accentDark : AppTheme.accentLight).withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
          ],
        ),
      ),
    );
  }
}

