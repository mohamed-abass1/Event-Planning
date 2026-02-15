import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppLanguageProvider extends ChangeNotifier {
  // Default language code
  String _appLanguage = "en";

  // Expose current language
  String get appLanguage => _appLanguage;

  AppLanguageProvider() {
    _loadLanguageFromPrefs();
  }

  /// Change the app language and persist it locally
  void changeLanguage(String newLanguage) async {
    if (_appLanguage == newLanguage) return;

    _appLanguage = newLanguage;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appLanguage', newLanguage);
  }

  /// Load the last saved language preference
  void _loadLanguageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _appLanguage = prefs.getString('appLanguage') ?? "en";
    notifyListeners();
  }
}
