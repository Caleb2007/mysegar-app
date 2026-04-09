class FoodCatalogItem {
  final String id;
  final String name;
  final int baseCalories;
  final String? imagePath;

  const FoodCatalogItem({
    required this.id,
    required this.name,
    required this.baseCalories,
    this.imagePath,
  });
}
