import 'dart:math';

import 'package:flutter/material.dart';

import 'data/exercise_database.dart';
import 'data/food_database.dart';
import 'models/diary_day_summary.dart';
import 'models/exercise_entry.dart';
import 'models/meal_entry.dart';
import 'models/user_profile.dart';
import 'models/weight_entry.dart';
import 'services/local_storage_service.dart';

class AppState extends ChangeNotifier {
  AppState(this._storageService);

  final LocalStorageService _storageService;

  UserProfile _profile = UserProfile.empty;
  List<MealEntry> _meals = [];
  List<ExerciseEntry> _exercises = [];
  List<WeightEntry> _weights = [];
  bool _isLoaded = false;
  bool _hasSeenOnboarding = false;

  bool get isLoaded => _isLoaded;
  UserProfile get profile => _profile;
  bool get needsProfileSetup => !_profile.isComplete;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  List<DishDefinition> get dishes => dishDatabase;
  List<IngredientDefinition> get ingredientsCatalog => ingredientDatabase;
  List<ExerciseCatalogItem> get exercisesCatalog => exerciseDatabase;

  Future<void> load() async {
    _profile = await _storageService.loadProfile();
    _meals = await _storageService.loadMeals();
    _exercises = await _storageService.loadExercises();
    _weights = await _storageService.loadWeights();
    _hasSeenOnboarding = await _storageService.loadOnboardingDone();
    await _pruneOldData(save: false);
    if (_weights.isEmpty && _profile.isComplete) {
      _weights = [WeightEntry(date: _normalizeDate(DateTime.now()), weightKg: _profile.weightKg)];
    }
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _hasSeenOnboarding = true;
    await _storageService.saveOnboardingDone(true);
    notifyListeners();
  }

  Future<void> saveProfile(UserProfile profile) async {
    _profile = profile;
    await _storageService.saveProfile(_profile);
    final today = _normalizeDate(DateTime.now());
    final existingIndex = _weights.indexWhere((entry) => isSameDate(entry.date, today));
    if (existingIndex == -1) {
      _weights.add(WeightEntry(date: today, weightKg: profile.weightKg));
    }
    await _persistWeights();
    notifyListeners();
  }

  Future<void> updatePersonalDetails({required String name, required double targetWeightKg, required String profileImagePath}) async {
    _profile = _profile.copyWith(name: name, targetWeightKg: targetWeightKg, profileImagePath: profileImagePath);
    await _storageService.saveProfile(_profile);
    notifyListeners();
  }

  MealType autoMealTypeForNow() => mealTypeForDateTime(DateTime.now());

  MealType mealTypeForDateTime(DateTime time) {
    final hour = time.hour;
    if (hour >= 5 && hour <= 10) return MealType.breakfast;
    if (hour >= 11 && hour <= 15) return MealType.lunch;
    if (hour >= 16 && hour <= 21) return MealType.dinner;
    return MealType.supper;
  }

