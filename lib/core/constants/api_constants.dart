class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = '/v1';
  
  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  
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

