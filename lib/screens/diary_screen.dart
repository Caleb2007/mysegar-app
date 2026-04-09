import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_state.dart';
import '../models/exercise_entry.dart';
import '../models/meal_entry.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'exercise_screen.dart';
import 'input1_screen.dart';
import 'input2_screen.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  late DateTime selectedDate;
  late TextEditingController weightController;

  @override
  void initState() {
    super.initState();
    selectedDate = _normalizeDate(DateTime.now());
    weightController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncWeightController());
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);
  List<DateTime> get _weekDates => List.generate(7, (index) => _normalizeDate(DateTime.now()).subtract(Duration(days: 6 - index)));

  void _syncWeightController() {
    final state = AppScope.of(context);
    final weight = state.weightForDate(selectedDate)?.weightKg ?? state.lastKnownWeightBefore(selectedDate);
    weightController.text = weight.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final summary = state.summaryForDate(selectedDate);
    final breakfast = state.mealsForSection(selectedDate, MealType.breakfast);
    final lunch = state.mealsForSection(selectedDate, MealType.lunch);
    final dinner = state.mealsForSection(selectedDate, MealType.dinner);
    final supper = state.mealsForSection(selectedDate, MealType.supper);
    final exercises = state.exerciseEntriesForDate(selectedDate);
    final currentWeight = state.weightForDate(selectedDate)?.weightKg ?? state.lastKnownWeightBefore(selectedDate);

    return GradientScaffold(
      tone: PageTone.green,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Diary', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: _weekDates.map((date) {
              final selected = AppState.isSameDate(date, selectedDate);
              final hasData = state.mealsForDate(date).isNotEmpty || state.exerciseEntriesForDate(date).isNotEmpty || state.weightForDate(date) != null;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () => setState(() {
                    selectedDate = date;
                    _syncWeightController();
                  }),
                  child: Container(
                    width: 74,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(color: selected ? AppColors.primary : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: selected ? AppColors.primary : AppColors.border), boxShadow: const [BoxShadow(color: Color(0x0B000000), blurRadius: 8, offset: Offset(0, 4))]),
                    child: Column(children: [Text(DateFormat('E').format(date), style: TextStyle(color: selected ? Colors.white70 : AppColors.mutedForeground, fontWeight: FontWeight.w700)), const SizedBox(height: 6), Text(DateFormat('d').format(date), style: TextStyle(color: selected ? Colors.white : AppColors.foreground, fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 6), Container(width: 8, height: 8, decoration: BoxDecoration(color: hasData ? (selected ? Colors.white : AppColors.primary) : Colors.transparent, shape: BoxShape.circle))]),
                  ),
                ),
              );
            }).toList()),
          ),
          const SizedBox(height: 16),
          CardShell(
            child: Column(children: [
              Row(children: [Expanded(child: _Summary(label: 'Total', value: '${summary.totalCalories}', color: AppColors.foreground)), Expanded(child: _Summary(label: 'Remaining', value: '${summary.remainingCalories}', color: summary.remainingCalories < 0 ? AppColors.red : AppColors.primary)), Expanded(child: _Summary(label: 'Net', value: '${summary.netCalories}', color: summary.netCalories > summary.dailyTarget ? AppColors.red : AppColors.orange))]),
              const SizedBox(height: 12),
              ClipRRect(borderRadius: BorderRadius.circular(999), child: SizedBox(height: 10, child: Stack(children: [Container(color: AppColors.secondary), FractionallySizedBox(widthFactor: summary.progress, child: Container(color: AppColors.primary))]))),
              const SizedBox(height: 8),
              Text('${summary.netCalories}/${summary.dailyTarget} kcal daily target', style: TextStyle(color: summary.netCalories > summary.dailyTarget ? AppColors.red : AppColors.mutedForeground)),
            ]),
          ),
          _mealSection(context, state, MealType.breakfast, breakfast),
          _mealSection(context, state, MealType.lunch, lunch),
          _mealSection(context, state, MealType.dinner, dinner),
          if (supper.isNotEmpty) _mealSection(context, state, MealType.supper, supper),
          _exerciseSection(context, state, exercises),
          const SizedBox(height: 16),
          CardShell(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Today weight', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            Row(children: [Expanded(child: TextField(controller: weightController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(filled: true, fillColor: AppColors.secondary, suffixText: 'kg', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)))), const SizedBox(width: 12), FilledButton(onPressed: () async {
              final value = double.tryParse(weightController.text.trim());
              if (value == null) return;
              await state.saveWeight(date: selectedDate, weightKg: value);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Weight saved')));
              setState(() {});
            }, style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16)), child: const Text('Save'))]),
            const SizedBox(height: 10),
            Text('Current weight for selected day: ${currentWeight.toStringAsFixed(1)} kg', style: const TextStyle(color: AppColors.mutedForeground)),
          ])),
        ]),
      ),
    );
  }

  Widget _mealSection(BuildContext context, AppState state, MealType mealType, List<MealEntry> items) {
    final sectionCalories = items.fold<int>(0, (sum, item) => sum + item.calories);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: CardShell(
        child: Column(children: [
          Row(children: [Expanded(child: Text(mealType.label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))), if (sectionCalories > 0) Text('$sectionCalories kcal', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)), const SizedBox(width: 8), IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Input1Screen(date: selectedDate, mealType: mealType))), icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary))]),
          if (items.isEmpty)
            Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(16)), child: Text('No items yet', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.mutedForeground)))
          else
            ...items.map((item) => Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Row(children: [Expanded(child: Text(item.dishName, style: const TextStyle(fontWeight: FontWeight.w700))), Text('${item.calories} kcal', style: const TextStyle(color: AppColors.mutedForeground)), IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Input2Screen(date: selectedDate, mealType: mealType, dish: state.dishes.firstWhere((d) => d.id == item.dishId), originalEntry: item))), icon: const Icon(Icons.edit_outlined, size: 18)), IconButton(onPressed: () => _confirmDeleteMeal(context, state, item), icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.red))]),
            )),
        ]),
      ),
    );
  }

  Widget _exerciseSection(BuildContext context, AppState state, List<ExerciseEntry> items) {
    final total = items.fold<int>(0, (sum, item) => sum + item.caloriesBurned);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: CardShell(
        child: Column(children: [
          Row(children: [const Expanded(child: Text('Exercise', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))), if (total > 0) Text('-$total kcal', style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w700))]),
          const SizedBox(height: 10),
          if (items.isEmpty)
            Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(16)), child: const Text('No exercise logged yet', textAlign: TextAlign.center, style: TextStyle(color: AppColors.mutedForeground)))
          else
            ...items.map((item) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
                  child: Row(children: [Expanded(child: Text(item.exerciseName, style: const TextStyle(fontWeight: FontWeight.w700))), Text('${item.durationMinutes} min · -${item.caloriesBurned} kcal', style: const TextStyle(color: AppColors.mutedForeground)), IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciseScreen(date: selectedDate, original: item))), icon: const Icon(Icons.edit_outlined, size: 18)), IconButton(onPressed: () => _confirmDeleteExercise(context, state, item), icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.red))]),
                )),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciseScreen(date: selectedDate))), style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)), icon: const Icon(Icons.add_rounded), label: const Text('Add exercise'))),
        ]),
      ),
    );
  }

  Future<void> _confirmDeleteMeal(BuildContext context, AppState state, MealEntry item) async {
    final confirm = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('Delete food'), content: Text('Delete ${item.dishName}?'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete'))]));
    if (confirm != true) return;
    await state.deleteMeal(item.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Food deleted')));
    setState(() {});
  }

  Future<void> _confirmDeleteExercise(BuildContext context, AppState state, ExerciseEntry item) async {
    final confirm = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('Delete exercise'), content: Text('Delete ${item.exerciseName}?'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete'))]));
    if (confirm != true) return;
    await state.deleteExercise(item.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exercise deleted')));
    setState(() {});
  }
}

class _Summary extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Summary({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color)), Text(label, style: const TextStyle(color: AppColors.mutedForeground))]);
  }
}
