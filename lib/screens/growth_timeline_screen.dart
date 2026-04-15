import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GrowthTimelineScreen extends StatefulWidget {
  const GrowthTimelineScreen({super.key});

  @override
  State<GrowthTimelineScreen> createState() => _GrowthTimelineScreenState();
}

class _GrowthTimelineScreenState extends State<GrowthTimelineScreen>
    with TickerProviderStateMixin {
  late final Timer _timer;
  late final AnimationController _animationController;
  bool _isHoldingAtEnd = false;
  int _currentDay = 1;

  static const _activeDurationSeconds = 10;
  static const _pauseDurationSeconds = 2;
  static const _cycleDurationSeconds =
      _activeDurationSeconds + _pauseDurationSeconds;
  static const _updateIntervalMs = 200;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: _activeDurationSeconds),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && !_isHoldingAtEnd) {
          _holdAtEnd();
        }
      });

    _animationController.forward();
    _timer = Timer.periodic(
      const Duration(milliseconds: _updateIntervalMs),
      _updateDay,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _holdAtEnd() {
    if (!mounted) return;
    _isHoldingAtEnd = true;
    Future.delayed(const Duration(seconds: _pauseDurationSeconds), () {
      if (!mounted) return;
      _isHoldingAtEnd = false;
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _updateDay(Timer timer) {
    if (!mounted) return;

    final elapsedMs = timer.tick * _updateIntervalMs;
    final cycleMs = _cycleDurationSeconds * 1000;
    final cyclePositionMs = elapsedMs % cycleMs;

    final day = cyclePositionMs >= _activeDurationSeconds * 1000
        ? 100
        : ((cyclePositionMs / (_activeDurationSeconds * 1000.0)) * 100)
            .ceil()
            .clamp(1, 100);

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final treeWidth = constraints.maxWidth * 0.8;
            final treeHeight = constraints.maxHeight * 0.8;

            return Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: treeWidth,
                    height: treeHeight,
                    child: Lottie.asset(
                      'assets/animations/tree_growth.json',
                      controller: _animationController,
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
            );
          },
        ),
      ),
    );
  }
}
