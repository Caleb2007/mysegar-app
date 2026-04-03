import 'package:flutter/material.dart';

class ExerciseItem {
  final String name;
  final IconData icon;
  final double met;
  final Color color;

  const ExerciseItem({
    required this.name,
    required this.icon,
    required this.met,
    required this.color,
  });
}
