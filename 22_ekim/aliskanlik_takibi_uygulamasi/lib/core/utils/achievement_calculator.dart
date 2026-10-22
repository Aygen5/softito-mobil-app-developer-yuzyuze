import 'package:flutter/material.dart';

import '../../models/achievement.dart';
import '../../models/habit.dart';
import '../../models/habit_completion.dart';

abstract class AchievementCalculator {
  static List<Achievement> evaluateAchievements({
    required List<Habit> habits,
    required List<HabitCompletion> completions,
  }) {
    final totalCompletedCount = completions.where((c) => c.isCompleted).length;
    final hasStepCompleted = completions.any(
      (c) => c.habitId == 'step_10k' && c.isCompleted,
    );
    final hasBookCompleted = completions.any(
      (c) => c.habitId == 'read_100p' && c.isCompleted,
    );
    final hasWaterHigh = completions.any(
      (c) => c.habitId == 'water_3l' && c.value >= 2500,
    );

    return [
      Achievement(
        id: 'ilk_adim',
        title: 'İlk Adım',
        description: 'İlk alışkanlığını tamamlayarak yolculuğa başladın.',
        icon: Icons.local_florist,
        isUnlocked: totalCompletedCount >= 1,
        requirementText: 'İlk alışkanlığı tamamla',
      ),
      Achievement(
        id: 'seri_7',
        title: '7 Günlük Seri',
        description: 'Kesintisiz 7 planlı gün boyunca ritmini korudun.',
        icon: Icons.military_tech,
        isUnlocked: true, // Demo: 10.000 adım 30 gündür sürüyor
        requirementText: '7 gün üst üste tamamla',
      ),
      Achievement(
        id: 'istikrar_30',
        title: '30 Gün',
        description: 'Rozet vitrinine eklendi. Büyümen kök salıyor.',
        icon: Icons.stars,
        isUnlocked: true, // Demo: 10.000 adım 30 gün
        requirementText: '30 günlük istikrara ulaş',
      ),
      Achievement(
        id: 'su_kasifi',
        title: 'Su Kaşifi',
        description: 'Bedenini suyun canlılığıyla besledin.',
        icon: Icons.water_drop,
        isUnlocked: hasWaterHigh,
        requirementText: 'Su hedefine düzenli yaklaş',
      ),
      Achievement(
        id: 'kitap_kurdu',
        title: 'Kitap Kurdu',
        description: 'Sayfalar arasında zihnini derinleştirdin.',
        icon: Icons.auto_stories,
        isUnlocked: hasBookCompleted,
        requirementText: 'Okuma alışkanlığı kazan',
      ),
      Achievement(
        id: 'hareket_ustasi',
        title: 'Hareket Ustası',
        description: 'Günde 10.000 adımı hayatının bir parçası yaptın.',
        icon: Icons.directions_walk,
        isUnlocked: hasStepCompleted,
        requirementText: '10.000 adım hedefine ulaş',
      ),
      Achievement(
        id: 'kararlilik',
        title: 'Kararlılık',
        description: '50 gün boyunca hiç pes etmeden devam ettin.',
        icon: Icons.lock,
        isUnlocked: false,
        requirementText: '50 güne ulaş',
      ),
      Achievement(
        id: 'ilk_ay',
        title: 'İlk Ay',
        description: 'Bir aylık alışkanlık dönüm noktasına ulaştın.',
        icon: Icons.lock,
        isUnlocked: false,
        requirementText: 'Ayı tamamla',
      ),
      Achievement(
        id: 'yeniden_basla',
        title: 'Yeniden Başla',
        description: 'Bir duraksamadan sonra rotana sadakatle döndün.',
        icon: Icons.lock,
        isUnlocked: false,
        requirementText: 'Arayı kapat ve geri dön',
      ),
      Achievement(
        id: 'erken_baslangic',
        title: 'Erken Kuş',
        description: 'Güne erken saatte zinde bir alışkanlıkla başladın.',
        icon: Icons.lock,
        isUnlocked: false,
        requirementText: 'Sabah 08:00 öncesi tamamla',
      ),
    ];
  }
}
