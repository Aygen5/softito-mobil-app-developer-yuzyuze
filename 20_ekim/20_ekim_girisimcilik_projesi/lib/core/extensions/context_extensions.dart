import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// BuildContext için ergonomik tema ve renk kısayolları.
/// Projede sabit renk yazımını önler.
extension ContextExtensions on BuildContext {
  /// ThemeExtension (SpaceColors) erişimi
  SpaceColors get spaceColors =>
      Theme.of(this).extension<SpaceColors>() ?? SpaceColors.dark;

  /// Tipografi kısayolu
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// ColorScheme kısayolu
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Koyu tema aktif mi?
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Ekran genişliği ve yüksekliği
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
}
