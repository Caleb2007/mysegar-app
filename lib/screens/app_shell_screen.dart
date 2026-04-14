import 'package:flutter/material.dart';

import '../widgets/bottom_nav.dart';
import 'diary_screen.dart';
import 'growth_timeline_screen.dart';
import 'home_screen.dart';
import 'progress_screen.dart';

class AppShellScreen extends StatefulWidget {
  final int initialIndex;

  const AppShellScreen({super.key, this.initialIndex = 0});

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: _index);
  }

  void _onTap(AppTab tab) {
    final nextIndex = switch (tab) {
      AppTab.home => 0,
      AppTab.diary => 1,
      AppTab.progress => 2,
      AppTab.growth => 3,
    };
    _controller.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (value) => setState(() => _index = value),
            children: [
              const HomeScreen(),
              DiaryScreen(),
              const ProgressScreen(),
              const GrowthTimelineScreen(),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNav(active: AppTab.values[_index], onTap: _onTap),
          ),
        ],
      ),
    );
  }
}
