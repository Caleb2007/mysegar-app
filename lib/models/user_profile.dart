class UserProfile {
  final String name;
  final String gender;
  final int age;
  final double heightCm;
  final double weightKg;
  final double targetWeightKg;
  final String activityLevel;
  final String goal;
  final String diseaseCondition;
  final int dailyTargetCalories;
  final String profileImagePath;

  const UserProfile({
    required this.name,
    required this.gender,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.targetWeightKg,
    required this.activityLevel,
    required this.goal,
    required this.diseaseCondition,
    required this.dailyTargetCalories,
    required this.profileImagePath,
  });

  bool get isComplete => name.trim().isNotEmpty;

  UserProfile copyWith({
    String? name,
    String? gender,
    int? age,
    double? heightCm,
    double? weightKg,
    double? targetWeightKg,
    String? activityLevel,
    String? goal,
    String? diseaseCondition,
    int? dailyTargetCalories,
    String? profileImagePath,
  }) {
    return UserProfile(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      diseaseCondition: diseaseCondition ?? this.diseaseCondition,
      dailyTargetCalories: dailyTargetCalories ?? this.dailyTargetCalories,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'gender': gender,
        'age': age,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'targetWeightKg': targetWeightKg,
        'activityLevel': activityLevel,
        'goal': goal,
        'diseaseCondition': diseaseCondition,
        'dailyTargetCalories': dailyTargetCalories,
        'profileImagePath': profileImagePath,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String? ?? '',
        gender: json['gender'] as String? ?? 'Male',
        age: (json['age'] as num?)?.toInt() ?? 18,
        heightCm: (json['heightCm'] as num?)?.toDouble() ?? 170,
        weightKg: (json['weightKg'] as num?)?.toDouble() ?? 74,
        targetWeightKg: (json['targetWeightKg'] as num?)?.toDouble() ?? 68,
        activityLevel: json['activityLevel'] as String? ?? 'Moderately active',
        goal: json['goal'] as String? ?? 'Lose weight',
        diseaseCondition: json['diseaseCondition'] as String? ?? '',
        dailyTargetCalories: (json['dailyTargetCalories'] as num?)?.toInt() ?? 1800,
        profileImagePath: json['profileImagePath'] as String? ?? '',
      );

  static const empty = UserProfile(
    name: '',
    gender: 'Male',
    age: 18,
    heightCm: 170,
    weightKg: 74,
    targetWeightKg: 68,
    activityLevel: 'Moderately active',
    goal: 'Lose weight',
    diseaseCondition: '',
    dailyTargetCalories: 1800,
    profileImagePath: '',
  );
}
