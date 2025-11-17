abstract class OrderRepository {
  Future<Map<String, dynamic>> createOrder({
    required int cartId,
    required Map<String, dynamic> shippingAddress,
    required String source,
    required String currency,
  });
}

