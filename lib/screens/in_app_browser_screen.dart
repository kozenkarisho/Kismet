import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/app_theme.dart';

class InAppBrowserScreen extends StatefulWidget {
  final String url;
  final String? title;

  const InAppBrowserScreen({
    super.key,
    required this.url,
    this.title,
  });

  @override
  State<InAppBrowserScreen> createState() => _InAppBrowserScreenState();
}

class _InAppBrowserScreenState extends State<InAppBrowserScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _progress = 0.0;
  String _currentDomain = '';

  @override
  void initState() {
    super.initState();
    _currentDomain = _extractDomain(widget.url);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _currentDomain = _extractDomain(url);
              });
            }
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress / 100.0);
          },
        ),
      )
      ..loadRequest(Uri.parse(_ensureHttps(widget.url)));
  }

  String _ensureHttps(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    return url;
  }

  String _extractDomain(String url) {
    try {
      return Uri.parse(_ensureHttps(url)).host.replaceAll('www.', '');
    } catch (_) {
      return url;
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
            // ── Top bar ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.appBgDark : AppTheme.pageBgLight,
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : AppTheme.borderLight,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppTheme.cardBgDark : Colors.white,
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.07)
                              : AppTheme.borderLight,
                        ),
                      ),
                      child: Icon(
                        Icons.close,
                        color: isDark
                            ? AppTheme.textMainDark
                            : AppTheme.textMainLight,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Domain name + lock icon
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          color: isDark
                              ? AppTheme.textMutedDark
                              : AppTheme.textMutedLight,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            _currentDomain,
                            style: GoogleFonts.inter(
                              color: isDark
                                  ? AppTheme.textMutedDark
                                  : AppTheme.textMutedLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Refresh button
                  GestureDetector(
                    onTap: () => _controller.reload(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppTheme.cardBgDark : Colors.white,
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.07)
                              : AppTheme.borderLight,
                        ),
                      ),
                      child: Icon(
                        Icons.refresh,
                        color: isDark
                            ? AppTheme.textMainDark
                            : AppTheme.textMainLight,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Progress indicator ──────────────────────────────────
            if (_isLoading)
              LinearProgressIndicator(
                value: _progress > 0 ? _progress : null,
                backgroundColor: isDark
                    ? AppTheme.cardBgDark
                    : Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? AppTheme.accentDark : AppTheme.accentLight,
                ),
                minHeight: 2.5,
              ),

            // ── WebView ─────────────────────────────────────────────
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}
