import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/bottom_nav.dart';

class DiaryScreen extends StatefulWidget {
  static const routeName = '/diary';

  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  int selectedDay = 2;
  final weightController = TextEditingController(text: '74.2');
  final weekDays = const [
    {'label': 'Mon', 'num': 28},
    {'label': 'Tue', 'num': 29},
    {'label': 'Wed', 'num': 30},
    {'label': 'Thu', 'num': 1},
    {'label': 'Fri', 'num': 2},
    {'label': 'Sat', 'num': 3},
    {'label': 'Sun', 'num': 4},
  ];

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const totalCal = 790;
    const targetCal = 1800;
    const remaining = 1010;
    const netCal = 640;
    const exerciseCal = 150;

    final mealSections = [
      _MealSection('Breakfast', Icons.wb_sunny_outlined, const Color(0xFFF39C12), const [('Oats with banana', 300)]),
      _MealSection('Lunch', Icons.wb_cloudy_outlined, AppColors.primary, const [('Nasi Lemak', 450), ('Watermelon', 40)]),
      _MealSection('Dinner', Icons.nights_stay_outlined, const Color(0xFF9B59B6), const []),
      _MealSection('Snacks', Icons.local_cafe_outlined, const Color(0xFFE74C3C), const []),
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
                  const Text('Diary', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: weekDays.map((d) {
                        final selected = d['num'] == selectedDay;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () => setState(() => selectedDay = d['num']! as int),
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              width: 66,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: selected ? AppColors.primary : AppColors.card,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: selected ? AppColors.primary : AppColors.border),
                              ),
                              child: Column(
                                children: [
                                  Text(d['label']! as String, style: TextStyle(color: selected ? Colors.white70 : AppColors.mutedForeground)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${d['num']}',
                                    style: TextStyle(color: selected ? Colors.white : AppColors.foreground, fontWeight: FontWeight.w700, fontSize: 18),
                                  ),
                                  const SizedBox(height: 6),
                                  if (selected) Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Color(0x4427AE60), blurRadius: 8, offset: Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Expanded(child: _SummaryBlock('Total Calories', '$totalCal', 'kcal eaten')),
                            SizedBox(height: 64, child: VerticalDivider(color: Color(0x66FFFFFF))),
                            Expanded(child: _SummaryBlock('Remaining', '$remaining', 'kcal left')),
                            SizedBox(height: 64, child: VerticalDivider(color: Color(0x66FFFFFF))),
                            Expanded(child: _SummaryBlock('Net Calories', '$netCal', 'kcal net')),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: SizedBox(
                            height: 10,
                            child: Stack(
                              children: [
                                Container(color: const Color(0x55FFFFFF)),
                                FractionallySizedBox(
                                  widthFactor: totalCal / targetCal,
                                  child: Container(color: const Color(0xFFA8F5C8)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('$totalCal / $targetCal kcal daily target', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...mealSections.map((section) => _buildMealCard(context, section)),
                  _exerciseCard(context, exerciseCal),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.monitor_weight_outlined, color: AppColors.primary),
                            ),
                            const SizedBox(width: 10),
                            const Text('Today\'s Weight', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: weightController,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        decoration: const InputDecoration(border: InputBorder.none, hintText: 'Enter weight'),
                                      ),
                                    ),
                                    const Text('kg', style: TextStyle(color: AppColors.mutedForeground)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: () {},
                              child: const Text('Save'),
                            ),
                          ],
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
              active: AppTab.diary,
              onTap: (tab) {
                if (tab == AppTab.home) Navigator.pushReplacementNamed(context, '/');
                if (tab == AppTab.progress) Navigator.pushReplacementNamed(context, '/progress');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, _MealSection section) {
    final sectionCal = section.entries.fold<int>(0, (sum, e) => sum + e.$2);
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: section.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(section.icon, color: section.color, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(section.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
              if (sectionCal > 0) Text('$sectionCal kcal', style: TextStyle(color: section.color, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/input1'),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(color: section.color.withOpacity(0.12), shape: BoxShape.circle),
                  child: Icon(Icons.add, size: 16, color: section.color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (section.entries.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
              child: Text('Tap + to log ${section.label.toLowerCase()}', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.mutedForeground)),
            )
          else
            ...section.entries.asMap().entries.map((entry) {
              final idx = entry.key;
              final value = entry.value;
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: idx < section.entries.length - 1 ? const Border(bottom: BorderSide(color: AppColors.border)) : null,
                ),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: section.color, shape: BoxShape.circle)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(value.$1)),
                    Text('${value.$2} kcal', style: const TextStyle(color: AppColors.mutedForeground)),
                    const SizedBox(width: 8),
                    const Icon(Icons.edit_outlined, size: 14, color: AppColors.mutedForeground),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _exerciseCard(BuildContext context, int exerciseCal) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: const Color(0xFF2980B9).withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.pedal_bike_outlined, color: Color(0xFF2980B9), size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(child: Text('Exercise', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
              const Text('-150 kcal', style: TextStyle(color: Color(0xFF2980B9), fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/exercise1'),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(color: const Color(0xFF2980B9).withOpacity(0.12), shape: BoxShape.circle),
                  child: const Icon(Icons.add, size: 16, color: Color(0xFF2980B9)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _ExerciseEntry(title: 'Walking', detail: '30 min · -105 kcal'),
          const Divider(color: AppColors.border),
          const _ExerciseEntry(title: 'Cycling', detail: '15 min · -45 kcal'),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/exercise1'),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2980B9)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, size: 16, color: Color(0xFF2980B9)),
                  SizedBox(width: 6),
                  Text('Add Exercise', style: TextStyle(color: Color(0xFF2980B9), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealSection {
  final String label;
  final IconData icon;
  final Color color;
  final List<(String, int)> entries;

  const _MealSection(this.label, this.icon, this.color, this.entries);
}

class _SummaryBlock extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _SummaryBlock(this.label, this.value, this.unit);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
        Text(unit, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _ExerciseEntry extends StatelessWidget {
  final String title;
  final String detail;

  const _ExerciseEntry({required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF2980B9), shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(child: Text(title)),
        Text(detail, style: const TextStyle(color: AppColors.mutedForeground)),
        const SizedBox(width: 8),
        const Icon(Icons.edit_outlined, size: 14, color: AppColors.mutedForeground),
      ],
    );
  }
}
