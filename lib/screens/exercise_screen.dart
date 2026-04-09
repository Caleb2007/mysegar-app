import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models/exercise_entry.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

class ExerciseScreen extends StatefulWidget {
  final DateTime date;
  final ExerciseEntry? original;

  const ExerciseScreen({super.key, required this.date, this.original});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  ExerciseCatalogItem? _selected;
  int _minutes = 20;

  @override
  void initState() {
    super.initState();
    if (widget.original != null) {
      final catalog = AppScope.of(context).exercisesCatalog.firstWhere((e) => e.id == widget.original!.exerciseId);
      _selected = catalog;
      _minutes = widget.original!.durationMinutes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalog = AppScope.of(context).exercisesCatalog;
    final burned = ((_selected?.caloriesPerMinute ?? 0) * _minutes).round();
    return GradientScaffold(
      tone: PageTone.orange,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)), const SizedBox(width: 8), const Text('Exercise', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))]),
          const SizedBox(height: 20),
          CardShell(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Choose exercise type', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              ...catalog.map((item) => ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    tileColor: _selected?.id == item.id ? AppColors.orangeSoft : AppColors.secondary,
                    title: Text(item.name),
                    subtitle: Text('${item.caloriesPerMinute.toStringAsFixed(1)} kcal/min'),
                    trailing: _selected?.id == item.id ? const Icon(Icons.check_circle, color: AppColors.orange) : null,
                    onTap: () => setState(() => _selected = item),
                  )),
              const SizedBox(height: 18),
              const Text('Duration', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Row(children: [
                _step(Icons.remove_rounded, () => setState(() => _minutes = (_minutes - 5).clamp(0, 240))),
                const SizedBox(width: 12),
                Expanded(child: Center(child: Text('$_minutes min', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)))),
                const SizedBox(width: 12),
                _step(Icons.add_rounded, () => setState(() => _minutes = (_minutes + 5).clamp(0, 240))),
              ]),
              const SizedBox(height: 18),
              Text('Estimated burn: $burned kcal', style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w700)),
            ]),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18)),
              onPressed: _selected == null
                  ? null
                  : () async {
                      final state = AppScope.of(context);
                      if (widget.original == null) {
                        await state.addExercise(date: widget.date, exercise: _selected!, durationMinutes: _minutes);
                      } else {
                        await state.updateExercise(original: widget.original!, exercise: _selected!, durationMinutes: _minutes);
                      }
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
              child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _step(IconData icon, VoidCallback onTap) => InkWell(onTap: onTap, child: Container(width: 46, height: 46, decoration: BoxDecoration(color: AppColors.orangeSoft, borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: AppColors.orange)));
}
