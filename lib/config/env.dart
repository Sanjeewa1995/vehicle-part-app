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

  static bool get payHereSandbox {
    try {
      final value = dotenv.env['PAYHERE_SANDBOX'];
      if (value == null) return true;
      return value.toLowerCase() == 'true' || value == '1';
    } catch (e) {
      // dotenv not initialized, default to sandbox mode
      return true;
    }
  }

  static String get payHereMerchantId {
    try {
      return dotenv.env['PAYHERE_MERCHANT_ID'] ?? '';
    } catch (e) {
      // dotenv not initialized
      return '';
    }
  }

  static String get payHereMerchantSecret {
    try {
      return dotenv.env['PAYHERE_MERCHANT_SECRET'] ?? '';
    } catch (e) {
      // dotenv not initialized
      return '';
    }
  }

  static String get payHereNotifyUrl {
    try {
      return dotenv.env['PAYHERE_NOTIFY_URL'] ?? '';
    } catch (e) {
      // dotenv not initialized
      return '';
    }
  }
}
