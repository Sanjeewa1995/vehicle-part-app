import '../repositories/cart_repository.dart';
import '../../domain/entities/cart_item.dart';

class AddCartItemUseCase {
  final CartRepository repository;

  AddCartItemUseCase(this.repository);

  Future<CartItem> call({
    required int cartId,
    required int productId,
    required int quantity,
  }) async {
    return await repository.addCartItem(
      cartId: cartId,
      productId: productId,
      quantity: quantity,
    );
  }
}

