import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models/meal_entry.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'input2_screen.dart';

class Input1Screen extends StatefulWidget {
  final DateTime date;
  final MealType mealType;

  const Input1Screen({super.key, required this.date, required this.mealType});

  @override
  State<Input1Screen> createState() => _Input1ScreenState();
}

class _Input1ScreenState extends State<Input1Screen> {
  bool _databaseMode = true;
  DishDefinition? _selectedDish;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return GradientScaffold(
      tone: PageTone.green,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)), const SizedBox(width: 8), const Text('Input 1', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))]),
          const SizedBox(height: 20),
          Text(widget.mealType.label, style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          const Text('Choose your food input method', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(child: _modeButton('Database', _databaseMode, () => setState(() => _databaseMode = true))),
            const SizedBox(width: 12),
            Expanded(child: _modeButton('Photo upload', !_databaseMode, () => setState(() => _databaseMode = false))),
          ]),
          const SizedBox(height: 18),
          const Text('Tap one dish', style: TextStyle(color: AppColors.mutedForeground, fontSize: 16)),
          const SizedBox(height: 12),
          ...state.dishes.map((dish) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: InkWell(
                  onTap: () => setState(() => _selectedDish = dish),
                  child: CardShell(
                    borderColor: _selectedDish?.id == dish.id ? AppColors.primary : AppColors.border,
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      CircleAvatar(radius: 28, backgroundColor: AppColors.primarySoft, backgroundImage: AssetImage(dish.imagePath)),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(dish.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), Text('Base calories: ${dish.baseCalories} kcal', style: const TextStyle(color: AppColors.mutedForeground))])),
                      Icon(_selectedDish?.id == dish.id ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded, color: AppColors.primary),
                    ]),
                  ),
                ),
              )),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18)),
              onPressed: _selectedDish == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Input2Screen(date: widget.date, mealType: widget.mealType, dish: _selectedDish!, isPhotoFlow: !_databaseMode),
                        ),
                      );
                    },
              child: const Text('Continue to Input 2', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _modeButton(String label, bool active, VoidCallback onTap) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: active ? AppColors.primary : Colors.white,
        foregroundColor: active ? Colors.white : AppColors.foreground,
        side: BorderSide(color: active ? AppColors.primary : AppColors.border),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      onPressed: onTap,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}
