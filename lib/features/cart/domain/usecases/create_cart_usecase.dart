import '../repositories/cart_repository.dart';
import '../entities/cart.dart';

class CreateCartUseCase {
  final CartRepository repository;

  CreateCartUseCase(this.repository);

  Future<Cart> call() async {
    return await repository.createCart();
  }
}

