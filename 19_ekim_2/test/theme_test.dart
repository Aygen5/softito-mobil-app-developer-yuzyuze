import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/core/theme/theme_controller.dart';

void main() {
  group('ThemeController Tests', () {
    late ThemeController controller;

    setUp(() {
      controller = ThemeController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial theme mode is dark mode', () {
      expect(controller.themeMode, equals(ThemeMode.dark));
      expect(controller.isDarkMode, isTrue);
    });

    test('toggleTheme toggles between dark and light modes', () {
      controller.toggleTheme();
      expect(controller.themeMode, equals(ThemeMode.light));
      expect(controller.isDarkMode, isFalse);

      controller.toggleTheme();
      expect(controller.themeMode, equals(ThemeMode.dark));
      expect(controller.isDarkMode, isTrue);
    });

    test('setThemeMode sets the specific theme mode correctly', () {
      controller.setThemeMode(ThemeMode.light);
      expect(controller.themeMode, equals(ThemeMode.light));

      controller.setThemeMode(ThemeMode.system);
      expect(controller.themeMode, equals(ThemeMode.system));
    });
  });
}
