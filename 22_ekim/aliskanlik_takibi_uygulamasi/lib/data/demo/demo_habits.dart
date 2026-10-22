import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/habit.dart';
import '../../models/habit_category.dart';

abstract class DemoHabits {
  static List<Habit> get initialHabits {
    final now = DateTime.now();

    return [
      // 1. Günde 10.000 Adım (Tamamlandı, 30 Gün Seri)
      Habit(
        id: 'step_10k',
        title: 'Günde 10.000 Adım',
        category: HabitCategory.sports,
        iconCodePoint: Icons.directions_walk.codePoint,
        colorValue: AppColors.primaryContainer.toARGB32(),
        targetValue: 10000,
        targetUnit: 'Adım',
        scheduledDays: {1, 2, 3, 4, 5, 6, 7},
        reminderEnabled: true,
        reminderTime: '18:00',
        createdAt: now.subtract(const Duration(days: 35)),
        isCompletedToday: true,
        todayProgress: 10000,
        currentStreak: 30,
        isNotStarted: false,
      ),

      // 2. Sigarasız Yaşam (Meydan Okuma 14/30 gün)
      Habit(
        id: 'smoke_free',
        title: 'Sigarasız Yaşam',
        category: HabitCategory.health,
        iconCodePoint: Icons.smoke_free.codePoint,
        colorValue: AppColors.secondary.toARGB32(),
        targetValue: 30,
        targetUnit: 'Gün',
        scheduledDays: {1, 2, 3, 4, 5, 6, 7},
        reminderEnabled: true,
        reminderTime: '09:00',
        challengeTotalDays: 30,
        challengeCurrentDay: 14,
        createdAt: now.subtract(const Duration(days: 14)),
        isCompletedToday: false,
        todayProgress: 14,
        currentStreak: 14,
        isNotStarted: false,
      ),

      // 3. Spor Salonuna Git (Henüz Başlanmadı)
      Habit(
        id: 'gym_workout',
        title: 'Spor Salonuna Git',
        category: HabitCategory.sports,
        iconCodePoint: Icons.fitness_center.codePoint,
        colorValue: AppColors.outline.toARGB32(),
        targetValue: 3,
        targetUnit: 'Hafta',
        scheduledDays: {1, 3, 5},
        reminderEnabled: false,
        reminderTime: '19:00',
        createdAt: now.subtract(const Duration(days: 3)),
        isCompletedToday: false,
        todayProgress: 0,
        currentStreak: 0,
        isNotStarted: true,
      ),

      // 4. Her Gün 100 Sayfa Oku (2. Gün, Yeni Başladı)
      Habit(
        id: 'read_100p',
        title: 'Her Gün 100 Sayfa Oku',
        category: HabitCategory.personalDevelopment,
        iconCodePoint: Icons.menu_book.codePoint,
        colorValue: AppColors.secondaryFixedDim.toARGB32(),
        targetValue: 100,
        targetUnit: 'Sayfa',
        scheduledDays: {1, 2, 3, 4, 5, 6, 7},
        reminderEnabled: true,
        reminderTime: '21:30',
        createdAt: now.subtract(const Duration(days: 2)),
        isCompletedToday: false,
        todayProgress: 45,
        currentStreak: 1,
        isNotStarted: false,
      ),

      // 5. Günde 3 Litre Su (2.500 / 3.000 ml - %83 Tamamlanmadı)
      Habit(
        id: 'water_3l',
        title: 'Günde 3 Litre Su',
        category: HabitCategory.hydration,
        iconCodePoint: Icons.water_drop.codePoint,
        colorValue: AppColors.tertiary.toARGB32(),
        targetValue: 3000,
        targetUnit: 'ml',
        scheduledDays: {1, 2, 3, 4, 5, 6, 7},
        reminderEnabled: true,
        reminderTime: '11:00',
        createdAt: now.subtract(const Duration(days: 30)),
        isCompletedToday: false,
        todayProgress: 2500,
        currentStreak: 5,
        isNotStarted: false,
      ),
    ];
  }
}
