import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

enum BeverageType {
  water(
    label: 'Su',
    icon: Icons.water_drop,
    color: AppColors.neonCyan,
    hydrationFactor: 1.0,
    presets: [
      (amount: 200, label: 'Bardak', icon: Icons.local_drink),
      (amount: 300, label: 'Kupa', icon: Icons.coffee),
      (amount: 500, label: 'Matara', icon: Icons.sports_gymnastics),
      (amount: 750, label: 'Şişe', icon: Icons.wine_bar_outlined),
    ],
  ),
  tea(
    label: 'Çay',
    icon: Icons.emoji_food_beverage,
    color: AppColors.beverageTea,
    hydrationFactor: 0.9,
    presets: [
      (amount: 100, label: 'İnce Belli', icon: Icons.local_cafe),
      (amount: 200, label: 'Kupa Çay', icon: Icons.emoji_food_beverage),
      (amount: 300, label: 'Büyük Kupa', icon: Icons.coffee),
    ],
  ),
  coffee(
    label: 'Kahve',
    icon: Icons.coffee,
    color: AppColors.beverageCoffee,
    hydrationFactor: 0.8,
    presets: [
      (amount: 60, label: 'Espresso', icon: Icons.local_cafe),
      (amount: 150, label: 'Filtre / Americano', icon: Icons.coffee),
      (amount: 250, label: 'Latte / Kupa', icon: Icons.local_cafe_outlined),
    ],
  ),
  mineralWater(
    label: 'Maden Suyu',
    icon: Icons.bubble_chart,
    color: AppColors.beverageMineralWater,
    hydrationFactor: 1.0,
    presets: [
      (amount: 200, label: 'Standart Şişe', icon: Icons.local_drink),
      (amount: 250, label: 'Büyük Şişe', icon: Icons.wine_bar_outlined),
    ],
  );

  final String label;
  final IconData icon;
  final Color color;
  final double hydrationFactor;
  final List<({int amount, String label, IconData icon})> presets;

  const BeverageType({
    required this.label,
    required this.icon,
    required this.color,
    required this.hydrationFactor,
    required this.presets,
  });
}
