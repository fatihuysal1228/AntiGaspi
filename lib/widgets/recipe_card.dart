import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../theme/app_theme.dart';
import 'match_badge.dart';

/// Carte résumant une recette suggérée dans la liste.
class RecipeCard extends StatelessWidget {
  final RecipeMatch match;
  final VoidCallback onTap;

  const RecipeCard({super.key, required this.match, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final recipe = match.recipe;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MatchBadge(percent: match.matchPercent),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recipe.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text('${recipe.prepMinutes} min',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        const SizedBox(width: 14),
                        if (match.missing.isEmpty)
                          const Row(
                            children: [
                              Icon(Icons.check_circle, size: 16, color: AppTheme.primaryGreen),
                              SizedBox(width: 4),
                              Text(
                                'Tout y est !',
                                style: TextStyle(
                                  color: AppTheme.primaryGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            '${match.missing.length} ingrédient${match.missing.length > 1 ? 's' : ''} manquant${match.missing.length > 1 ? 's' : ''}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
