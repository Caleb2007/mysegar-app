import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppTab { home, diary, progress }

class BottomNav extends StatelessWidget {
  final AppTab active;
  final ValueChanged<AppTab> onTap;

  const BottomNav({super.key, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _item(AppTab.home, 'Home', Icons.home_outlined, Icons.home),
          _item(AppTab.diary, 'Diary', Icons.menu_book_outlined, Icons.menu_book),
          _item(AppTab.progress, 'Progress', Icons.bar_chart_outlined, Icons.bar_chart),
        ],
      ),
    );
  }

  Widget _item(AppTab tab, String label, IconData icon, IconData activeIcon) {
    final isActive = active == tab;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => onTap(tab),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 36,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                isActive ? activeIcon : icon,
                size: 22,
                color: isActive ? AppColors.primary : AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
