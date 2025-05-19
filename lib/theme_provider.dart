import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  // Key used in the Hive settings box
  static const String _boxKey = 'isDarkMode';

  // Current dark-mode status
  bool _isDarkMode = false;

  // Getter for dark-mode status
  bool get isDarkMode => _isDarkMode;

  // Constructor that loads the stored preference
  ThemeProvider() {
    _loadThemePreference();
  }

  // Loads the saved theme preference from Hive
  Future<void> _loadThemePreference() async {
    final box = await Hive.openBox('settings');
    _isDarkMode = box.get(_boxKey, defaultValue: false);
    notifyListeners();
  }

  // Toggles the theme, updates Hive, and notifies listeners
  Future<void> toggleTheme() async {
    final box = await Hive.openBox('settings');
    _isDarkMode = !_isDarkMode;
    await box.put(_boxKey, _isDarkMode);
    notifyListeners();
  }
}
