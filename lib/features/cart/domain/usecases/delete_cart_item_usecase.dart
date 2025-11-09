import '../repositories/cart_repository.dart';

class DeleteCartItemUseCase {
  final CartRepository repository;

  DeleteCartItemUseCase(this.repository);

  Future<void> call(int cartItemId) async {
    return await repository.deleteCartItem(cartItemId);
  }
}

