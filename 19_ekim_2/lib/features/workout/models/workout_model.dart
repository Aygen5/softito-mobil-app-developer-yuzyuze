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

  WorkoutModel copyWith({
    String? id,
    WorkoutType? type,
    int? durationMinutes,
    int? caloriesBurned,
    DateTime? timestamp,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      type: WorkoutType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => WorkoutType.cardio,
      ),
      durationMinutes: json['durationMinutes'] as int,
      caloriesBurned: json['caloriesBurned'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
