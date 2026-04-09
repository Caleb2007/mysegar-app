import '../models/meal_entry.dart';

const IngredientDefinition riceIngredient = IngredientDefinition(
  id: 'rice',
  name: 'Rice',
  inputMode: IngredientInputMode.percentage,
  defaultPercentage: 50,
  defaultCalories: 260,
);
const IngredientDefinition sambalIngredient = IngredientDefinition(
  id: 'sambal',
  name: 'Sambal',
  inputMode: IngredientInputMode.percentage,
  defaultPercentage: 20,
  defaultCalories: 90,
);
const IngredientDefinition anchoviesIngredient = IngredientDefinition(
  id: 'anchovies',
  name: 'Anchovies',
  inputMode: IngredientInputMode.percentage,
  defaultPercentage: 8,
  defaultCalories: 55,
);
const IngredientDefinition peanutsIngredient = IngredientDefinition(
  id: 'peanuts',
  name: 'Peanuts',
  inputMode: IngredientInputMode.percentage,
  defaultPercentage: 7,
  defaultCalories: 45,
);
const IngredientDefinition cucumberIngredient = IngredientDefinition(
  id: 'cucumber',
  name: 'Cucumber',
  inputMode: IngredientInputMode.percentage,
  defaultPercentage: 5,
  defaultCalories: 12,
);
const IngredientDefinition boiledEggIngredient = IngredientDefinition(
  id: 'egg',
  name: 'Egg',
  inputMode: IngredientInputMode.servings,
  caloriesPerServing: 78,
);
const IngredientDefinition chickenIngredient = IngredientDefinition(
  id: 'chicken',
  name: 'Chicken',
  inputMode: IngredientInputMode.percentage,
  defaultPercentage: 35,
  defaultCalories: 185,
);
const IngredientDefinition tofuIngredient = IngredientDefinition(
  id: 'tofu',
  name: 'Tofu',
  inputMode: IngredientInputMode.percentage,
  defaultPercentage: 10,
  defaultCalories: 55,
);
const IngredientDefinition teaEggIngredient = IngredientDefinition(
  id: 'tea-egg',
  name: 'Tea Egg',
  inputMode: IngredientInputMode.servings,
  caloriesPerServing: 85,
);

final List<IngredientDefinition> ingredientDatabase = [
  riceIngredient,
  sambalIngredient,
  anchoviesIngredient,
  peanutsIngredient,
  cucumberIngredient,
  boiledEggIngredient,
  chickenIngredient,
  tofuIngredient,
  teaEggIngredient,
];

final List<DishDefinition> dishDatabase = [
  DishDefinition(
    id: 'nasi-lemak',
    name: 'Nasi Lemak',
    baseCalories: 640,
    imagePath: 'assets/images/nasi_lemak.png',
    defaultIngredients: const [
      IngredientSelection(ingredient: riceIngredient, percentage: 50, servings: 0),
      IngredientSelection(ingredient: sambalIngredient, percentage: 20, servings: 0),
      IngredientSelection(ingredient: anchoviesIngredient, percentage: 8, servings: 0),
      IngredientSelection(ingredient: peanutsIngredient, percentage: 7, servings: 0),
      IngredientSelection(ingredient: cucumberIngredient, percentage: 5, servings: 0),
      IngredientSelection(ingredient: boiledEggIngredient, percentage: 0, servings: 1),
    ],
  ),
  DishDefinition(
    id: 'chicken-rice',
    name: 'Chicken Rice',
    baseCalories: 600,
    imagePath: 'assets/images/chicken_rice.png',
    defaultIngredients: const [
      IngredientSelection(ingredient: riceIngredient, percentage: 45, servings: 0),
      IngredientSelection(ingredient: chickenIngredient, percentage: 35, servings: 0),
      IngredientSelection(ingredient: tofuIngredient, percentage: 10, servings: 0),
      IngredientSelection(ingredient: teaEggIngredient, percentage: 0, servings: 1),
    ],
  ),
  DishDefinition(
    id: 'egg-dish',
    name: 'Egg',
    baseCalories: 78,
    imagePath: 'assets/images/egg.png',
    defaultIngredients: const [
      IngredientSelection(ingredient: boiledEggIngredient, percentage: 0, servings: 1),
    ],
  ),
];
