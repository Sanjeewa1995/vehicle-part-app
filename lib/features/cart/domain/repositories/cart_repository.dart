import '../../domain/entities/cart_item.dart';
import '../entities/cart.dart';

abstract class CartRepository {
  Future<Cart> createCart();
  Future<Cart> getCart(int cartId);
  Future<void> deleteCart(int cartId);
  Future<List<CartItem>> getCartItems();
  Future<CartItem> addCartItem({
    required int cartId,
    required int productId,
    required int quantity,
  });
  Future<CartItem> updateCartItem({
    required int cartItemId,
    required int quantity,
  });
  Future<void> deleteCartItem(int cartItemId);
}

