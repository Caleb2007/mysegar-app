import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _days = 7;
  static const _supportiveMessages = [
    'A calm week of progress — keep it going.',
    'Steady choices build strong momentum.',
    'You are showing real consistency this week.',
    'Good calorie control — one step at a time.',
    'Balanced logging is helping your progress.',
    'Nice work staying aware of your intake.',
    'A thoughtful week — keep trusting the process.',
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final weights = state.weightRange(days: _days);
    final startWeight = weights.first.weightKg;
    final currentWeight = state.weightForDate(DateTime.now())?.weightKg ?? state.lastKnownWeightBefore(DateTime.now());
    final targetWeight = state.profile.targetWeightKg;
    final weeklyAvgCal = state.weeklyAverageCalories();
    final targetCal = state.profile.dailyTargetCalories;
    final streak = state.loggingStreak();
    final delta = currentWeight - startWeight;
    final lostSoFar = max(0, startWeight - currentWeight);
    final totalToLose = max(0.1, startWeight - targetWeight);
    final goalPct = (lostSoFar / totalToLose).clamp(0.0, 1.0);
    final calPct = targetCal <= 0 ? 0.0 : (weeklyAvgCal / targetCal).clamp(0.0, 1.0);
    final currentDisplayWeight = state.latestWeightEntry()?.weightKg ?? state.profile.weightKg;
    final todayIndex = DateTime.now().weekday - 1;

    return GradientScaffold(
      tone: PageTone.purple,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Progress', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          CardShell(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.show_chart_rounded, color: AppColors.primary)),
                const SizedBox(width: 12),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Weight Trend', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), Text('See your recent weight pattern', style: TextStyle(color: AppColors.mutedForeground))])),
                _DeltaBadge(delta: delta),
              ]),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(999)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    _segButton('7D', _days == 7, () => setState(() => _days = 7)),
                    _segButton('30D', _days == 30, () => setState(() => _days = 30)),
                  ]),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(height: 180, child: _WeightLineChart(data: weights, days: _days)),
              const SizedBox(height: 14),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _WeightStat(value: '${startWeight.toStringAsFixed(1)} kg', label: _days == 7 ? '7 days ago' : '30 days ago', color: AppColors.foreground),
                const Icon(Icons.arrow_forward_rounded, color: AppColors.mutedForeground),
                _WeightStat(value: '${currentWeight.toStringAsFixed(1)} kg', label: 'Today', color: AppColors.primary, alignEnd: true),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          CardShell(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.orangeSoft, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.local_fire_department_outlined, color: AppColors.orange)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Weekly Average Calories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), Text('vs. daily target of $targetCal kcal', style: const TextStyle(color: AppColors.mutedForeground))]))]),
              const SizedBox(height: 16),
              Text('$weeklyAvgCal', style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w800, color: AppColors.orange)),
              const Text('kcal/day', style: TextStyle(color: AppColors.mutedForeground, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _progressBar(calPct, AppColors.orange),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.orangeSoft, borderRadius: BorderRadius.circular(14)),
                child: Text('${(calPct * 100).round()}% of daily target — ${_supportiveMessages[todayIndex]}', style: const TextStyle(color: AppColors.foreground, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          CardShell(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.purpleSoft, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.emoji_events_outlined, color: AppColors.purple)), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Goal Progress', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), Text('Weight journey', style: TextStyle(color: AppColors.mutedForeground))])), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColors.purpleSoft, borderRadius: BorderRadius.circular(999)), child: Text('${(goalPct * 100).round()}%', style: const TextStyle(color: AppColors.purple, fontWeight: FontWeight.w800)))]),
              const SizedBox(height: 18),
              Row(children: [
                _WeightStat(value: '${currentDisplayWeight.toStringAsFixed(1)} kg', label: 'Current', color: AppColors.foreground),
                const SizedBox(width: 12),
                Expanded(child: Column(children: [_progressBar(goalPct, AppColors.purple), const SizedBox(height: 8), Text('${(currentDisplayWeight - targetWeight).abs().toStringAsFixed(1)} kg to go', style: const TextStyle(color: AppColors.mutedForeground))])),
                const SizedBox(width: 12),
                _WeightStat(value: '${targetWeight.toStringAsFixed(1)} kg', label: 'Target', color: AppColors.purple, alignEnd: true),
              ]),
            ]),
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFFF5E4), Color(0xFFFFFBF1)]),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFF2E2BD)),
            ),
            child: Row(children: [
              Container(width: 58, height: 58, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.local_fire_department_rounded, color: AppColors.orange, size: 30)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Consistency Streak', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text('$streak days logged in a row', style: const TextStyle(color: AppColors.mutedForeground, fontSize: 16))])),
              Text('$streak', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: AppColors.orange)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _segButton(String label, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(duration: const Duration(milliseconds: 220), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: active ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(999)), child: Text(label, style: TextStyle(color: active ? Colors.white : AppColors.mutedForeground, fontWeight: FontWeight.w800))),
    );
  }

  Widget _progressBar(double pct, Color color) => ClipRRect(borderRadius: BorderRadius.circular(999), child: SizedBox(height: 12, child: Stack(children: [Container(color: AppColors.secondary), FractionallySizedBox(widthFactor: pct, child: Container(color: color))])));
}

