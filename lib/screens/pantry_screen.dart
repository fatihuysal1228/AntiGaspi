import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ingredient.dart';
import '../providers/pantry_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/ingredient_tile.dart';
import 'add_ingredient_sheet.dart';

/// Écran "Mes ingrédients" : liste du garde-manger, groupée par catégorie.
class PantryScreen extends StatelessWidget {
  const PantryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon garde-manger')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddIngredientSheet.show(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<PantryProvider>(
        builder: (context, pantry, _) {
          if (pantry.ingredients.isEmpty) {
            return _EmptyState(onAdd: () => AddIngredientSheet.show(context));
          }

          final categories = kIngredientCategories
              .where((c) => pantry.byCategory(c).isNotEmpty)
              .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            children: [
              for (final category in categories) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
                  child: Text(
                    category,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
                for (final ingredient in pantry.byCategory(category))
                  IngredientTile(
                    ingredient: ingredient,
                    onDelete: () => pantry.removeIngredient(ingredient.id),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.kitchen_outlined, size: 64, color: AppTheme.primaryGreen),
            const SizedBox(height: 16),
            const Text(
              'Ton garde-manger est vide',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoute les ingrédients que tu as chez toi pour recevoir des idées de recettes anti-gaspi.',
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un ingrédient'),
            ),
          ],
        ),
      ),
    );
  }
}
