import 'package:flutter/material.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController({ThemeMode initialMode = ThemeMode.light}) : super(initialMode);

  bool get isDarkMode => value == ThemeMode.dark;

  void toggleTheme() {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void setTheme(ThemeMode mode) {
    if (value != mode) {
      value = mode;
    }
  }
}

// Global tema kontrolcüsü
final ThemeController themeController = ThemeController();
