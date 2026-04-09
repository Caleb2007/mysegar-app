import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models/meal_entry.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

class Input3Screen extends StatelessWidget {
  final DateTime date;
  final MealType mealType;
  final DishDefinition dish;
  final List<IngredientSelection> ingredients;
  final MealEntry? originalEntry;

  const Input3Screen({super.key, required this.date, required this.mealType, required this.dish, required this.ingredients, this.originalEntry});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final totalCalories = ingredients.fold<int>(0, (sum, item) => sum + item.calories);
    final remaining = state.profile.dailyTargetCalories - totalCalories;
    return GradientScaffold(
      tone: PageTone.green,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)), const SizedBox(width: 8), const Text('Input 3', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))]),
          const Spacer(),
          Center(child: CircleAvatar(radius: 44, backgroundImage: AssetImage(dish.imagePath))),
          const SizedBox(height: 18),
          Center(child: Text(dish.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800))),
          const SizedBox(height: 10),
          Center(child: Text('$totalCalories kcal', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: AppColors.primary))),
          const SizedBox(height: 8),
          Center(child: Text('Today remaining: $remaining kcal', style: TextStyle(color: remaining < 0 ? AppColors.red : AppColors.mutedForeground, fontWeight: FontWeight.w600))),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18)),
              onPressed: () async {
                if (originalEntry == null) {
                  await state.addMeal(date: date, mealType: mealType, dish: dish, ingredients: ingredients);
                } else {
                  await state.updateMeal(original: originalEntry!, dish: dish, ingredients: ingredients);
                }
                if (!context.mounted) return;
                Navigator.popUntil(context, (route) => route.isFirst || route.settings.name == null);
              },
              child: const Text('Finish', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ]),
      ),
    );
  }
}
