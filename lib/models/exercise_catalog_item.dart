import 'package:flutter/material.dart';

class ExerciseCatalogItem {
  final String id;
  final String name;
  final double caloriesPerMinute;
  final IconData icon;

  const ExerciseCatalogItem({
    required this.id,
    required this.name,
    required this.caloriesPerMinute,
    required this.icon,
  });
}
