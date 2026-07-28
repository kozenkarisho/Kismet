import '../theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/app_state.dart';

class SettingsScreen extends StatefulWidget {
  final AppState appState;

  const SettingsScreen({super.key, required this.appState});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = true;

  void _editProfile() {
    final controller = TextEditingController(text: widget.appState.userName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2113),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Edit Name',
            style: GoogleFonts.inter(color: const Color(0xFFE3E4CE), fontWeight: FontWeight.w700)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Color(0xFFE3E4CE)),
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Your name',
            hintStyle: const TextStyle(color: Color(0xFFC6C9AB)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0x0DFFFFFF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFDFFF00)),
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
              widget.appState.setUserName(controller.text.trim());
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDFFF00),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text('Save', style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w600)),
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
        final totalLinks = widget.appState.allLinks.length;
        final totalSpaces = widget.appState.spaces.length;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0D0F04) : const Color(0xFFF2F4F0),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? const Color(0xFF1F2113) : Colors.white,
                            border: Border.all(
                              color: isDark ? const Color(0x0DFFFFFF) : AppTheme.borderLight,
                            ),
                          ),
                          child: Icon(Icons.chevron_left,
                              color: isDark ? const Color(0xFFE3E4CE) : AppTheme.textMainLight,
                              size: 24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Settings',
                          style: GoogleFonts.inter(
                              color: isDark ? const Color(0xFFE3E4CE) : AppTheme.textMainLight,
                              fontWeight: FontWeight.w900,
                              fontSize: 30)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
                    children: [
                      // Profile card
                      GestureDetector(
                        onTap: _editProfile,
                        child: _settingsCard(
                          isDark,
                          child: Row(
                            children: [
                              Container(
                                width: 56, height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark ? const Color(0xFF1A1C10) : const Color(0xFFF7F9F4),
                                  border: Border.all(
                                    color: const Color(0xFFDFFF00).withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.appState.userName.isNotEmpty
                                        ? widget.appState.userName[0].toUpperCase()
                                        : 'U',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFDFFF00),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.appState.userName,
                                        style: GoogleFonts.inter(
                                            color: isDark ? const Color(0xFFE3E4CE) : AppTheme.textMainLight,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18)),
                                    Text('Tap to edit name',
                                        style: GoogleFonts.inter(
                                            color: isDark ? const Color(0xFFC6C9AB) : AppTheme.textMutedLight,
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                              Icon(Icons.edit_outlined,
                                  color: isDark ? const Color(0xFFC6C9AB) : AppTheme.textMutedLight,
                                  size: 18),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Stats card
                      _settingsCard(
                        isDark,
                        child: Row(
                          children: [
                            _statItem(isDark, label: 'Spaces', value: '$totalSpaces'),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.white.withOpacity(0.06),
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                            ),
                            _statItem(isDark, label: 'Links saved', value: '$totalLinks'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Dark mode toggle
                      _settingsCard(
                        isDark,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Dark Mode',
                                      style: GoogleFonts.inter(
                                          color: isDark ? const Color(0xFFE3E4CE) : AppTheme.textMainLight,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16)),
                                  Text('Switch between themes',
                                      style: GoogleFonts.inter(
                                          color: isDark ? const Color(0xFFC6C9AB) : AppTheme.textMutedLight,
                                          fontSize: 13)),
                                ],
                              ),
                            ),
                            Switch(
                              value: widget.appState.themeMode == ThemeMode.dark,
                              onChanged: (v) {
                                widget.appState.setThemeMode(v ? ThemeMode.dark : ThemeMode.light);
                              },
                              activeColor: const Color(0xFFDFFF00),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // About section
                      Text(
                        'ABOUT',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF555840),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _settingsCard(
                        isDark,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kismet',
                                style: GoogleFonts.inter(
                                    color: isDark ? const Color(0xFFE3E4CE) : AppTheme.textMainLight,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(
                              'Your AI-powered personal knowledge vault.\nPowered by Serenity + Google Gemini.',
                              style: GoogleFonts.inter(
                                  color: isDark ? const Color(0xFFC6C9AB) : AppTheme.textMutedLight,
                                  fontSize: 13,
                                  height: 1.5),
                            ),
                            const SizedBox(height: 12),
                            Text('v1.0.0',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF555840), fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _settingsCard(bool isDark, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2113) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0x0DFFFFFF) : AppTheme.borderLight,
        ),
      ),
      child: child,
    );
  }

  Widget _statItem(bool isDark, {required String label, required String value}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              color: isDark ? const Color(0xFFDFFF00) : const Color(0xFFB8D900),
              fontWeight: FontWeight.w800,
              fontSize: 28,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              color: isDark ? const Color(0xFFC6C9AB) : AppTheme.textMutedLight,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

