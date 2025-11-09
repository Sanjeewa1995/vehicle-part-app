import 'package:intl/intl.dart';

class CurrencyFormatter {
  // LKR currency formatter for Sri Lankan Rupees
  static NumberFormat get lkr => NumberFormat.currency(
        symbol: 'Rs.',
        decimalDigits: 2,
        locale: 'en_LK',
      );

  // Format amount as LKR
  static String formatLKR(double amount) {
    return lkr.format(amount);
  }

  // Format amount without symbol (just numbers)
  static String formatAmount(double amount) {
    return NumberFormat('#,##0.00').format(amount);
  }
}

