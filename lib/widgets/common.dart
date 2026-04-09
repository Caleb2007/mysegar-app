import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GradientScaffold extends StatelessWidget {
  final Widget child;
  final PageTone tone;
  final EdgeInsetsGeometry? padding;

  const GradientScaffold({super.key, required this.child, this.tone = PageTone.green, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.pageGradient(tone)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );
  }
}

class CardShell extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;

  const CardShell({super.key, required this.child, this.padding, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: borderColor ?? AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: child,
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final String name;
  final String imagePath;
  final double size;
  final VoidCallback? onTap;
  final bool showEditHint;

  const ProfileAvatar({super.key, required this.name, required this.imagePath, this.size = 44, this.onTap, this.showEditHint = false});

  @override
  Widget build(BuildContext context) {
    Widget avatarContent;
    if (imagePath.isNotEmpty && !kIsWeb) {
      avatarContent = ClipOval(child: Image.file(File(imagePath), fit: BoxFit.cover, width: size, height: size));
    } else {
      final letter = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
      avatarContent = Center(
        child: Text(letter, style: TextStyle(fontSize: size * 0.34, fontWeight: FontWeight.w800, color: AppColors.foreground)),
      );
    }

    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: AppColors.greyGreen, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
      child: ClipOval(child: avatarContent),
    );

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          if (showEditHint)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: size * 0.28,
                height: size * 0.28,
                decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                child: Icon(Icons.edit_rounded, color: Colors.white, size: size * 0.14),
              ),
            ),
        ],
      ),
    );
  }
}
