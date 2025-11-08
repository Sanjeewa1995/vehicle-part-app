import '../../config/env.dart';

class ApiConstants {
  // Base URLs
  // Note: Use Env.apiBaseUrl for the actual base URL from .env file
  // This is kept for backward compatibility and as a fallback
  static String get baseUrl => Env.apiBaseUrl;
  static const String apiVersion = '/v1';
  
  // Endpoints
  static const String login = '/api/v1/auth/login/';
  static const String register = '/api/v1/auth/register/';
  static const String logout = '/api/v1/auth/logout/';
  static const String refreshToken = '/api/v1/token/refresh/';
  
  static const String parts = '/parts';
  static const String partsSearch = '/parts/search';
  static const String partDetails = '/parts/{id}';
  
  static const String cart = '/cart';
  static const String cartAdd = '/cart/add';
  static const String cartRemove = '/cart/remove';
  
  static const String orders = '/orders';
  static const String orderCreate = '/orders/create';
  static const String orderDetails = '/orders/{id}';
  
  static const String profile = '/profile';
  static const String profileUpdate = '/profile/update';
  
  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  
  // Private constructor to prevent instantiation
  ApiConstants._();
}

