class HabitCompletion {
  final String id;
  final String habitId;
  final DateTime date; // saat normalize edilmiş
  final double value;
  final bool isCompleted;

  const HabitCompletion({
    required this.id,
    required this.habitId,
    required this.date,
    required this.value,
    required this.isCompleted,
  });

  HabitCompletion copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    double? value,
    bool? isCompleted,
  }) {
    return HabitCompletion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      value: value ?? this.value,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
