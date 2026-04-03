import 'package:flutter/material.dart';

import '../models/exercise_item.dart';
import '../theme/app_colors.dart';
import '../widgets/screen_header.dart';

class ExerciseScreen extends StatefulWidget {
  static const routeName = '/exercise1';

  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  static const double weightKg = 74.2;
  final exercises = const [
    ExerciseItem(name: 'Walking', icon: Icons.directions_walk_outlined, met: 3.5, color: AppColors.primary),
    ExerciseItem(name: 'Running', icon: Icons.fitness_center_outlined, met: 8.0, color: Color(0xFFE74C3C)),
    ExerciseItem(name: 'Cycling', icon: Icons.pedal_bike_outlined, met: 6.0, color: Color(0xFF2980B9)),
    ExerciseItem(name: 'Badminton', icon: Icons.sports_tennis_outlined, met: 5.5, color: AppColors.orange),
    ExerciseItem(name: 'Swimming', icon: Icons.pool_outlined, met: 7.0, color: Color(0xFF1ABC9C)),
    ExerciseItem(name: 'Yoga', icon: Icons.self_improvement_outlined, met: 3.0, color: Color(0xFF9B59B6)),
    ExerciseItem(name: 'HIIT', icon: Icons.flash_on_outlined, met: 10.0, color: Color(0xFFE67E22)),
    ExerciseItem(name: 'Football', icon: Icons.sports_football_outlined, met: 7.5, color: Color(0xFF16A085)),
  ];

  late ExerciseItem selectedExercise = exercises.first;
  int duration = 30;
  bool showCustom = false;
  final customDurationController = TextEditingController();

  int get activeDuration => showCustom ? int.tryParse(customDurationController.text) ?? 0 : duration;
  int get estimatedCal => ((selectedExercise.met * weightKg * activeDuration) / 60).round();

  @override
  void dispose() {
    customDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenHeader(title: 'Exercise 1'),
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
                      color: selectedExercise.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: selectedExercise.color.withOpacity(0.22)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(color: selectedExercise.color.withOpacity(0.18), shape: BoxShape.circle),
                          child: Icon(selectedExercise.icon, color: selectedExercise.color, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${selectedExercise.name} · $activeDuration min', style: const TextStyle(color: AppColors.mutedForeground)),
                              const SizedBox(height: 3),
                              const Text('Estimated Burn', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('$estimatedCal', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w700, color: selectedExercise.color)),
                            const Text('kcal', style: TextStyle(color: AppColors.mutedForeground)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text('Select Exercise', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exercises.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (context, index) {
                      final ex = exercises[index];
                      final selected = ex.name == selectedExercise.name;
                      return InkWell(
                        onTap: () => setState(() => selectedExercise = ex),
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: selected ? ex.color.withOpacity(0.1) : AppColors.card,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: selected ? ex.color : AppColors.border, width: selected ? 2 : 1),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: selected ? ex.color.withOpacity(0.15) : AppColors.secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(ex.icon, color: selected ? ex.color : AppColors.mutedForeground),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    ex.name,
                                    style: TextStyle(
                                      color: selected ? ex.color : AppColors.mutedForeground,
                                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              if (selected)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(color: ex.color, shape: BoxShape.circle),
                                    child: const Icon(Icons.check, color: Colors.white, size: 10),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  const Text('Duration', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [15, 30, 45, 60].map((mins) {
                      final active = !showCustom && duration == mins;
                      return InkWell(
                        onTap: () => setState(() {
                          duration = mins;
                          showCustom = false;
                          customDurationController.clear();
                        }),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          decoration: BoxDecoration(
                            color: active ? AppColors.primary : AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: active ? AppColors.primary : AppColors.border, width: active ? 2 : 1),
                          ),
                          child: Column(
                            children: [
                              Text('$mins', style: TextStyle(color: active ? Colors.white : AppColors.foreground, fontWeight: FontWeight.w700)),
                              Text('min', style: TextStyle(color: active ? Colors.white70 : AppColors.mutedForeground)),
                            ],
                          ),
                        ),
                      );
                    }).toList()
                      ..add(
                        InkWell(
                          onTap: () => setState(() => showCustom = true),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                            decoration: BoxDecoration(
                              color: showCustom ? AppColors.primary.withOpacity(0.08) : AppColors.card,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: showCustom ? AppColors.primary : AppColors.border, width: showCustom ? 2 : 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit_outlined, size: 16, color: showCustom ? AppColors.primary : AppColors.mutedForeground),
                                const SizedBox(width: 6),
                                Text('Custom', style: TextStyle(color: showCustom ? AppColors.primary : AppColors.mutedForeground)),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ),
                  if (showCustom) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: customDurationController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Enter minutes',
                                border: InputBorder.none,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const Text('min', style: TextStyle(color: AppColors.mutedForeground)),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, size: 16, color: AppColors.mutedForeground),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Based on your weight ($weightKg kg) and ${selectedExercise.name.toLowerCase()}'s intensity (MET ${selectedExercise.met})",
                            style: const TextStyle(color: AppColors.mutedForeground),
                          ),
                        )
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
                      child: const Text('Exit', style: TextStyle(color: AppColors.mutedForeground, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.check_circle_outline),
                      label: Text('Done · -$estimatedCal kcal', style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
