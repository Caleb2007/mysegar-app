class WeightEntry {
  final DateTime date;
  final double weightKg;

  const WeightEntry({required this.date, required this.weightKg});

  Map<String, dynamic> toJson() => {'date': date.toIso8601String(), 'weightKg': weightKg};

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
        date: DateTime.parse(json['date'] as String),
        weightKg: (json['weightKg'] as num).toDouble(),
      );
}
