import 'package:flutter/material.dart';

import '../models/ingredient.dart';
import '../theme/app_theme.dart';
import '../utils/category_icons.dart';

/// Ligne affichant un ingrédient du garde-manger, avec suppression par balayage.
class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback onDelete;

  const IngredientTile({super.key, required this.ingredient, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(ingredient.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFE57373),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppTheme.lightGreen,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(iconForCategory(ingredient.category),
                  color: AppTheme.primaryGreen, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ingredient.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(ingredient.category,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),
            if (ingredient.quantity.isNotEmpty)
              Text(ingredient.quantity, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
