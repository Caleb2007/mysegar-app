import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ScreenHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;

  const ScreenHeader({super.key, required this.title, this.showBack = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: showBack
          ? IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            )
          : const SizedBox.shrink(),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.foreground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
