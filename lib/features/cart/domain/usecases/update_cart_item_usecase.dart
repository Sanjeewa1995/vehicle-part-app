import '../repositories/cart_repository.dart';
import '../../domain/entities/cart_item.dart';

class UpdateCartItemUseCase {
  final CartRepository repository;

  UpdateCartItemUseCase(this.repository);

  Future<CartItem> call({
    required int cartItemId,
    required int quantity,
  }) async {
    return await repository.updateCartItem(
      cartItemId: cartItemId,
      quantity: quantity,
    );
  }
}

