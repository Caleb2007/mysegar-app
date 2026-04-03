import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class NutrientBar extends StatelessWidget {
  final String label;
  final num value;
  final num max;
  final String unit;
  final Color color;

  const NutrientBar({
    super.key,
    required this.label,
    required this.value,
    required this.max,
    this.unit = 'g',
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (value / max).clamp(0, 1).toDouble();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Text('$value$unit', style: const TextStyle(fontSize: 13, color: AppColors.mutedForeground)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 10,
              child: Stack(
                children: [
                  Container(color: AppColors.secondary),
                  FractionallySizedBox(widthFactor: pct, child: Container(color: color)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
