import 'exercise_entry.dart';
import 'meal_entry.dart';
import 'user_profile.dart';
import 'weight_entry.dart';

class StoredAccount {
  final String id;
  final UserProfile profile;
  final List<MealEntry> meals;
  final List<ExerciseEntry> exercises;
  final List<WeightEntry> weights;
  final DateTime lastUsedAt;

  const StoredAccount({
    required this.id,
    required this.profile,
    required this.meals,
    required this.exercises,
    required this.weights,
    required this.lastUsedAt,
  });

  StoredAccount copyWith({
    String? id,
    UserProfile? profile,
    List<MealEntry>? meals,
    List<ExerciseEntry>? exercises,
    List<WeightEntry>? weights,
    DateTime? lastUsedAt,
  }) {
    return StoredAccount(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      meals: meals ?? this.meals,
      exercises: exercises ?? this.exercises,
      weights: weights ?? this.weights,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'profile': profile.toJson(),
        'meals': meals.map((entry) => entry.toJson()).toList(),
        'exercises': exercises.map((entry) => entry.toJson()).toList(),
        'weights': weights.map((entry) => entry.toJson()).toList(),
        'lastUsedAt': lastUsedAt.toIso8601String(),
      };

  factory StoredAccount.fromJson(Map<String, dynamic> json) => StoredAccount(
        id: json['id'] as String? ?? '',
        profile: UserProfile.fromJson(
          Map<String, dynamic>.from(json['profile'] as Map? ?? const {}),
        ),
        meals: ((json['meals'] as List?) ?? const [])
            .map((entry) => MealEntry.fromJson(Map<String, dynamic>.from(entry as Map)))
            .toList(),
        exercises: ((json['exercises'] as List?) ?? const [])
            .map((entry) => ExerciseEntry.fromJson(Map<String, dynamic>.from(entry as Map)))
            .toList(),
        weights: ((json['weights'] as List?) ?? const [])
            .map((entry) => WeightEntry.fromJson(Map<String, dynamic>.from(entry as Map)))
            .toList(),
        lastUsedAt: DateTime.tryParse(json['lastUsedAt'] as String? ?? '') ?? DateTime.now(),
      );
}
