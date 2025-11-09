import '../repositories/cart_repository.dart';

class ClearCartUseCase {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  Future<void> call(int cartId) async {
    return await repository.deleteCart(cartId);
  }
}

