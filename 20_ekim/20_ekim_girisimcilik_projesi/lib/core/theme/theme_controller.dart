import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tema modunu yöneten saf ValueNotifier tabanlı reaktif controller.
/// Sayfa düzeyinde ağır setState çağrılarını engeller.
class ThemeController {
  static const String _prefKey = 'yorunge_theme_mode';

  final ValueNotifier<ThemeMode> themeMode;

  ThemeController([ThemeMode initialMode = ThemeMode.dark])
      : themeMode = ValueNotifier<ThemeMode>(initialMode) {
    _loadPreference();
  }

  bool get isDark => themeMode.value == ThemeMode.dark;

  void toggleTheme() {
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    themeMode.value = newMode;
    _savePreference(newMode);
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _savePreference(mode);
  }

  Future<void> _loadPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefKey);
      if (saved == 'light') {
        themeMode.value = ThemeMode.light;
      } else if (saved == 'dark') {
        themeMode.value = ThemeMode.dark;
      }
    } catch (_) {
      // SharedPreferences erişilemezse varsayılan koyu temayı koru
    }
  }

  Future<void> _savePreference(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _prefKey,
        mode == ThemeMode.light ? 'light' : 'dark',
      );
    } catch (_) {}
  }

  void dispose() {
    themeMode.dispose();
  }
}
