import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../app_state.dart';

class GrowthTimelineScreen extends StatefulWidget {
  const GrowthTimelineScreen({super.key});

  @override
  State<GrowthTimelineScreen> createState() => _GrowthTimelineScreenState();
}

class _GrowthTimelineScreenState extends State<GrowthTimelineScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  int _growthDay = 1;
  int _successfulDays = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatePlantProgress();
  }

  void _updatePlantProgress() {
    final state = AppScope.of(context);
    final growthDay = state.currentPlantGrowthDay();
    final successDays = state.successfulCalorieDays(maxDays: 100);

    setState(() {
      _growthDay = growthDay;
      _successfulDays = successDays;
    });

    // Set the animation controller value based on growth day
    // Day 1 => progress 0.0, Day 100 => progress 1.0
    final progress = (_growthDay - 1) / 99.0;
    _animationController.value = progress.clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 196, 217, 238),
              Color.fromARGB(255, 112, 234, 247),
            ],
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
                Positioned(
                  left: (constraints.maxWidth - treeWidth) / 2 - 200,
                  bottom: (constraints.maxHeight - treeHeight) / 2 - 50,
                  child: Container(
                    width: 720,
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF56ab2f), Color(0xFFa8e063)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: treeWidth,
                    height: treeHeight,
                    child: Lottie.asset(
                      'assets/animations/tree_growth.json',
                      controller: _animationController,
                      fit: BoxFit.contain,
                      repeat: false,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Successful Days: $_successfulDays',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black54,
                                    offset: Offset(0, 1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ) ??
                              const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Successful day = meal logged and calories within target\nEmpty days do not count.',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ) ??
                            const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
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
