import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yorunge/core/theme/theme_controller.dart';

void main() {
  group('ThemeController Tests', () {
    late ThemeController controller;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      controller = ThemeController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Varsayılan tema Derin Uzay (ThemeMode.dark) olarak başlar', () {
      expect(controller.themeMode.value, equals(ThemeMode.dark));
      expect(controller.isDark, isTrue);
    });

    test('toggleTheme() karanlık ve aydınlık arasında geçiş yapar', () {
      controller.toggleTheme();
      expect(controller.themeMode.value, equals(ThemeMode.light));
      expect(controller.isDark, isFalse);

      controller.toggleTheme();
      expect(controller.themeMode.value, equals(ThemeMode.dark));
      expect(controller.isDark, isTrue);
    });
  });
}
