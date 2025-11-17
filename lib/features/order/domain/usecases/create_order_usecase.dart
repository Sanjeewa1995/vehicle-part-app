import 'package:vehicle_part_app/features/order/domain/repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required int cartId,
    required Map<String, dynamic> shippingAddress,
    required String source,
    required String currency,
  }) async {
    if (cartId <= 0) {
      throw Exception('Cart ID is required');
    }
    if (shippingAddress.isEmpty) {
      throw Exception('Shipping address is required');
    }
    return await repository.createOrder(
      cartId: cartId,
      shippingAddress: shippingAddress,
      source: source,
      currency: currency,
    );
  }
}

