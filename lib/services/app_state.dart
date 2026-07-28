import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/space_item.dart';

class AppState extends ChangeNotifier {
  static const _spacesKey = 'kismet_spaces';
  static const _linksKey = 'kismet_links';
  static const _userNameKey = 'kismet_username';
  static const _recentSpacesKey = 'kismet_recent_spaces';
  static const _themeModeKey = 'kismet_theme_mode';

  List<SpaceItem> _spaces = [];
  Map<String, List<LinkItem>> _links = {};
  String _userName = 'User';
  List<String> _recentSpaceIds = [];
  ThemeMode _themeMode = ThemeMode.dark;

  List<SpaceItem> get spaces => List.unmodifiable(_spaces);
  Map<String, List<LinkItem>> get links => Map.unmodifiable(_links);
  String get userName => _userName;
  List<String> get recentSpaceIds => List.unmodifiable(_recentSpaceIds);
  ThemeMode get themeMode => _themeMode;

  List<SpaceItem> get recentSpaces {
    return _recentSpaceIds
        .map((id) {
          try {
            return _spaces.firstWhere((s) => s.id == id);
          } catch (_) {
            return null;
          }
        })
        .whereType<SpaceItem>()
        .toList();
  }

  List<LinkItem> linksForSpace(String spaceId) {
    return List.unmodifiable(_links[spaceId] ?? []);
  }

  /// All links across all spaces — used for search
  List<LinkItem> get allLinks {
    return _links.values.expand((list) => list).toList();
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    _userName = prefs.getString(_userNameKey) ?? 'User';
    
    final themeStr = prefs.getString(_themeModeKey);
    if (themeStr == 'light') _themeMode = ThemeMode.light;
    else if (themeStr == 'dark') _themeMode = ThemeMode.dark;
    else if (themeStr == 'system') _themeMode = ThemeMode.system;

    final spacesJson = prefs.getString(_spacesKey);
    if (spacesJson != null) {
      final List<dynamic> decoded = jsonDecode(spacesJson);
      _spaces = decoded.map((e) => SpaceItem.fromJson(e)).toList();
    } else {
      // Default spaces on first launch
      _spaces = [
        SpaceItem(id: '1', title: 'Movies', bannerType: 'color', bannerValue: '#3B4CC0'),
        SpaceItem(id: '2', title: 'Recipes', bannerType: 'pattern', bannerValue: 'dots', bannerColor: '#f87171'),
        SpaceItem(id: '3', title: 'Education', bannerType: 'color', bannerValue: '#22C55E'),
        SpaceItem(id: '4', title: 'Religion', bannerType: 'pattern', bannerValue: 'circles', bannerColor: '#60a5fa'),
        SpaceItem(id: '5', title: 'Memes', bannerType: 'color', bannerValue: '#A855F7'),
        SpaceItem(id: '6', title: 'Songs', bannerType: 'pattern', bannerValue: 'dots', bannerColor: '#fbbf24'),
      ];
    }

    final linksJson = prefs.getString(_linksKey);
    if (linksJson != null) {
      final Map<String, dynamic> decoded = jsonDecode(linksJson);
      _links = decoded.map((key, value) {
        final List<dynamic> list = value;
        return MapEntry(key, list.map((e) => LinkItem.fromJson(e)).toList());
      });
    }

    _recentSpaceIds = prefs.getStringList(_recentSpacesKey) ?? [];

    notifyListeners();
  }

  // ─── Spaces ────────────────────────────────────────────────────────────────

  Future<void> addSpace(SpaceItem space) async {
    _spaces.add(space);
    await _saveSpaces();
    notifyListeners();
  }

  Future<void> deleteSpace(String id) async {
    _spaces.removeWhere((s) => s.id == id);
    _links.remove(id);
    _recentSpaceIds.remove(id);
    await _saveSpaces();
    await _saveLinks();
    await _saveRecentSpaces();
    notifyListeners();
  }

  Future<void> renameSpace(String id, String newTitle) async {
    final index = _spaces.indexWhere((s) => s.id == id);
    if (index == -1) return;
    final old = _spaces[index];
    _spaces[index] = SpaceItem(
      id: old.id,
      title: newTitle,
      bannerType: old.bannerType,
      bannerValue: old.bannerValue,
      bannerColor: old.bannerColor,
    );
    await _saveSpaces();
    notifyListeners();
  }

  Future<void> updateSpaceBanner(
    String id, {
    String? title,
    String? bannerType,
    String? bannerValue,
    String? bannerColor,
  }) async {
    final index = _spaces.indexWhere((s) => s.id == id);
    if (index == -1) return;
    final old = _spaces[index];
    _spaces[index] = SpaceItem(
      id: old.id,
      title: title ?? old.title,
      bannerType: bannerType ?? old.bannerType,
      bannerValue: bannerValue ?? old.bannerValue,
      bannerColor: bannerColor ?? old.bannerColor,
    );
    await _saveSpaces();
    notifyListeners();
  }

  void recordSpaceVisit(String spaceId) {
    _recentSpaceIds.remove(spaceId);
    _recentSpaceIds.insert(0, spaceId);
    if (_recentSpaceIds.length > 10) {
      _recentSpaceIds = _recentSpaceIds.take(10).toList();
    }
    _saveRecentSpaces();
    notifyListeners();
  }

  // ─── Links ─────────────────────────────────────────────────────────────────

  Future<void> addLink(String spaceId, LinkItem link) async {
    _links.putIfAbsent(spaceId, () => []);
    _links[spaceId]!.insert(0, link);
    await _saveLinks();
    notifyListeners();
  }

  Future<void> deleteLink(String spaceId, String linkId) async {
    _links[spaceId]?.removeWhere((l) => l.id == linkId);
    await _saveLinks();
    notifyListeners();
  }

  Future<void> updateLink(String spaceId, LinkItem updated) async {
    final list = _links[spaceId];
    if (list == null) return;
    final idx = list.indexWhere((l) => l.id == updated.id);
    if (idx != -1) list[idx] = updated;
    await _saveLinks();
    notifyListeners();
  }

  // ─── User ──────────────────────────────────────────────────────────────────

  Future<void> setUserName(String name) async {
    _userName = name.isEmpty ? 'User' : name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, _userName);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    String val = 'dark';
    if (mode == ThemeMode.light) val = 'light';
    if (mode == ThemeMode.system) val = 'system';
    await prefs.setString(_themeModeKey, val);
    notifyListeners();
  }

  // ─── Persistence ───────────────────────────────────────────────────────────

  Future<void> _saveSpaces() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _spacesKey,
      jsonEncode(_spaces.map((s) => s.toJson()).toList()),
    );
  }

  Future<void> _saveLinks() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _links.map(
      (key, value) => MapEntry(key, value.map((l) => l.toJson()).toList()),
    );
    await prefs.setString(_linksKey, jsonEncode(encoded));
  }

  Future<void> _saveRecentSpaces() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentSpacesKey, _recentSpaceIds);
  }
}
