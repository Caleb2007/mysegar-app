class DiaryDaySummary {
  final int totalCalories;
  final int exerciseCalories;
  final int netCalories;
  final int remainingCalories;
  final int dailyTarget;

  const DiaryDaySummary({
    required this.totalCalories,
    required this.exerciseCalories,
    required this.netCalories,
    required this.remainingCalories,
    required this.dailyTarget,
  });

  double get progress => dailyTarget <= 0 ? 0 : (netCalories / dailyTarget).clamp(0.0, 1.0);
  bool get isExceeded => remainingCalories < 0;
}
