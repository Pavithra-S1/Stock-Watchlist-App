import 'package:flutter/material.dart';
import 'package:new_app/core/constants/themes/app_theme.dart';
import 'package:new_app/core/services/app_initializer.dart';
import 'features/home/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Watchlist',
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
