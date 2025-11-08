import 'package:flutter/material.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import '../models/payment_request.dart';

class PayHereService {
  // TODO: Replace with your actual PayHere credentials
  static const String merchantId = '1232702';
  static const String merchantSecret = 'MTQyODExODgyMjI0OTkxNDQ0MDE0Njg4MjU3MzQxMjI0NDYyMDQ=';
  static const String notifyUrl = 'https://yourdomain.com/notify';
  
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
          onError(error);
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

