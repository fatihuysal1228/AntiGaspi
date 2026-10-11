import 'ingredient.dart';

/// Un ingrédient requis par une recette (nom + quantité affichée).
class RecipeIngredient {
  final String name;
  final String quantity;

  const RecipeIngredient({required this.name, required this.quantity});

  String get normalizedName => Ingredient.normalize(name);
}

/// Une recette de la base intégrée à l'application.
class Recipe {
  final String id;
  final String title;
  final String description;
  final String category; // Entrée, Plat, Soupe, Dessert, Sauce/Base
  final int prepMinutes;
  final List<String> tags; // rapide, végé, économique...
  final List<RecipeIngredient> ingredients;
  final List<String> steps;

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.prepMinutes,
    required this.tags,
    required this.ingredients,
    required this.steps,
  });
}

/// Résultat du matching entre une recette et le garde-manger de l'utilisateur.
class RecipeMatch {
  final Recipe recipe;
  final List<RecipeIngredient> owned;
  final List<RecipeIngredient> missing;

  RecipeMatch({
    required this.recipe,
    required this.owned,
    required this.missing,
  });

  double get matchRatio =>
      recipe.ingredients.isEmpty ? 0 : owned.length / recipe.ingredients.length;

  int get matchPercent => (matchRatio * 100).round();
}
