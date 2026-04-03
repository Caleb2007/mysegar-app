class FoodItem {
  final String id;
  final String name;
  final String portion;
  final double portionValue;
  final int calories;
  final String? imagePath;

  const FoodItem({
    required this.id,
    required this.name,
    required this.portion,
    required this.portionValue,
    required this.calories,
    this.imagePath,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    String? portion,
    double? portionValue,
    int? calories,
    String? imagePath,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      portion: portion ?? this.portion,
      portionValue: portionValue ?? this.portionValue,
      calories: calories ?? this.calories,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
