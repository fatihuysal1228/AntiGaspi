import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/recipe_database.dart';
import '../providers/pantry_provider.dart';
import '../services/recipe_matcher.dart';
import '../theme/app_theme.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

/// Écran "Recettes" : suggestions triées par pourcentage d'ingrédients
/// déjà disponibles dans le garde-manger.
class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  String? _categoryFilter;
  bool _onlyReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recettes anti-gaspi')),
      body: Consumer<PantryProvider>(
        builder: (context, pantry, _) {
          var matches = RecipeMatcher.matchAll(pantry.ingredients);

          if (_categoryFilter != null) {
            matches = matches.where((m) => m.recipe.category == _categoryFilter).toList();
          }
          if (_onlyReady) {
            matches = matches.where((m) => m.missing.isEmpty).toList();
          }

          return Column(
            children: [
              if (pantry.ingredients.isEmpty)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppTheme.primaryGreen),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Ajoute des ingrédients dans "Mes ingrédients" pour des suggestions personnalisées.',
                          style: TextStyle(color: AppTheme.textDark, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      FilterChip(
                        label: const Text('Prêtes à cuisiner'),
                        selected: _onlyReady,
                        onSelected: (v) => setState(() => _onlyReady = v),
                      ),
                      const SizedBox(width: 8),
                      for (final category in kRecipeCategories) ...[
                        FilterChip(
                          label: Text(category),
                          selected: _categoryFilter == category,
                          onSelected: (v) =>
                              setState(() => _categoryFilter = v ? category : null),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
              ),
              Expanded(
                child: matches.isEmpty
                    ? Center(
                        child: Text('Aucune recette ne correspond à ces filtres',
                            style: TextStyle(color: Colors.grey.shade600)),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: matches.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final match = matches[index];
                          return RecipeCard(
                            match: match,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RecipeDetailScreen(match: match),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
