import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/recipe.dart';
import 'screens/home_screen.dart';
import 'theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive for Flutter
  await Hive.initFlutter();
  // Register adapter for the Recipe model
  Hive.registerAdapter(RecipeAdapter());
  // Open a box for recipes
  await Hive.openBox<Recipe>('recipes');
  // Open a box for settings
  await Hive.openBox('settings');

  // Start the app with a Provider for theme management
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // Root widget of the application
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the ThemeProvider from the context
    final themeProvider = Provider.of<ThemeProvider>(context);
    // Check if dark mode is enabled
    final isDark = themeProvider.isDarkMode;

    // Return the MaterialApp with a dynamic theme
    return MaterialApp(
      title: 'Recipes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
        // Set brightness based on user preference
        brightness: isDark ? Brightness.dark : Brightness.light,
        // Adjust background color in dark mode
        scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : null,
        // Customize AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: isDark ? const Color(0xFF1C1C1C) : Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),
      // Define the initial screen
      home: const HomeScreen(),
    );
  }
}
