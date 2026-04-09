import 'dart:convert';

enum MealType { breakfast, lunch, dinner, supper }

extension MealTypeX on MealType {
  String get label => switch (this) {
        MealType.breakfast => 'Breakfast',
        MealType.lunch => 'Lunch',
        MealType.dinner => 'Dinner',
        MealType.supper => 'Supper',
      };

  static MealType fromKey(String key) => MealType.values.firstWhere(
        (type) => type.name == key,
        orElse: () => MealType.breakfast,
      );
}

enum IngredientInputMode { percentage, servings }

extension IngredientInputModeX on IngredientInputMode {
  static IngredientInputMode fromKey(String key) => IngredientInputMode.values.firstWhere(
        (mode) => mode.name == key,
        orElse: () => IngredientInputMode.percentage,
      );
}

class IngredientDefinition {
  final String id;
  final String name;
  final IngredientInputMode inputMode;
  final int defaultPercentage;
  final int defaultCalories;
  final int caloriesPerServing;

  const IngredientDefinition({
    required this.id,
    required this.name,
    required this.inputMode,
    this.defaultPercentage = 0,
    this.defaultCalories = 0,
    this.caloriesPerServing = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'inputMode': inputMode.name,
        'defaultPercentage': defaultPercentage,
        'defaultCalories': defaultCalories,
        'caloriesPerServing': caloriesPerServing,
      };

  factory IngredientDefinition.fromJson(Map<String, dynamic> json) => IngredientDefinition(
        id: json['id'] as String,
        name: json['name'] as String,
        inputMode: IngredientInputModeX.fromKey(json['inputMode'] as String),
        defaultPercentage: (json['defaultPercentage'] as num?)?.toInt() ?? 0,
        defaultCalories: (json['defaultCalories'] as num?)?.toInt() ?? 0,
        caloriesPerServing: (json['caloriesPerServing'] as num?)?.toInt() ?? 0,
      );
}

class IngredientSelection {
  final IngredientDefinition ingredient;
  final int percentage;
  final int servings;

  const IngredientSelection({
    required this.ingredient,
    required this.percentage,
    required this.servings,
  });

  int get calories {
    if (ingredient.inputMode == IngredientInputMode.servings) {
      return ingredient.caloriesPerServing * servings;
    }
    if (ingredient.defaultPercentage <= 0) return 0;
    return (ingredient.defaultCalories * (percentage / ingredient.defaultPercentage)).round();
  }

  bool get isZero => ingredient.inputMode == IngredientInputMode.servings ? servings == 0 : percentage == 0;

  IngredientSelection copyWith({IngredientDefinition? ingredient, int? percentage, int? servings}) {
    return IngredientSelection(
      ingredient: ingredient ?? this.ingredient,
      percentage: percentage ?? this.percentage,
      servings: servings ?? this.servings,
    );
  }

  Map<String, dynamic> toJson() => {
        'ingredient': ingredient.toJson(),
        'percentage': percentage,
        'servings': servings,
      };

  factory IngredientSelection.fromJson(Map<String, dynamic> json) => IngredientSelection(
        ingredient: IngredientDefinition.fromJson(Map<String, dynamic>.from(json['ingredient'] as Map)),
        percentage: (json['percentage'] as num?)?.toInt() ?? 0,
        servings: (json['servings'] as num?)?.toInt() ?? 0,
      );
}

class DishDefinition {
  final String id;
  final String name;
  final int baseCalories;
  final String imagePath;
  final List<IngredientSelection> defaultIngredients;

  const DishDefinition({
    required this.id,
    required this.name,
    required this.baseCalories,
    required this.imagePath,
    required this.defaultIngredients,
  });
}

class MealEntry {
  final String id;
  final String dishId;
  final String dishName;
  final MealType mealType;
  final DateTime date;
  final List<IngredientSelection> ingredients;
  final String imagePath;

  const MealEntry({
    required this.id,
    required this.dishId,
    required this.dishName,
    required this.mealType,
    required this.date,
    required this.ingredients,
    required this.imagePath,
  });

  int get calories => ingredients.fold<int>(0, (sum, item) => sum + item.calories);

  MealEntry copyWith({
    String? id,
    String? dishId,
    String? dishName,
    MealType? mealType,
    DateTime? date,
    List<IngredientSelection>? ingredients,
    String? imagePath,
  }) {
    return MealEntry(
      id: id ?? this.id,
      dishId: dishId ?? this.dishId,
      dishName: dishName ?? this.dishName,
      mealType: mealType ?? this.mealType,
      date: date ?? this.date,
      ingredients: ingredients ?? this.ingredients,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'dishId': dishId,
        'dishName': dishName,
        'mealType': mealType.name,
        'date': date.toIso8601String(),
        'ingredients': ingredients.map((e) => e.toJson()).toList(),
        'imagePath': imagePath,
      };

  factory MealEntry.fromJson(Map<String, dynamic> json) => MealEntry(
        id: json['id'] as String,
        dishId: json['dishId'] as String,
        dishName: json['dishName'] as String,
        mealType: MealTypeX.fromKey(json['mealType'] as String),
        date: DateTime.parse(json['date'] as String),
        ingredients: (json['ingredients'] as List<dynamic>)
            .map((e) => IngredientSelection.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        imagePath: json['imagePath'] as String? ?? '',
      );
}
