class ExerciseCatalogItem {
  final String id;
  final String name;
  final double caloriesPerMinute;

  const ExerciseCatalogItem({required this.id, required this.name, required this.caloriesPerMinute});
}

class ExerciseEntry {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final double caloriesPerMinute;
  final int durationMinutes;
  final DateTime date;

  const ExerciseEntry({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.caloriesPerMinute,
    required this.durationMinutes,
    required this.date,
  });

  int get caloriesBurned => (caloriesPerMinute * durationMinutes).round();

  ExerciseEntry copyWith({
    String? id,
    String? exerciseId,
    String? exerciseName,
    double? caloriesPerMinute,
    int? durationMinutes,
    DateTime? date,
  }) {
    return ExerciseEntry(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      caloriesPerMinute: caloriesPerMinute ?? this.caloriesPerMinute,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'caloriesPerMinute': caloriesPerMinute,
        'durationMinutes': durationMinutes,
        'date': date.toIso8601String(),
      };

  factory ExerciseEntry.fromJson(Map<String, dynamic> json) => ExerciseEntry(
        id: json['id'] as String,
        exerciseId: json['exerciseId'] as String,
        exerciseName: json['exerciseName'] as String,
        caloriesPerMinute: (json['caloriesPerMinute'] as num).toDouble(),
        durationMinutes: (json['durationMinutes'] as num).toInt(),
        date: DateTime.parse(json['date'] as String),
      );
}
