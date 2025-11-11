import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  
  Locale _locale = const Locale('en'); // Default to English
  
  Locale get locale => _locale;
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('si'), // Sinhala
    Locale('ta'), // Tamil
  ];
  
  // Language display names
  static const Map<String, String> languageNames = {
    'en': 'English',
    'si': 'සිංහල',
    'ta': 'தமிழ்',
  };
  
  LocaleProvider(SharedPreferences prefs) {
    _loadLocale(prefs);
  }
  
  Future<void> _loadLocale(SharedPreferences prefs) async {
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      _locale = Locale(localeCode);
      notifyListeners();
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
    return languageNames[languageCode] ?? languageCode;
  }
  
  String getCurrentLanguageName() {
    return getLanguageName(_locale.languageCode);
  }
}


