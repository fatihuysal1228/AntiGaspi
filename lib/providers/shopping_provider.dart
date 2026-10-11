import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/recipe.dart';
import '../models/shopping_item.dart';
import '../services/hive_boxes.dart';

/// Gère la liste de courses : articles ajoutés manuellement ou générés
/// automatiquement depuis les ingrédients manquants d'une recette.
class ShoppingProvider extends ChangeNotifier {
  static const _uuid = Uuid();
  final List<ShoppingItem> _items = [];

  List<ShoppingItem> get items => List.unmodifiable(_items);

  List<ShoppingItem> get pending => _items.where((i) => !i.checked).toList();
  List<ShoppingItem> get done => _items.where((i) => i.checked).toList();

  ShoppingProvider() {
    _load();
  }

  void _load() {
    final box = HiveBoxes.shopping;
    _items.clear();
    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw is Map) {
        _items.add(ShoppingItem.fromMap(raw));
      }
    }
    notifyListeners();
  }

  Future<void> _persist(ShoppingItem item) async {
    await HiveBoxes.shopping.put(item.id, item.toMap());
  }

  Future<void> addItem({
    required String name,
    String quantity = '',
    String category = 'Autre',
    String? sourceRecipeTitle,
  }) async {
    final normalizedName = name.trim().toLowerCase();
    final existing = _items.where(
      (i) => !i.checked && i.name.trim().toLowerCase() == normalizedName,
    );
    if (existing.isNotEmpty) return; // évite les doublons dans la liste active
    final item = ShoppingItem(
      id: _uuid.v4(),
      name: name.trim(),
      quantity: quantity.trim(),
      category: category,
      sourceRecipeTitle: sourceRecipeTitle,
    );
    _items.add(item);
    await _persist(item);
    notifyListeners();
  }

  /// Ajoute tous les ingrédients manquants d'une recette à la liste de courses.
  Future<void> addMissingFromRecipe(RecipeMatch match) async {
    for (final ing in match.missing) {
      await addItem(
        name: ing.name,
        quantity: ing.quantity,
        sourceRecipeTitle: match.recipe.title,
      );
    }
  }

  Future<void> toggleChecked(String id) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index == -1) return;
    final updated = _items[index].copyWith(checked: !_items[index].checked);
    _items[index] = updated;
    await _persist(updated);
    notifyListeners();
  }

  Future<void> removeItem(String id) async {
    _items.removeWhere((i) => i.id == id);
    await HiveBoxes.shopping.delete(id);
    notifyListeners();
  }

  Future<void> clearChecked() async {
    final toRemove = _items.where((i) => i.checked).map((i) => i.id).toList();
    for (final id in toRemove) {
      await HiveBoxes.shopping.delete(id);
    }
    _items.removeWhere((i) => i.checked);
    notifyListeners();
  }
}
