import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/nutrient_bar.dart';
import '../widgets/screen_header.dart';

class Input3Screen extends StatelessWidget {
  static const routeName = '/input3';

  const Input3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    const consumed = 650;
    const remaining = 1150;
    const target = consumed + remaining;

    return Scaffold(
      appBar: const ScreenHeader(title: 'Input 3'),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(color: Color(0x4427AE60), blurRadius: 8, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Expanded(child: _ResultBlock(label: 'Calories Consumed', value: consumed)),
                            SizedBox(width: 12),
                            SizedBox(height: 72, child: VerticalDivider(color: Color(0x66FFFFFF))),
                            SizedBox(width: 12),
                            Expanded(child: _ResultBlock(label: 'Calories Remaining', value: remaining)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: SizedBox(
                            height: 12,
                            child: Stack(
                              children: [
                                Container(color: Color(0x55FFFFFF)),
                                FractionallySizedBox(
                                  widthFactor: consumed / target,
                                  child: Container(color: const Color(0xFFA8F5C8)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${((consumed / target) * 100).round()}% of daily target consumed',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Meal Breakdown', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                        SizedBox(height: 14),
                        _MealLine(dotColor: AppColors.primary, title: 'Nasi Lemak', calories: '450 kcal'),
                        SizedBox(height: 10),
                        _MealLine(dotColor: AppColors.orange, title: 'Watermelon (½ bowl)', calories: '25 kcal'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _sectionCard(
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nutrient Breakdown', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                        SizedBox(height: 14),
                        NutrientBar(label: 'Carbohydrates', value: 82, max: 150, color: AppColors.orange),
                        NutrientBar(label: 'Protein', value: 18, max: 60, color: AppColors.primary),
                        NutrientBar(label: 'Fat', value: 27, max: 50, color: Color(0xFF9B59B6)),
                        NutrientBar(label: 'Sugar', value: 12, max: 40, color: Color(0xFFE74C3C)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _sectionCard(
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 34),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Suggestion for your next meal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                              SizedBox(height: 6),
                              Text(
                                'Choose a lighter, higher-protein dinner such as grilled chicken salad or tofu with vegetables.',
                                style: TextStyle(color: AppColors.mutedForeground, height: 1.45),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
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
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back', style: TextStyle(color: AppColors.mutedForeground, fontWeight: FontWeight.w600)),
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
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                      child: const Text('Finish', style: TextStyle(fontWeight: FontWeight.w700)),
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

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _ResultBlock extends StatelessWidget {
  final String label;
  final int value;

  const _ResultBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Row(
          children: [
            Text('$value', style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w700)),
            const SizedBox(width: 6),
            const Text('kcal', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ],
    );
  }
}

class _MealLine extends StatelessWidget {
  final Color dotColor;
  final String title;
  final String calories;

  const _MealLine({required this.dotColor, required this.title, required this.calories});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500))),
        Text(calories, style: const TextStyle(color: AppColors.mutedForeground)),
      ],
    );
  }
}
