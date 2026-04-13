import 'package:flutter/material.dart';

enum PageTone {
  green,
  orange,
  purple,
}

class AppColors {
  static const Color primary = Color(0xFF63B56E);
  static const Color primaryDark = Color(0xFF4D9B59);
  static const Color accent = Color(0xFF8ED59A);

  static const Color foreground = Color(0xFF1F2A1F);
  static const Color mutedForeground = Color(0xFF6F7F6D);

  static const Color card = Color(0xFFFDFEFC);
  static const Color cardSoft = Color(0xFFF7FBF6);
  static const Color border = Color(0xFFD7E6D6);

  static const Color secondary = Color(0xFFEAF4E8);

  static const Color orange = Color(0xFFF3A51A);
  static const Color orangeSoft = Color(0xFFFFF3DF);

  static const Color purple = Color(0xFF9A62C7);
  static const Color purpleSoft = Color(0xFFF3EAFE);

  static const Color danger = Color(0xFFD96A6A);
  static const Color dangerSoft = Color(0xFFFFEAEA);
  
  // Alias for danger
  static const Color red = Color(0xFFD96A6A);
  static const Color redSoft = Color(0xFFFFEAEA);
  
  // Soft colors for backgrounds
  static const Color primarySoft = Color(0xFFEDF5F0);
  
  // Grey-green for avatar backgrounds
  static const Color greyGreen = Color(0xFFD7E6D6);

  static const Color shadow = Color(0x14000000);

  static const List<Color> homeGradient = [
    Color(0xFFF7FBF6),
    Color(0xFFEFF6EC),
    Color(0xFFE6F0E3),
  ];

  static const List<Color> diaryGradient = [
    Color(0xFFF9FCF8),
    Color(0xFFF1F7EE),
    Color(0xFFE8F1E5),
  ];

  static const List<Color> progressGradient = [
    Color(0xFFF9FCF8),
    Color(0xFFF2F8EF),
    Color(0xFFE9F3E7),
  ];

  static Gradient pageGradient(PageTone tone) {
    switch (tone) {
      case PageTone.green:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: homeGradient,
        );
      case PageTone.orange:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            orangeSoft,
            orangeSoft.withValues(alpha: 0.7),
          ],
        );
      case PageTone.purple:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            purpleSoft,
            purpleSoft.withValues(alpha: 0.7),
          ],
        );
    }
  }
}