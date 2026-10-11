import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/ingredient.dart';
import '../services/hive_boxes.dart';

/// Gère la liste des ingrédients que l'utilisateur possède ("mon garde-manger").
class PantryProvider extends ChangeNotifier {
  static const _uuid = Uuid();
  final List<Ingredient> _ingredients = [];

  List<Ingredient> get ingredients => List.unmodifiable(_ingredients);

  PantryProvider() {
    _load();
  }

  void _load() {
    final box = HiveBoxes.pantry;
    _ingredients.clear();
    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw is Map) {
        _ingredients.add(Ingredient.fromMap(raw));
      }
    }
    _ingredients.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    notifyListeners();
  }

  Future<void> addIngredient({
    required String name,
    required String category,
    String quantity = '',
  }) async {
    final ingredient = Ingredient(
      id: _uuid.v4(),
      name: name.trim(),
      category: category,
      quantity: quantity.trim(),
    );
    _ingredients.add(ingredient);
    _ingredients.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    await HiveBoxes.pantry.put(ingredient.id, ingredient.toMap());
    notifyListeners();
  }

  Future<void> updateIngredient(Ingredient updated) async {
    final index = _ingredients.indexWhere((i) => i.id == updated.id);
    if (index == -1) return;
    _ingredients[index] = updated;
    await HiveBoxes.pantry.put(updated.id, updated.toMap());
    notifyListeners();
  }

  Future<void> removeIngredient(String id) async {
    _ingredients.removeWhere((i) => i.id == id);
    await HiveBoxes.pantry.delete(id);
    notifyListeners();
  }

  List<Ingredient> byCategory(String category) =>
      _ingredients.where((i) => i.category == category).toList();
}
