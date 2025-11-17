import '../../data/models/order_list_response.dart';

abstract class OrderRepository {
  Future<Map<String, dynamic>> createOrder({
    required int cartId,
    required Map<String, dynamic> shippingAddress,
    required String source,
    required String currency,
  });

  Future<OrderListResponse> getOrders({
    int page = 1,
    int pageSize = 20,
  });
}

