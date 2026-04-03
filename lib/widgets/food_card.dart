import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class FoodCard extends StatelessWidget {
  final String name;
  final String portion;
  final double portionValue;
  final int calories;
  final String? imagePath;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const FoodCard({
    super.key,
    required this.name,
    required this.portion,
    required this.portionValue,
    required this.calories,
    this.imagePath,
    required this.onDecrease,
    required this.onIncrease,
  });

  String get portionLabel {
    if (portionValue == 1) return '1 $portion';
    if (portionValue == 0.5) return '½ $portion';
    return '$portionValue ${portion}s';
  }

  @override
  Widget build(BuildContext context) {
    final pct = ((portionValue / 2).clamp(0.0, 1.0)) * 100;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: imagePath != null
                    ? Image.asset(imagePath!, width: 60, height: 60, fit: BoxFit.cover)
                    : Container(
                        width: 60,
                        height: 60,
                        color: AppColors.secondary,
                        child: const Icon(Icons.restaurant_outlined, color: AppColors.mutedForeground),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(portionLabel, style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
                    const SizedBox(height: 2),
                    Text(
                      '${(calories * portionValue).round()} kcal',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Edit', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _roundButton(Icons.remove, onDecrease),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: SizedBox(
                    height: 10,
                    child: Stack(
                      children: [
                        Container(color: AppColors.secondary),
                        FractionallySizedBox(
                          widthFactor: pct / 100,
                          child: Container(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _roundButton(Icons.add, onIncrease),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}
