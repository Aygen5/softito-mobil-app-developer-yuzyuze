import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_cubit.dart';

/// Açık / Koyu tema geçişi sağlayan şık ikon butonu.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final isDark = themeMode == ThemeMode.dark;

    return IconButton(
      tooltip: isDark ? 'Açık Mod' : 'Koyu Mod',
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Icon(
          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          key: ValueKey(isDark),
          color: isDark ? Colors.amber : AppColors.primaryNavy,
          size: 22,
        ),
      ),
      onPressed: () {
        context.read<ThemeCubit>().toggleTheme();
      },
    );
  }
}
