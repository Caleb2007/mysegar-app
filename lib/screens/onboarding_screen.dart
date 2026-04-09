import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'profile_setup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _slides = [
    _SlideData(title: 'Track every meal with clarity', body: 'Log meals, tune ingredients, and understand what goes into your day.'),
    _SlideData(title: 'See calories that make sense', body: 'Follow your total, net, and remaining calories with a calmer, cleaner flow.'),
    _SlideData(title: 'Stay consistent with MySegar', body: 'Build a stronger routine with diary history, weight trend, and goal progress.'),
  ];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      tone: PageTone.green,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          shape: BoxShape.circle,
                          boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 16, offset: Offset(0, 6))],
                        ),
                        child: const Icon(Icons.eco_rounded, size: 82, color: AppColors.primary),
                      ),
                      const SizedBox(height: 28),
                      const Text('MySegar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.foreground)),
                      const SizedBox(height: 22),
                      Text(slide.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.foreground)),
                      const SizedBox(height: 12),
                      Text(slide.body, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, color: AppColors.mutedForeground, height: 1.45)),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                final active = index == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(color: active ? AppColors.primary : AppColors.border, borderRadius: BorderRadius.circular(999)),
                );
              }),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () async {
                  await AppScope.of(context).completeOnboarding();
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProfileSetupScreen()));
                },
                child: const Text('Get Started', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideData {
  final String title;
  final String body;
  const _SlideData({required this.title, required this.body});
}
