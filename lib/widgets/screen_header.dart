import "package:flutter/material.dart";

import "../theme/app_colors.dart";

class ScreenHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  const ScreenHeader({super.key, required this.title, this.showBack = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: showBack ? IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back, color: AppColors.primary)) : null,
      title: Text(title, style: const TextStyle(color: AppColors.foreground, fontWeight: FontWeight.w700)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
