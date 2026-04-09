import 'package:mysegar/models/meal_entry.dart';
import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'input1_screen.dart';
import 'personal_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final today = DateTime.now();
    final summary = state.summaryForDate(today);
    final progressPct = (summary.progress * 100).round();
    final greeting = state.greetingForNow();
    final mealCards = [
      for (final type in [state.autoMealTypeForNow(), ...MealType.values.where((e) => e != state.autoMealTypeForNow())])
        if (state.mealsForSection(today, type).isNotEmpty)
          {'type': type, 'cal': state.mealTotalForSection(today, type)}
    ];

    return GradientScaffold(
      tone: PageTone.green,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: const [Icon(Icons.eco_rounded, color: AppColors.primary, size: 28), SizedBox(width: 10), Text('MySegar', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary))]),
              ProfileAvatar(name: state.profile.name, imagePath: state.profile.profileImagePath, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalDetailsScreen())), showEditHint: true),
            ],
          ),
          const SizedBox(height: 16),
          Text('$greeting,', style: const TextStyle(color: AppColors.mutedForeground, fontSize: 16)),
          Text(state.profile.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.foreground)),
          const SizedBox(height: 18),
          CardShell(
            child: Row(children: [
              Container(
                width: 126,
                height: 126,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 10)),
                child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text('$progressPct%', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary)), const Text('of goal', style: TextStyle(color: AppColors.mutedForeground))])),
              ),
              const SizedBox(width: 18),
              Expanded(child: Column(children: [
                _StatItem(value: '${state.profile.dailyTargetCalories}', label: 'Target', color: AppColors.foreground),
                const Divider(color: AppColors.border),
                _StatItem(value: '${summary.totalCalories}', label: 'Eaten', color: AppColors.orange),
                const Divider(color: AppColors.border),
                _StatItem(value: '${summary.remainingCalories}', label: 'Left', color: summary.remainingCalories < 0 ? AppColors.red : AppColors.primary),
              ])),
            ]),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _MiniCard(label: 'Calories Eaten', value: '${summary.totalCalories}', icon: Icons.local_fire_department_outlined, color: AppColors.orange)),
            const SizedBox(width: 12),
            Expanded(child: _MiniCard(label: 'Calories Left', value: '${summary.remainingCalories}', icon: Icons.eco_outlined, color: summary.remainingCalories < 0 ? AppColors.red : AppColors.primary)),
          ]),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Input1Screen(date: today, mealType: state.autoMealTypeForNow()))),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('Start Assessment', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Today's Meals", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          if (mealCards.isEmpty)
            const CardShell(child: Text('No meals logged yet. Start an assessment to add your first meal.', style: TextStyle(color: AppColors.mutedForeground)))
          else
            ...mealCards.map((item) {
              final mealType = item['type']! as MealType;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: CardShell(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(14)), child: Icon(_iconForMeal(mealType), color: AppColors.primary)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(mealType.label, style: const TextStyle(fontWeight: FontWeight.w700)), Text('Logged today', style: const TextStyle(color: AppColors.mutedForeground))])),
                    Text('${item['cal']} kcal', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.orange)),
                  ]),
                ),
              );
            }),
        ]),
      ),
    );
  }

  IconData _iconForMeal(MealType type) => switch (type) {
        MealType.breakfast => Icons.wb_sunny_outlined,
        MealType.lunch => Icons.lunch_dining_outlined,
        MealType.dinner => Icons.nightlight_round,
        MealType.supper => Icons.local_cafe_outlined,
      };
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatItem({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: AppColors.mutedForeground)), Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: color))]);
  }
}

class _MiniCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _MiniCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return CardShell(
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color)),
        const SizedBox(height: 18),
        Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.mutedForeground)),
      ]),
    );
  }
}
