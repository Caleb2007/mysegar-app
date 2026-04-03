import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/bottom_nav.dart';

class ProgressScreen extends StatelessWidget {
  static const routeName = '/progress';

  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weightData = const [
      ('Mon', 74.8),
      ('Tue', 74.6),
      ('Wed', 74.5),
      ('Thu', 74.3),
      ('Fri', 74.2),
      ('Sat', 74.0),
      ('Sun', 73.8),
    ];

    const currentWeight = 73.8;
    const targetWeight = 68.0;
    const startWeight = 77.0;
    const weeklyAvgCal = 1320;
    const targetCal = 1800;
    const streak = 4;

    final lostSoFar = startWeight - currentWeight;
    final totalToLose = startWeight - targetWeight;
    final goalPct = (lostSoFar / totalToLose).clamp(0, 1).toDouble();
    final calPct = (weeklyAvgCal / targetCal).clamp(0, 1).toDouble();

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Progress', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _cardHeader(Icons.trending_down_outlined, AppColors.primary.withOpacity(0.12), AppColors.primary, 'Weight Trend', 'Last 7 days', trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(999)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_downward, size: 12, color: AppColors.primary),
                              SizedBox(width: 4),
                              Text('1.0 kg', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )),
                        const SizedBox(height: 16),
                        SizedBox(height: 150, child: _WeightChart(data: weightData)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            _WeightStat(value: '74.8 kg', label: '7 days ago', color: AppColors.foreground, alignEnd: false),
                            Icon(Icons.arrow_forward, color: AppColors.mutedForeground),
                            _WeightStat(value: '73.8 kg', label: 'Today', color: AppColors.primary, alignEnd: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _cardHeader(Icons.local_fire_department_outlined, AppColors.orange.withOpacity(0.12), AppColors.orange, 'Weekly Average Calories', 'vs. daily target of $targetCal kcal'),
                        const SizedBox(height: 14),
                        const Text.rich(
                          TextSpan(
                            text: '$weeklyAvgCal ',
                            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.orange),
                            children: [
                              TextSpan(text: 'kcal/day', style: TextStyle(fontSize: 16, color: AppColors.mutedForeground, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        _bar(calPct, AppColors.orange),
                        const SizedBox(height: 8),
                        Text('${(calPct * 100).round()}% of daily target — good calorie control!', style: const TextStyle(color: AppColors.mutedForeground)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _cardHeader(Icons.emoji_events_outlined, const Color(0x229B59B6), const Color(0xFF9B59B6), 'Goal Progress', 'Weight loss journey', trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: const Color(0x229B59B6), borderRadius: BorderRadius.circular(999)),
                          child: Text('${(goalPct * 100).round()}%', style: const TextStyle(color: Color(0xFF9B59B6), fontWeight: FontWeight.w600)),
                        )),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const _WeightStat(value: '73.8 kg', label: 'Current', color: AppColors.foreground, alignEnd: false),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                children: [
                                  _bar(goalPct, const Color(0xFF9B59B6)),
                                  const SizedBox(height: 6),
                                  Text('${(currentWeight - targetWeight).toStringAsFixed(1)} kg to go', style: const TextStyle(color: AppColors.mutedForeground)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const _WeightStat(value: '68.0 kg', label: 'Target', color: Color(0xFF9B59B6), alignEnd: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _card(
                    child: Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(color: const Color(0xFFEAF7ED), borderRadius: BorderRadius.circular(18)),
                          child: const Icon(Icons.local_fire_department_outlined, color: AppColors.primary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Consistency Streak', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text('$streak days logged in a row', style: const TextStyle(color: AppColors.mutedForeground)),
                            ],
                          ),
                        ),
                        Text('$streak🔥', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.primary)),
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
              active: AppTab.progress,
              onTap: (tab) {
                if (tab == AppTab.home) Navigator.pushReplacementNamed(context, '/');
                if (tab == AppTab.diary) Navigator.pushReplacementNamed(context, '/diary');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
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

  Widget _cardHeader(IconData icon, Color bgColor, Color iconColor, String title, String subtitle, {Widget? trailing}) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              Text(subtitle, style: const TextStyle(color: AppColors.mutedForeground)),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _bar(double pct, Color color) {
    return ClipRRect(
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
    );
  }
}

class _WeightStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool alignEnd;

  const _WeightStat({required this.value, required this.label, required this.color, required this.alignEnd});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: const TextStyle(color: AppColors.mutedForeground)),
      ],
    );
  }
}

class _WeightChart extends StatelessWidget {
  final List<(String, double)> data;

  const _WeightChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minW = data.map((d) => d.$2).reduce((a, b) => a < b ? a : b) - 0.5;
        final maxW = data.map((d) => d.$2).reduce((a, b) => a > b ? a : b) + 0.5;
        final range = maxW - minW;
        final width = constraints.maxWidth;
        final chartHeight = 100.0;
        final points = <Offset>[];
        for (var i = 0; i < data.length; i++) {
          final x = (i / (data.length - 1)) * width;
          final y = chartHeight - (((data[i].$2 - minW) / range) * chartHeight);
          points.add(Offset(x, y));
        }
        return SizedBox(
          height: 140,
          child: Stack(
            children: [
              ...[0.0, 0.33, 0.66, 1.0].map((pct) => Positioned(
                    top: pct * chartHeight,
                    left: 0,
                    right: 0,
                    child: Container(height: 1, color: AppColors.border),
                  )),
              CustomPaint(size: Size(width, chartHeight), painter: _WeightChartPainter(points)),
              ...List.generate(points.length, (i) {
                final point = points[i];
                return Positioned(
                  left: point.dx - 5,
                  top: point.dy - 5,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                );
              }),
              Positioned(
                top: 112,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: data.map((d) => Text(d.$1, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12))).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  final List<Offset> points;

  _WeightChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(points[i].dx, points[i].dy);
      } else {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
