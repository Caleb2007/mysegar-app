import 'package:flutter/material.dart';

import '../app_state.dart';
import '../data/food_database.dart';
import '../models/meal_entry.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'input3_screen.dart';

class Input2Screen extends StatefulWidget {
  final DateTime date;
  final MealType mealType;
  final DishDefinition dish;
  final MealEntry? originalEntry;
  final bool isPhotoFlow;

  const Input2Screen({super.key, required this.date, required this.mealType, required this.dish, this.originalEntry, this.isPhotoFlow = false});

  bool get isEditing => originalEntry != null;

  @override
  State<Input2Screen> createState() => _Input2ScreenState();
}

class _Input2ScreenState extends State<Input2Screen> {
  late DishDefinition _dish;
  late List<IngredientSelection> _ingredients;

  @override
  void initState() {
    super.initState();
    _dish = widget.dish;
    _ingredients = widget.originalEntry?.ingredients.map((e) => e.copyWith()).toList() ?? widget.dish.defaultIngredients.map((e) => e.copyWith()).toList();
  }

  int get _totalCalories => _ingredients.fold(0, (sum, item) => sum + item.calories);

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final remaining = state.profile.dailyTargetCalories - _totalCalories;
    return GradientScaffold(
      tone: PageTone.green,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)), const SizedBox(width: 8), const Text('Input 2', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))]),
          const SizedBox(height: 18),
          CardShell(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [CircleAvatar(radius: 28, backgroundImage: AssetImage(_dish.imagePath)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_dish.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)), Text(widget.isPhotoFlow ? 'Detected dish from photo' : 'Selected from database', style: const TextStyle(color: AppColors.mutedForeground))]))]),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(14)),
                child: const Text('Suggested portions are pre-filled based on a typical serving. The small caption on the right shows the default value.', style: TextStyle(color: AppColors.mutedForeground, height: 1.4)),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.orange), foregroundColor: AppColors.orange),
                  onPressed: () => setState(() => _ingredients = _dish.defaultIngredients.map((e) => e.copyWith()).toList()),
                  child: const Text('Reset to default'),
                ),
              ),
              const SizedBox(height: 8),
              ..._ingredients.asMap().entries.map((entry) => _IngredientCard(
                    selection: entry.value,
                    onChanged: (updated) => setState(() => _ingredients[entry.key] = updated),
                    onEdit: () async {
                      final replacement = await showModalBottomSheet<IngredientDefinition>(
                        context: context,
                        builder: (_) => _IngredientPicker(currentId: entry.value.ingredient.id),
                      );
                      if (replacement != null) {
                        setState(() {
                          _ingredients[entry.key] = IngredientSelection(
                            ingredient: replacement,
                            percentage: replacement.inputMode == IngredientInputMode.percentage ? replacement.defaultPercentage : 0,
                            servings: replacement.inputMode == IngredientInputMode.servings ? 1 : 0,
                          );
                        });
                      }
                    },
                    onDelete: () => setState(() => _ingredients.removeAt(entry.key)),
                  )),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), foregroundColor: AppColors.primary),
                onPressed: _addIngredient,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add ingredient'),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          CardShell(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Estimated total', style: TextStyle(color: AppColors.mutedForeground)),
              const SizedBox(height: 6),
              Text('$_totalCalories kcal', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.foreground)),
              const SizedBox(height: 4),
              Text('Today remaining: $remaining kcal', style: TextStyle(color: remaining < 0 ? AppColors.red : AppColors.mutedForeground, fontWeight: FontWeight.w600)),
            ]),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Input3Screen(date: widget.date, mealType: widget.mealType, dish: _dish, ingredients: _ingredients, originalEntry: widget.originalEntry))),
              child: const Text('Continue to Input 3', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _addIngredient() async {
    final addition = await showModalBottomSheet<IngredientDefinition>(
      context: context,
      builder: (_) => const _IngredientPicker(currentId: ''),
    );
    if (addition == null) return;
    setState(() {
      _ingredients.add(IngredientSelection(
        ingredient: addition,
        percentage: addition.inputMode == IngredientInputMode.percentage ? addition.defaultPercentage : 0,
        servings: addition.inputMode == IngredientInputMode.servings ? 1 : 0,
      ));
    });
  }
}

class _IngredientCard extends StatelessWidget {
  final IngredientSelection selection;
  final ValueChanged<IngredientSelection> onChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _IngredientCard({required this.selection, required this.onChanged, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final disabled = selection.isZero;
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: disabled ? AppColors.secondary : Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(selection.ingredient.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: disabled ? AppColors.mutedForeground : AppColors.foreground))),
          Text(selection.ingredient.inputMode == IngredientInputMode.servings ? 'Default 1 serving' : 'Default ${selection.ingredient.defaultPercentage}%', style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
          const SizedBox(width: 8),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, size: 18)),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.red)),
        ]),
        const SizedBox(height: 8),
        if (selection.ingredient.inputMode == IngredientInputMode.percentage)
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Slider(value: selection.percentage.toDouble(), max: 100, min: 0, divisions: 100, activeColor: AppColors.primary, onChanged: (value) => onChanged(selection.copyWith(percentage: value.round()))),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('${selection.percentage}%', style: TextStyle(color: disabled ? AppColors.mutedForeground : AppColors.foreground, fontWeight: FontWeight.w700)), Text('${selection.calories} kcal', style: const TextStyle(color: AppColors.mutedForeground))]),
          ])
        else
          Row(children: [
            _stepperButton(Icons.remove_rounded, () => onChanged(selection.copyWith(servings: (selection.servings - 1).clamp(0, 10)))),
            Container(margin: const EdgeInsets.symmetric(horizontal: 12), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10), decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(14)), child: Text('${selection.servings}', style: const TextStyle(fontWeight: FontWeight.w800))),
            _stepperButton(Icons.add_rounded, () => onChanged(selection.copyWith(servings: (selection.servings + 1).clamp(0, 10)))),
            const Spacer(),
            Text('${selection.calories} kcal', style: const TextStyle(color: AppColors.mutedForeground)),
          ]),
      ]),
    );
  }

  Widget _stepperButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.primary)),
    );
  }
}

class _IngredientPicker extends StatelessWidget {
  final String currentId;
  const _IngredientPicker({required this.currentId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Choose ingredient', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          ...ingredientDatabase.map((ingredient) => ListTile(
                title: Text(ingredient.name),
                subtitle: Text(ingredient.inputMode == IngredientInputMode.servings ? 'Serving based' : 'Percentage based'),
                trailing: ingredient.id == currentId ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                onTap: () => Navigator.pop(context, ingredient),
              )),
        ]),
      ),
    );
  }
}