  String greetingForNow() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour <= 11) return 'Good morning';
    if (hour >= 12 && hour <= 16) return 'Good afternoon';
    if (hour >= 17 && hour <= 20) return 'Good evening';
    return 'Good night';
  }

  List<MealEntry> mealsForDate(DateTime date) {
    final normalized = _normalizeDate(date);
    return _meals.where((entry) => isSameDate(entry.date, normalized)).toList();
  }

  List<MealEntry> mealsForSection(DateTime date, MealType mealType) {
    return mealsForDate(date).where((entry) => entry.mealType == mealType).toList();
  }

  List<ExerciseEntry> exerciseEntriesForDate(DateTime date) {
    final normalized = _normalizeDate(date);
    return _exercises.where((entry) => isSameDate(entry.date, normalized)).toList();
  }

  WeightEntry? weightForDate(DateTime date) {
    final normalized = _normalizeDate(date);
    for (final entry in _weights) {
      if (isSameDate(entry.date, normalized)) return entry;
    }
    return null;
  }

  double lastKnownWeightBefore(DateTime date) {
    final eligible = [..._weights]..sort((a, b) => a.date.compareTo(b.date));
    final filtered = eligible.where((entry) => !entry.date.isAfter(_normalizeDate(date))).toList();
    if (filtered.isNotEmpty) return filtered.last.weightKg;
    return _profile.weightKg;
  }

  WeightEntry? latestWeightEntry() {
    if (_weights.isEmpty) return null;
    final sorted = [..._weights]..sort((a, b) => a.date.compareTo(b.date));
    return sorted.last;
  }

  DiaryDaySummary summaryForDate(DateTime date) {
    final totalCalories = mealsForDate(date).fold<int>(0, (sum, item) => sum + item.calories);
    final exerciseCalories = exerciseEntriesForDate(date).fold<int>(0, (sum, item) => sum + item.caloriesBurned);
    final netCalories = totalCalories - exerciseCalories;
    final remainingCalories = _profile.dailyTargetCalories - netCalories;
    return DiaryDaySummary(
      totalCalories: totalCalories,
      exerciseCalories: exerciseCalories,
      netCalories: netCalories,
      remainingCalories: remainingCalories,
      dailyTarget: _profile.dailyTargetCalories,
    );
  }

  int mealTotalForSection(DateTime date, MealType mealType) => mealsForSection(date, mealType).fold<int>(0, (sum, item) => sum + item.calories);
  int exerciseTotalForDate(DateTime date) => exerciseEntriesForDate(date).fold<int>(0, (sum, item) => sum + item.caloriesBurned);

  Future<void> addMeal({required DateTime date, required MealType mealType, required DishDefinition dish, required List<IngredientSelection> ingredients}) async {
    _meals.add(MealEntry(
      id: _newId(),
      dishId: dish.id,
      dishName: dish.name,
      mealType: mealType,
      date: _normalizeDate(date),
      ingredients: ingredients,
      imagePath: dish.imagePath,
    ));
    await _persistMeals();
  }

  Future<void> updateMeal({required MealEntry original, required DishDefinition dish, required List<IngredientSelection> ingredients}) async {
    final index = _meals.indexWhere((entry) => entry.id == original.id);
    if (index == -1) return;
    _meals[index] = original.copyWith(dishId: dish.id, dishName: dish.name, ingredients: ingredients, imagePath: dish.imagePath);
    await _persistMeals();
  }

  Future<void> deleteMeal(String id) async {
    _meals.removeWhere((entry) => entry.id == id);
    await _persistMeals();
  }

  Future<void> addExercise({required DateTime date, required ExerciseCatalogItem exercise, required int durationMinutes}) async {
    _exercises.add(ExerciseEntry(
      id: _newId(),
      exerciseId: exercise.id,
      exerciseName: exercise.name,
      caloriesPerMinute: exercise.caloriesPerMinute,
      durationMinutes: durationMinutes,
      date: _normalizeDate(date),
    ));
    await _persistExercises();
  }

  Future<void> updateExercise({required ExerciseEntry original, required ExerciseCatalogItem exercise, required int durationMinutes}) async {
    final index = _exercises.indexWhere((entry) => entry.id == original.id);
    if (index == -1) return;
    _exercises[index] = original.copyWith(exerciseId: exercise.id, exerciseName: exercise.name, caloriesPerMinute: exercise.caloriesPerMinute, durationMinutes: durationMinutes);
    await _persistExercises();
  }

  Future<void> deleteExercise(String id) async {
    _exercises.removeWhere((entry) => entry.id == id);
    await _persistExercises();
  }

  Future<void> saveWeight({required DateTime date, required double weightKg}) async {
    final normalized = _normalizeDate(date);
    final index = _weights.indexWhere((entry) => isSameDate(entry.date, normalized));
    if (index == -1) {
      _weights.add(WeightEntry(date: normalized, weightKg: weightKg));
    } else {
      _weights[index] = WeightEntry(date: normalized, weightKg: weightKg);
    }
    _weights.sort((a, b) => a.date.compareTo(b.date));
    await _persistWeights();
  }

  List<WeightEntry> weightRange({required int days}) {
    final today = _normalizeDate(DateTime.now());
    return List.generate(days, (index) {
      final date = today.subtract(Duration(days: days - 1 - index));
      return WeightEntry(date: date, weightKg: weightForDate(date)?.weightKg ?? lastKnownWeightBefore(date));
    });
  }

  int weeklyAverageCalories() {
    final values = weightRange(days: 7).map((entry) => summaryForDate(entry.date).netCalories).toList();
    return values.isEmpty ? 0 : (values.reduce((a, b) => a + b) / values.length).round();
  }

  int loggingStreak() {
    final today = _normalizeDate(DateTime.now());
    var streak = 0;
    for (var i = 0; i < 30; i++) {
      final date = today.subtract(Duration(days: i));
      final hasData = mealsForDate(date).isNotEmpty || exerciseEntriesForDate(date).isNotEmpty || weightForDate(date) != null;
      if (!hasData) break;
      streak += 1;
    }
    return streak;
  }

  bool isSuccessfulCalorieDay(DateTime date) {
    final mealList = mealsForDate(date);
    if (mealList.isEmpty) return false;
    
    final summary = summaryForDate(date);
    final target = summary.dailyTarget;
    if (target <= 0) return false;
    
    final lowerBound = min(1600, target);
    return summary.netCalories >= lowerBound && summary.netCalories <= target;
  }

  int successfulCalorieDays({int maxDays = 100}) {
    final mealsDateSet = <DateTime>{};
    for (final meal in _meals) {
      mealsDateSet.add(_normalizeDate(meal.date));
    }
    
    final sortedDates = mealsDateSet.toList()..sort();
    
    int count = 0;
    for (final date in sortedDates) {
      if (isSuccessfulCalorieDay(date)) {
        count++;
        if (count >= maxDays) {
          return maxDays;
        }
      }
    }
    
    return count;
  }

  int currentPlantGrowthDay() {
    final successDays = successfulCalorieDays(maxDays: 100);
    // Advance animation by 15 days for every successful day
    final growthDay = successDays <= 0 ? 1 : (successDays * 15).clamp(1, 1500);
    return growthDay;
  }

  Future<void> _persistMeals() async {
    await _pruneOldData(save: false);
    await _storageService.saveMeals(_meals);
    notifyListeners();
  }

  Future<void> _persistExercises() async {
    await _pruneOldData(save: false);
    await _storageService.saveExercises(_exercises);
    notifyListeners();
  }

  Future<void> _persistWeights() async {
    await _pruneOldData(save: false);
    await _storageService.saveWeights(_weights);
    notifyListeners();
  }

  Future<void> _pruneOldData({required bool save}) async {
    final today = _normalizeDate(DateTime.now());
    final diaryHistoryCutoff = today.subtract(const Duration(days: 29));
    final weightCutoff = today.subtract(const Duration(days: 29));
    _meals = _meals.where((entry) => !entry.date.isBefore(diaryHistoryCutoff)).toList();
    _exercises = _exercises.where((entry) => !entry.date.isBefore(diaryHistoryCutoff)).toList();
    _weights = _weights.where((entry) => !entry.date.isBefore(weightCutoff)).toList();
    if (save) {
      await _storageService.saveMeals(_meals);
      await _storageService.saveExercises(_exercises);
      await _storageService.saveWeights(_weights);
    }
  }

  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  static bool isSameDate(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  String _newId() => '${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(999)}';
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child}) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!.notifier!;
  }
}

int calculateDailyTarget({required String gender, required int age, required double heightCm, required double weightKg, required String activityLevel, required String goal}) {
  final bmr = gender.toLowerCase() == 'female'
      ? 10 * weightKg + 6.25 * heightCm - 5 * age - 161
      : 10 * weightKg + 6.25 * heightCm - 5 * age + 5;

  final multiplier = switch (activityLevel) {
    'Lightly active' => 1.375,
    'Moderately active' => 1.55,
    'Very active' => 1.725,
    _ => 1.2,
  };
  var target = bmr * multiplier;
  if (goal == 'Lose weight') target -= 400;
  if (goal == 'Gain weight') target += 250;
  return target.round().clamp(1200, 3200);
}
