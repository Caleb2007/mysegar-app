import 'package:flutter/material.dart';

import 'ml_demo_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/calorie_card.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const caloriesEaten = 520;
    const caloriesTarget = 1800;
    const caloriesRemaining = caloriesTarget - caloriesEaten;
    final meals = const [
      {'label': 'Breakfast', 'time': '7:30 AM', 'cal': '320 kcal', 'icon': Icons.wb_sunny_outlined},
      {'label': 'Lunch', 'time': '12:30 PM', 'cal': '200 kcal', 'icon': Icons.wb_cloudy_outlined},
    ];

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.eco_outlined, color: AppColors.primary, size: 28),
                          SizedBox(width: 8),
                          Text(
                            'MySegar',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_outline, color: AppColors.primary),
                      )
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text('Good morning,', style: TextStyle(color: AppColors.mutedForeground, fontSize: 16)),
                  const Text('Ahmad Rizal', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 128,
                              height: 128,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primary, width: 12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text('29%', style: TextStyle(color: AppColors.primary, fontSize: 28, fontWeight: FontWeight.w700)),
                                    Text('of goal', style: TextStyle(color: AppColors.mutedForeground)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                children: const [
                                  _StatItem(value: '1800', label: 'Target', valueColor: AppColors.foreground),
                                  Divider(color: AppColors.border),
                                  _StatItem(value: '520', label: 'Eaten', valueColor: AppColors.orange),
                                  Divider(color: AppColors.border),
                                  _StatItem(value: '1280', label: 'Left', valueColor: AppColors.primary),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      CalorieCard(label: 'Calories Eaten', value: caloriesEaten, icon: Icons.local_fire_department_outlined, accentColor: AppColors.orange),
                      SizedBox(width: 12),
                      CalorieCard(label: 'Calories Remaining', value: caloriesRemaining, icon: Icons.eco_outlined, accentColor: AppColors.primary),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/input1'),
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Start Assessment', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: () => Navigator.pushNamed(context, MlDemoScreen.routeName),
                      icon: const Icon(Icons.memory_outlined),
                      label: const Text('Open TFLite Demo', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text('Today\'s Meals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  ...meals.map(
                    (meal) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(meal['icon']! as IconData, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(meal['label']! as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                                Text(meal['time']! as String, style: const TextStyle(color: AppColors.mutedForeground)),
                              ],
                            ),
                          ),
                          Text(meal['cal']! as String, style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F6FC),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFB2E4F5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.water_drop_outlined, color: Color(0xFF2980B9)),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Water Intake', style: TextStyle(color: Color(0xFF1A5276), fontWeight: FontWeight.w700)),
                              Text('5 / 8 glasses today', style: TextStyle(color: Color(0xFF2980B9))),
                            ],
                          ),
                        ),
                        Row(
                          children: List.generate(
                            8,
                            (i) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                color: i < 5 ? const Color(0xFF2980B9) : const Color(0xFFB2E4F5),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
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
            child: BottomNav(
              active: AppTab.home,
              onTap: (tab) {
                if (tab == AppTab.diary) Navigator.pushReplacementNamed(context, '/diary');
                if (tab == AppTab.progress) Navigator.pushReplacementNamed(context, '/progress');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _StatItem({required this.value, required this.label, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: valueColor, fontSize: 24, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: AppColors.mutedForeground)),
      ],
    );
  }
}
