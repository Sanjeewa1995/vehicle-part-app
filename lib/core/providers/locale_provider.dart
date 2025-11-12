import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('si'),
    Locale('ta'),
  ];

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey);
      if (localeCode != null && supportedLocales.any((l) => l.languageCode == localeCode)) {
        _locale = Locale(localeCode);
        notifyListeners();
      }
    } catch (e) {
      // Use default locale if loading fails
      _locale = const Locale('en');
    }
  }

  Future<void> setLocale(Locale locale, SharedPreferences prefs) async {
    if (!supportedLocales.contains(locale)) {
      return;
    }
    
    _locale = locale;
    await prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'si':
        return 'සිංහල';
      case 'ta':
        return 'தமிழ்';
      default:
        return 'English';
    }
  }
}
