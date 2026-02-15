import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppThemeProviders extends ChangeNotifier {
  ThemeMode _appTheme = ThemeMode.light;
  ThemeMode get appTheme => _appTheme;

  AppThemeProviders() {
    _initializeTheme();
  }

  Future<void> changeTheme(ThemeMode newTheme) async {
    if (_appTheme == newTheme) return;

    _appTheme = newTheme;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final themeName = newTheme == ThemeMode.dark ? 'dark' : 'light';
    await prefs.setString('appTheme', themeName);
  }

  bool isDarkMode() => _appTheme == ThemeMode.dark;

  Future<void> _initializeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('appTheme');

    if (savedTheme == null) return;

    _appTheme = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
