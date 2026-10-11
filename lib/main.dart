import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/pantry_provider.dart';
import 'providers/shopping_provider.dart';
import 'services/hive_boxes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveBoxes.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PantryProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingProvider()),
      ],
      child: const AntiGaspiApp(),
    ),
  );
}
