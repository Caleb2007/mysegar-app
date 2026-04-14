import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide LinearGradient;

class GrowthTimelineScreen extends StatefulWidget {
  const GrowthTimelineScreen({super.key});

  @override
  State<GrowthTimelineScreen> createState() => _GrowthTimelineScreenState();
}

class _GrowthTimelineScreenState extends State<GrowthTimelineScreen> {
  late final Timer _timer;
  int _currentDay = 1;

  static const _loopDurationSeconds = 10;
  static const _updateIntervalMs = 200;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: _updateIntervalMs),
      _updateDay,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateDay(Timer timer) {
    if (!mounted) return;

    final elapsedMs = timer.tick * _updateIntervalMs;
    final progress =
        (elapsedMs % (_loopDurationSeconds * 1000)) /
        (_loopDurationSeconds * 1000.0);
    final day = (progress * 100).ceil().clamp(1, 100);
    if (day != _currentDay) {
      setState(() => _currentDay = day);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFa8e063), Color(0xFF56ab2f)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: RiveAnimation.asset(
                  'assets/rive/tree_growth.riv',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Day $_currentDay',
                  style:
                      Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ) ??
                      const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