class _WeightStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool alignEnd;
  const _WeightStat({required this.value, required this.label, required this.color, this.alignEnd = false});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)), Text(label, style: const TextStyle(color: AppColors.mutedForeground))]);
  }
}

class _DeltaBadge extends StatelessWidget {
  final double delta;
  const _DeltaBadge({required this.delta});

  @override
  Widget build(BuildContext context) {
    final improved = delta < 0;
    final neutral = delta == 0;
    final bg = neutral ? AppColors.secondary : improved ? AppColors.primarySoft : AppColors.redSoft;
    final fg = neutral ? AppColors.mutedForeground : improved ? AppColors.primary : AppColors.red;
    final arrow = neutral ? '•' : improved ? '↓' : '↑';
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)), child: Text('$arrow ${delta.abs().toStringAsFixed(1)} kg', style: TextStyle(color: fg, fontWeight: FontWeight.w800)));
  }
}

class _WeightLineChart extends StatelessWidget {
  final List<dynamic> data;
  final int days;
  const _WeightLineChart({required this.data, required this.days});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox();
    final weights = data.map((e) => e.weightKg as double).toList();
    final minW = weights.reduce(min);
    final maxW = weights.reduce(max);
    final padding = max(0.6, (maxW - minW) * 0.25);
    final scaleMax = maxW + padding;
    final scaleMin = minW - padding;
    final range = max(0.1, scaleMax - scaleMin);
    final scaleValues = List.generate(4, (i) => scaleMax - (range / 3) * i);
    return LayoutBuilder(builder: (context, constraints) {
      final chartWidth = constraints.maxWidth - 56;
      final chartHeight = constraints.maxHeight;
      final stepX = data.length == 1 ? 0.0 : chartWidth / (data.length - 1);
      final points = <Offset>[];
      for (var i = 0; i < data.length; i++) {
        final normalized = (data[i].weightKg - scaleMin) / range;
        points.add(Offset(stepX * i, chartHeight - 28 - normalized * (chartHeight - 40)));
      }
      final labels = <Widget>[];
      for (var i = 0; i < data.length; i++) {
        final show = days == 7 || i == 0 || i == data.length - 1 || i % 5 == 0;
        labels.add(Expanded(child: Center(child: Text(show ? (days == 7 ? DateFormat('E').format(data[i].date) : DateFormat('d').format(data[i].date)) : '', style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)))));
      }
      return Row(children: [
        Expanded(
          child: Column(children: [
            Expanded(child: CustomPaint(size: Size(chartWidth, chartHeight), painter: _WeightPainter(points: points, width: chartWidth, height: chartHeight - 28))),
            const SizedBox(height: 8),
            Row(children: labels),
          ]),
        ),
        const SizedBox(width: 8),
        SizedBox(width: 48, child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: scaleValues.map((v) => Text(v.toStringAsFixed(1), style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground))).toList())),
      ]);
    });
  }
}

class _WeightPainter extends CustomPainter {
  final List<Offset> points;
  final double width;
  final double height;
  const _WeightPainter({required this.points, required this.width, required this.height});

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = AppColors.border..strokeWidth = 1;
    for (int i = 0; i < 4; i++) {
      final y = (height / 3) * i;
      canvas.drawLine(Offset(0, y), Offset(width, y), grid);
    }
    final line = Paint()..color = AppColors.primary..strokeWidth = 4..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, line);
    final pointFill = Paint()..color = AppColors.primary;
    for (final p in points) {
      canvas.drawCircle(p, 7, pointFill);
      canvas.drawCircle(p, 3.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _WeightPainter oldDelegate) => oldDelegate.points != points;
}
