import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/exercise_entry.dart';
import '../models/meal_entry.dart';
import '../models/stored_account.dart';
import '../models/user_profile.dart';
import '../models/weight_entry.dart';

class LocalStorageService {
  static const _profileKey = 'profile';
  static const _mealsKey = 'meals';
  static const _exercisesKey = 'exercises';
  static const _weightsKey = 'weights';
  static const _onboardingKey = 'onboarding_done';
  static const _accountsKey = 'saved_accounts';
  static const _activeAccountIdKey = 'active_account_id';

  Future<UserProfile> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKey);
    if (raw == null || raw.isEmpty) return UserProfile.empty;
    return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<List<MealEntry>> loadMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_mealsKey);
    if (raw == null || raw.isEmpty) return [];
    final list = (jsonDecode(raw) as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
    return list.map(MealEntry.fromJson).toList();
  }

  Future<void> saveMeals(List<MealEntry> meals) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mealsKey, jsonEncode(meals.map((e) => e.toJson()).toList()));
  }

  Future<List<ExerciseEntry>> loadExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_exercisesKey);
    if (raw == null || raw.isEmpty) return [];
    final list = (jsonDecode(raw) as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
    return list.map(ExerciseEntry.fromJson).toList();
  }

  Future<void> saveExercises(List<ExerciseEntry> exercises) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_exercisesKey, jsonEncode(exercises.map((e) => e.toJson()).toList()));
  }

  Future<List<WeightEntry>> loadWeights() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_weightsKey);
    if (raw == null || raw.isEmpty) return [];
    final list = (jsonDecode(raw) as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
    return list.map(WeightEntry.fromJson).toList();
  }

  Future<void> saveWeights(List<WeightEntry> weights) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weightsKey, jsonEncode(weights.map((e) => e.toJson()).toList()));
  }

  Future<bool> loadOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> saveOnboardingDone(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, value);
  }

  Future<List<StoredAccount>> loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_accountsKey);
    if (raw == null || raw.isEmpty) return [];
    final list = (jsonDecode(raw) as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
    return list.map(StoredAccount.fromJson).toList();
  }

  Future<void> saveAccounts(List<StoredAccount> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _accountsKey,
      jsonEncode(accounts.map((account) => account.toJson()).toList()),
    );
  }

  Future<String?> loadActiveAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeAccountIdKey);
  }

  Future<void> saveActiveAccountId(String? accountId) async {
    final prefs = await SharedPreferences.getInstance();
    if (accountId == null || accountId.isEmpty) {
      await prefs.remove(_activeAccountIdKey);
      return;
    }
    await prefs.setString(_activeAccountIdKey, accountId);
  }
}
