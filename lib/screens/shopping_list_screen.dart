import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shopping_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/shopping_item_tile.dart';

/// Écran "Liste de courses" : articles à acheter, cochables, avec ajout manuel.
class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajouter un article'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(hintText: 'Nom de l\'article'),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              ctx.read<ShoppingProvider>().addItem(name: value.trim());
            }
            Navigator.of(ctx).pop();
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ctx.read<ShoppingProvider>().addItem(name: controller.text.trim());
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste de courses'),
        actions: [
          Consumer<ShoppingProvider>(
            builder: (context, shopping, _) => shopping.done.isNotEmpty
                ? IconButton(
                    tooltip: 'Vider les articles cochés',
                    icon: const Icon(Icons.delete_sweep_outlined),
                    onPressed: () => shopping.clearChecked(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<ShoppingProvider>(
        builder: (context, shopping, _) {
          if (shopping.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_cart_outlined,
                        size: 64, color: AppTheme.primaryGreen),
                    const SizedBox(height: 16),
                    const Text(
                      'Liste de courses vide',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Les ingrédients manquants d\'une recette apparaîtront ici automatiquement.',
                      style: TextStyle(color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            children: [
              if (shopping.pending.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                  child: Text('À acheter (${shopping.pending.length})',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
                for (final item in shopping.pending)
                  ShoppingItemTile(
                    item: item,
                    onToggle: () => shopping.toggleChecked(item.id),
                    onDelete: () => shopping.removeItem(item.id),
                  ),
              ],
              if (shopping.done.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
                  child: Text('Déjà dans le panier (${shopping.done.length})',
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey.shade500)),
                ),
                for (final item in shopping.done)
                  ShoppingItemTile(
                    item: item,
                    onToggle: () => shopping.toggleChecked(item.id),
                    onDelete: () => shopping.removeItem(item.id),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}
