import 'package:flutter/material.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import '../models/payment_request.dart';

class PayHereService {
  // PayHere Credentials
  // IMPORTANT: Make sure your app package name matches what's registered in PayHere
  // Current app package name: com.vehiclepart.vehicle_part_app (Android)
  // Android Merchant Secret (for com.vehiclepart.vehicle_part_app)
  static const String merchantId = '1232890';
  static const String merchantSecret = 'MjkwMzc1Mzk3NDIzNTI5NjY0NTMxMzYwMzAyMjg2MzExMTk1MTE5MA==';
  static const String notifyUrl = 'https://yourdomain.com/notify';
  
  // Note: iOS would use a different merchant secret if package name differs
  // iOS Merchant Secret (if different): MTQyODExODgyMjI0OTkxNDQ0MDE0Njg4MjU3MzQxMjI0NDYyMDQ=
  
  // Set to false for production
  static const bool sandbox = true;

  /// Initiate PayHere payment
  static Future<void> startPayment({
    required PaymentRequest paymentRequest,
    required Function(String paymentId) onSuccess,
    required Function(String error) onError,
    required VoidCallback onDismissed,
  }) async {
    try {
      final paymentObject = {
        'sandbox': sandbox,
        'merchant_id': merchantId,
        'merchant_secret': merchantSecret,
        'notify_url': notifyUrl,
        ...paymentRequest.toMap(),
      };

      PayHere.startPayment(
        paymentObject,
        (paymentId) {
          onSuccess(paymentId);
        },
        (error) {
          String errorMessage = error;
          if (error.contains('Unauthorized domain') || error.contains('unauthorized')) {
            errorMessage = 'Unauthorized domain error.\n\n'
                'Your app package name: com.vehiclepart.vehicle_part_app\n'
                'Merchant ID: $merchantId\n\n'
                'Please verify in PayHere Dashboard:\n'
                '1. Package name matches EXACTLY (no spaces, correct underscores)\n'
                '2. Status shows "Active" (not "Pending")\n'
                '3. Merchant Secret matches the one in code';
          }
          onError(errorMessage);
        },
        () {
          onDismissed();
        },
      );
    } catch (e) {
      onError('Failed to initialize payment: ${e.toString()}');
    }
  }
}

