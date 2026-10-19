import 'package:flutter/material.dart';

enum WorkoutType {
  cardio(label: 'Kardiyo / Koşu', icon: Icons.directions_run, defaultCalPerMin: 10),
  strength(label: 'Ağırlık / Fitness', icon: Icons.fitness_center, defaultCalPerMin: 7),
  hiit(label: 'HIIT / Fonksiyonel', icon: Icons.flash_on, defaultCalPerMin: 12),
  cycling(label: 'Bisiklet', icon: Icons.pedal_bike, defaultCalPerMin: 8),
  swimming(label: 'Yüzme', icon: Icons.pool, defaultCalPerMin: 9);

  final String label;
  final IconData icon;
  final int defaultCalPerMin;

  const WorkoutType({
    required this.label,
    required this.icon,
    required this.defaultCalPerMin,
  });
}

class WorkoutModel {
  final String id;
  final WorkoutType type;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime timestamp;

  const WorkoutModel({
    required this.id,
    required this.type,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.timestamp,
  });
}
