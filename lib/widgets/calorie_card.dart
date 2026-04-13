import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CalorieCard extends StatelessWidget {
  final String label;
  final int value;
  final String unit;
  final IconData icon;
  final Color accentColor;

  const CalorieCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.unit = 'kcal',
    this.accentColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor),
            ),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: TextStyle(
                color: accentColor,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(unit, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
