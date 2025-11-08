/// Payment item details
class PaymentItem {
  final String itemNumber;
  final String itemName;
  final double amount;
  final int quantity;

  PaymentItem({
    required this.itemNumber,
    required this.itemName,
    required this.amount,
    required this.quantity,
  });
}

/// Payment request model for PayHere
class PaymentRequest {
  final String orderId;
  final String items;
  final double amount;
  final String currency;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String country;
  final String? deliveryAddress;
  final String? deliveryCity;
  final String? deliveryCountry;
  final String? custom1;
  final String? custom2;
  
  // Item-wise details (optional)
  final List<PaymentItem>? paymentItems;
  
  // Recurring payment fields (optional)
  final String? recurrence;
  final String? duration;
  final String? startupFee;
  
  // Preapproval flag
  final bool preapprove;
  
  // Hold-on-card flag
  final bool authorize;

  PaymentRequest({
    required this.orderId,
    required this.items,
    required this.amount,
    this.currency = 'LKR',
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    this.country = 'Sri Lanka',
    this.deliveryAddress,
    this.deliveryCity,
    this.deliveryCountry,
    this.custom1,
    this.custom2,
    this.paymentItems,
    this.recurrence,
    this.duration,
    this.startupFee,
    this.preapprove = false,
    this.authorize = false,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'order_id': orderId,
      'items': items,
      'amount': amount.toStringAsFixed(2),
      'currency': currency,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
      'custom_1': custom1 ?? '',
      'custom_2': custom2 ?? '',
    };

    // Add delivery address if provided
    if (deliveryAddress != null) {
      map['delivery_address'] = deliveryAddress!;
    }
    if (deliveryCity != null) {
      map['delivery_city'] = deliveryCity!;
    }
    if (deliveryCountry != null) {
      map['delivery_country'] = deliveryCountry!;
    }

    // Add item-wise details if provided
    if (paymentItems != null && paymentItems!.isNotEmpty) {
      for (int i = 0; i < paymentItems!.length; i++) {
        final item = paymentItems![i];
        final index = i + 1;
        map['item_number_$index'] = item.itemNumber;
        map['item_name_$index'] = item.itemName;
        map['amount_$index'] = item.amount.toStringAsFixed(2);
        map['quantity_$index'] = item.quantity.toString();
      }
    }

    // Add recurring payment fields if provided
    if (recurrence != null) {
      map['recurrence'] = recurrence!;
    }
    if (duration != null) {
      map['duration'] = duration!;
    }
    if (startupFee != null) {
      map['startup_fee'] = startupFee!;
    }

    // Add preapproval flag if true
    if (preapprove) {
      map['preapprove'] = true;
    }

    // Add authorize flag if true
    if (authorize) {
      map['authorize'] = true;
    }

    return map;
  }
}

