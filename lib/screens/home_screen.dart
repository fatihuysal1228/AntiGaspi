import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shopping_provider.dart';
import 'pantry_screen.dart';
import 'recipes_screen.dart';
import 'shopping_list_screen.dart';

/// Coquille principale avec navigation en bas de l'écran.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const _screens = [
    PantryScreen(),
    RecipesScreen(),
    ShoppingListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final pendingCount = context.watch<ShoppingProvider>().pending.length;

    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.kitchen_outlined),
            activeIcon: Icon(Icons.kitchen),
            label: 'Ingrédients',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Recettes',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('$pendingCount'),
              isLabelVisible: pendingCount > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            activeIcon: const Icon(Icons.shopping_cart),
            label: 'Courses',
          ),
        ],
      ),
    );
  }
}
