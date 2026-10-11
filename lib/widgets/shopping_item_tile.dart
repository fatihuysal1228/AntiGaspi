import 'package:flutter/material.dart';

import '../models/shopping_item.dart';
import '../theme/app_theme.dart';

/// Ligne de la liste de courses avec case à cocher et suppression par balayage.
class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const ShoppingItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          onTap: onToggle,
          contentPadding: EdgeInsets.zero,
          leading: Checkbox(
            value: item.checked,
            onChanged: (_) => onToggle(),
            activeColor: AppTheme.primaryGreen,
            shape: const CircleBorder(),
          ),
          title: Text(
            item.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: item.checked ? TextDecoration.lineThrough : null,
              color: item.checked ? Colors.grey : AppTheme.textDark,
            ),
          ),
          subtitle: item.sourceRecipeTitle != null
              ? Text('Pour : ${item.sourceRecipeTitle}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
              : null,
          trailing: item.quantity.isNotEmpty
              ? Text(item.quantity, style: TextStyle(color: Colors.grey.shade600))
              : null,
        ),
      ),
    );
  }
}
