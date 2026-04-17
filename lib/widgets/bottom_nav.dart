import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppTab { home, diary, progress, growth }

class BottomNav extends StatelessWidget {
  final AppTab active;
  final ValueChanged<AppTab> onTap;

  const BottomNav({super.key, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(AppTab.home, Icons.home_rounded, 'Home'),
          _item(AppTab.diary, Icons.menu_book_rounded, 'Diary'),
          _item(AppTab.progress, Icons.bar_chart_rounded, 'Progress'),
          _item(AppTab.growth, Icons.eco, 'Growth'),
        ],
      ),
    );
  }

  Widget _item(AppTab tab, IconData icon, String label) {
    final selected = active == tab;
    return InkWell(
      onTap: () => onTap(tab),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.mutedForeground,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selected ? AppColors.primary : AppColors.mutedForeground,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
