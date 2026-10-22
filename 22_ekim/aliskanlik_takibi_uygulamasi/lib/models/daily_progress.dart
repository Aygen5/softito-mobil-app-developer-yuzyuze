class DailyProgress {
  final int totalHabits;
  final int completedHabits;

  const DailyProgress({
    required this.totalHabits,
    required this.completedHabits,
  });

  double get ratio =>
      totalHabits == 0 ? 0.0 : (completedHabits / totalHabits).clamp(0.0, 1.0);
  int get percentage => (ratio * 100).round();
}
