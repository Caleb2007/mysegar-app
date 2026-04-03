import 'package:flutter/material.dart';

import '../models/food_item.dart';
import '../theme/app_colors.dart';
import '../widgets/food_card.dart';
import '../widgets/screen_header.dart';

class Input2Screen extends StatefulWidget {
  static const routeName = '/input2';

  const Input2Screen({super.key});

  @override
  State<Input2Screen> createState() => _Input2ScreenState();
}

class _Input2ScreenState extends State<Input2Screen> {
  List<FoodItem> foods = const [
    FoodItem(
      id: '1',
      name: 'Nasi Lemak',
      portion: 'plate',
      portionValue: 1,
      calories: 450,
      imagePath: 'assets/images/nasi-lemak.png',
    ),
    FoodItem(
      id: '2',
      name: 'Watermelon',
      portion: 'bowl',
      portionValue: 0.5,
      calories: 50,
      imagePath: 'assets/images/watermelon.png',
    ),
  ];

  void updatePortion(String id, double value) {
    setState(() {
      foods = foods
          .map((f) => f.id == id ? f.copyWith(portionValue: value.clamp(0.5, 2.0)) : f)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalCalories = foods.fold<int>(0, (sum, food) => sum + (food.calories * food.portionValue).round());

    return Scaffold(
      appBar: const ScreenHeader(title: 'Input 2'),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Adjust your food portions below', style: TextStyle(color: AppColors.mutedForeground)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Estimated Total', style: TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
                            Text('$totalCalories kcal', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ],
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.calculate_outlined, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...foods.map(
                    (food) => FoodCard(
                      name: food.name,
                      portion: food.portion,
                      portionValue: food.portionValue,
                      calories: food.calories,
                      imagePath: food.imagePath,
                      onDecrease: () => updatePortion(food.id, food.portionValue - 0.5),
                      onIncrease: () => updatePortion(food.id, food.portionValue + 0.5),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary, width: 1.5),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline, color: AppColors.primary),
                          SizedBox(width: 10),
                          Text('Add Food from Database', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.mutedForeground),
                      label: const Text('Back', style: TextStyle(color: AppColors.mutedForeground, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/input3'),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Calculate Calories', style: TextStyle(fontWeight: FontWeight.w700)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
