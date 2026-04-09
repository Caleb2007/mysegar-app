import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2FB463);
  static const Color primaryDark = Color(0xFF228B4A);
  static const Color primarySoft = Color(0xFFEAF7EF);
  static const Color mint = Color(0xFFF3FAF5);
  static const Color orange = Color(0xFFF4A512);
  static const Color orangeSoft = Color(0xFFFFF3DE);
  static const Color purple = Color(0xFFA25AC8);
  static const Color purpleSoft = Color(0xFFF4E9FA);
  static const Color red = Color(0xFFE25454);
  static const Color redSoft = Color(0xFFFFECEC);
  static const Color foreground = Color(0xFF1E2C1F);
  static const Color mutedForeground = Color(0xFF708570);
  static const Color border = Color(0xFFD7E8D9);
  static const Color card = Colors.white;
  static const Color secondary = Color(0xFFF0F5F0);
  static const Color greyGreen = Color(0xFFE3ECE3);

  static LinearGradient pageGradient(PageTone tone) {
    switch (tone) {
      case PageTone.green:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF6FBF6), Color(0xFFEEF6F0), Color(0xFFF8FBF8)],
        );
      case PageTone.orange:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFBF3), Color(0xFFFFF5E5), Color(0xFFF8FBF8)],
        );
      case PageTone.purple:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFDF9FF), Color(0xFFF7F0FB), Color(0xFFF8FBF8)],
        );
    }
  }
}

enum PageTone { green, orange, purple }
