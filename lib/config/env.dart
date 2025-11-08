import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiBaseUrl {
    try {
      return dotenv.env['API_BASE_URL'] ?? 'http://3.25.146.196:8000';
    } catch (e) {
      // dotenv not initialized, return default
      return 'http://3.25.146.196:8000';
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

