import 'package:flutter/material.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import 'package:vehicle_part_app/config/env.dart';
import '../models/payment_request.dart';

class PayHereService {
  // PayHere Credentials
  // IMPORTANT: Make sure your app package name matches what's registered in PayHere
  // Current app package name: com.vehiclepart.vehicle_part_app (Android)
  // Credentials and sandbox flag are read from environment variables via Env
  static String get merchantId => Env.payHereMerchantId;
  static String get merchantSecret => Env.payHereMerchantSecret;
  static String get notifyUrl => Env.payHereNotifyUrl;
  static bool get sandbox => Env.payHereSandbox;

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

