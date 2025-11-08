import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiBaseUrl => 
      dotenv.env['API_BASE_URL'] ?? 'https://api.example.com';
  static String get apiKey => 
      dotenv.env['API_KEY'] ?? '';
  static bool get isProduction => 
      dotenv.env['ENVIRONMENT'] == 'production';
  static bool get isDevelopment {
    final env = dotenv.env['ENVIRONMENT'];
    return env == 'development' || env == null || env.isEmpty;
  }
}

