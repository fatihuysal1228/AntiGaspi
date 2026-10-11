import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../providers/shopping_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/match_badge.dart';

/// Détail d'une recette : ingrédients (possédés / manquants) et étapes.
class RecipeDetailScreen extends StatelessWidget {
  final RecipeMatch match;

  const RecipeDetailScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final recipe = match.recipe;
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MatchBadge(percent: match.matchPercent),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recipe.description),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text('${recipe.prepMinutes} min'),
                        const SizedBox(width: 14),
                        Icon(Icons.category_outlined, size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(recipe.category),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            children: recipe.tags.map((t) => Chip(label: Text(t))).toList(),
          ),
          const SizedBox(height: 24),
          const Text('Ingrédients', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 10),
          ...match.owned.map((ing) => _IngredientRow(ingredient: ing, owned: true)),
          ...match.missing.map((ing) => _IngredientRow(ingredient: ing, owned: false)),
          if (match.missing.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<ShoppingProvider>().addMissingFromRecipe(match);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${match.missing.length} ingrédient${match.missing.length > 1 ? 's' : ''} ajouté${match.missing.length > 1 ? 's' : ''} à la liste de courses',
                      ),
                      backgroundColor: AppTheme.primaryGreen,
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart_outlined),
                label: const Text('Ajouter les ingrédients manquants à la liste'),
              ),
            ),
          ],
          const SizedBox(height: 28),
          const Text('Préparation', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 10),
          for (var i = 0; i < recipe.steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: AppTheme.lightGreen,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text('${i + 1}',
                        style: const TextStyle(
                            color: AppTheme.primaryGreen, fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(recipe.steps[i])),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final RecipeIngredient ingredient;
  final bool owned;

  const _IngredientRow({required this.ingredient, required this.owned});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            owned ? Icons.check_circle : Icons.remove_circle_outline,
            size: 20,
            color: owned ? AppTheme.primaryGreen : Colors.grey.shade400,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              ingredient.name,
              style: TextStyle(
                color: owned ? AppTheme.textDark : Colors.grey.shade600,
                fontWeight: owned ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Text(ingredient.quantity, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        ],
      ),
    );
  }
}
