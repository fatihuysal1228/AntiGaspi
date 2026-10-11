import 'package:hive_flutter/hive_flutter.dart';

/// Centralise les noms et l'initialisation des boîtes Hive (stockage local).
class HiveBoxes {
  static const String pantryBox = 'pantry_box';
  static const String shoppingBox = 'shopping_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(pantryBox);
    await Hive.openBox(shoppingBox);
  }

  static Box get pantry => Hive.box(pantryBox);
  static Box get shopping => Hive.box(shoppingBox);
}
