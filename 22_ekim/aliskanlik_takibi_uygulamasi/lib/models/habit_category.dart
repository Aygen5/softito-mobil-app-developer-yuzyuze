import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

enum HabitCategory {
  personalDevelopment(
    displayName: 'Kişisel Gelişim',
    icon: Icons.psychology,
    color: AppColors.primaryContainer,
  ),
  health(
    displayName: 'Sağlık',
    icon: Icons.favorite,
    color: AppColors.secondary,
  ),
  sports(
    displayName: 'Spor',
    icon: Icons.fitness_center,
    color: AppColors.tertiaryContainer,
  ),
  hydration(
    displayName: 'Su Tüketimi',
    icon: Icons.water_drop,
    color: AppColors.tertiary,
  ),
  mindfulness(
    displayName: 'Zihinsel Huzur',
    icon: Icons.self_improvement,
    color: AppColors.lavenderAccent,
  ),
  other(displayName: 'Diğer', icon: Icons.more_horiz, color: AppColors.outline);

  final String displayName;
  final IconData icon;
  final Color color;

  const HabitCategory({
    required this.displayName,
    required this.icon,
    required this.color,
  });
}
