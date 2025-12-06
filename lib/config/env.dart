import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiBaseUrl {
    try {
      return dotenv.env['API_BASE_URL'] ?? 'http://206.189.137.79';
    } catch (e) {
      // dotenv not initialized, return default
      return 'http://206.189.137.79';
    }
  }
  
  static String get apiKey {
    try {
      return dotenv.env['API_KEY'] ?? '';
    } catch (e) {
      // dotenv not initialized, return default
      return '';
    }
  }
  
  static bool get isProduction {
    try {
      return dotenv.env['ENVIRONMENT'] == 'production';
    } catch (e) {
      // dotenv not initialized, return default
      return false;
    }
  }
  
  static bool get isDevelopment {
    try {
      final env = dotenv.env['ENVIRONMENT'];
      return env == 'development' || env == null || env.isEmpty;
    } catch (e) {
      // dotenv not initialized, return default
      return true; // Default to development
    }
  }
}

