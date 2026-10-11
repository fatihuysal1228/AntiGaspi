import 'package:flutter/material.dart';

/// Associe une icône à chaque catégorie d'ingrédient.
IconData iconForCategory(String category) {
  switch (category) {
    case 'Fruits & légumes':
      return Icons.eco_outlined;
    case 'Féculents':
      return Icons.rice_bowl_outlined;
    case 'Produits laitiers':
      return Icons.icecream_outlined;
    case 'Viande & poisson':
      return Icons.set_meal_outlined;
    case 'Épicerie':
      return Icons.shopping_basket_outlined;
    case 'Épices & condiments':
      return Icons.spa_outlined;
    default:
      return Icons.restaurant_outlined;
  }
}
