import 'package:intl/intl.dart';

class Helpers {
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(amount);
  }
  
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    final formatter = DateFormat(format);
    return formatter.format(date);
  }
  
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }
  
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
  
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Formats a phone number to E.164 format (+94779400291)
  /// Handles Sri Lankan phone numbers (0779400291 -> +94779400291)
  /// If already in E.164 format, returns as-is
  static String formatPhoneToE164(String phone) {
    // Remove all non-digit characters
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    // If already starts with country code (94), add +
    if (digitsOnly.startsWith('94') && digitsOnly.length >= 11) {
      return '+$digitsOnly';
    }
    
    // If starts with 0 (Sri Lankan local format), replace with +94
    if (digitsOnly.startsWith('0') && digitsOnly.length >= 10) {
      return '+94${digitsOnly.substring(1)}';
    }
    
    // If starts with 7 (without leading 0), add +94
    if (digitsOnly.startsWith('7') && digitsOnly.length == 9) {
      return '+94$digitsOnly';
    }
    
    // If already has +, return as-is
    if (phone.startsWith('+')) {
      return phone;
    }
    
    // Default: assume it's a Sri Lankan number and add +94
    if (digitsOnly.length >= 9) {
      // Remove leading 0 if present
      final cleaned = digitsOnly.startsWith('0') ? digitsOnly.substring(1) : digitsOnly;
      return '+94$cleaned';
    }
    
    // Return original if can't format
    return phone;
  }
}

