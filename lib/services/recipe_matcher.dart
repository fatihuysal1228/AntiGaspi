import '../data/recipe_database.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';

/// Calcule, pour chaque recette de la base, le pourcentage d'ingrédients
/// déjà disponibles dans le garde-manger de l'utilisateur.
class RecipeMatcher {
  /// Retourne les recettes triées par pertinence décroissante (meilleur
  /// pourcentage de match en premier, puis moins d'ingrédients manquants).
  static List<RecipeMatch> matchAll(List<Ingredient> pantry) {
    final pantryNames = pantry.map((i) => i.normalizedName).toSet();

    final matches = kRecipeDatabase.map((recipe) {
      final owned = <RecipeIngredient>[];
      final missing = <RecipeIngredient>[];
      for (final ing in recipe.ingredients) {
        final isOwned = pantryNames.any((pantryName) =>
            pantryName == ing.normalizedName ||
            pantryName.contains(ing.normalizedName) ||
            ing.normalizedName.contains(pantryName));
        if (isOwned) {
          owned.add(ing);
        } else {
          missing.add(ing);
        }
      }
      return RecipeMatch(recipe: recipe, owned: owned, missing: missing);
    }).toList();

    matches.sort((a, b) {
      final ratioCompare = b.matchRatio.compareTo(a.matchRatio);
      if (ratioCompare != 0) return ratioCompare;
      return a.missing.length.compareTo(b.missing.length);
    });

    return matches;
  }
}
