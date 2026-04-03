import 'package:flutter/material.dart';

class AppColors {
  static const text = Color(0xFF1A2E1A);
  static const tint = Color(0xFF2ECC71);
  static const background = Color(0xFFF2FAF2);
  static const foreground = Color(0xFF1A2E1A);
  static const card = Colors.white;
  static const cardForeground = Color(0xFF1A2E1A);
  static const primary = Color(0xFF27AE60);
  static const primaryForeground = Colors.white;
  static const secondary = Color(0xFFE8F5E9);
  static const secondaryForeground = Color(0xFF1A2E1A);
  static const muted = Color(0xFFE8F5E9);
  static const mutedForeground = Color(0xFF6B8F6B);
  static const accent = Color(0xFFF39C12);
  static const accentForeground = Colors.white;
  static const destructive = Color(0xFFE74C3C);
  static const destructiveForeground = Colors.white;
  static const border = Color(0xFFD4EDD4);
  static const input = Color(0xFFD4EDD4);
  static const orange = Color(0xFFF39C12);
  static const yellow = Color(0xFFF9E94E);
  static const lightGreen = Color(0xFFA8E6A8);
  static const darkGreen = Color(0xFF1E8449);

  static const double radius = 16;
}

ThemeData buildAppTheme() {
  final base = ThemeData(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.card,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.foreground,
      displayColor: AppColors.foreground,
    ),
  );
}
