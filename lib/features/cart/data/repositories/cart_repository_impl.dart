import '../../domain/repositories/cart_repository.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart.dart';
import '../datasources/cart_remote_datasource.dart';
import '../models/cart_model.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  Cart _mapCartModelToEntity(CartModel model) {
    return Cart(
      id: model.id,
      sessionId: model.sessionId,
      createdAt: DateTime.parse(model.createdAt),
      updatedAt: DateTime.parse(model.updatedAt),
    );
  }

  CartItem _mapCartItemModelToEntity(CartItemModel model) {
    return CartItem(
      cartItemId: model.id,
      product: model.product,
      quantity: model.quantity,
      addedAt: DateTime.parse(model.createdAt),
    );
  }

  @override
  Future<Cart> createCart() async {
    try {
      final response = await remoteDataSource.createCart();
      return _mapCartModelToEntity(response.data);
    } catch (e) {
      String errorMessage;
      if (e is Exception) {
        errorMessage = e.toString()
            .replaceAll('Exception: ', '')
            .replaceAll('ServerException: ', '')
            .replaceAll('AuthenticationException: ', '')
            .replaceAll('NetworkException: ', '')
            .trim();
      } else {
        errorMessage = e.toString();
      }
      throw Exception(errorMessage.isEmpty ? 'Failed to create cart' : errorMessage);
    }
  }

  @override
  Future<Cart> getCart(int cartId) async {
    try {
      final response = await remoteDataSource.getCart(cartId);
      return _mapCartModelToEntity(response.data);
    } catch (e) {
      String errorMessage;
      if (e is Exception) {
        errorMessage = e.toString()
            .replaceAll('Exception: ', '')
            .replaceAll('ServerException: ', '')
            .replaceAll('AuthenticationException: ', '')
            .replaceAll('NetworkException: ', '')
            .trim();
      } else {
        errorMessage = e.toString();
      }
      throw Exception(errorMessage.isEmpty ? 'Failed to get cart' : errorMessage);
    }
  }

  @override
  Future<void> deleteCart(int cartId) async {
    try {
      await remoteDataSource.deleteCart(cartId);
    } catch (e) {
      String errorMessage;
      if (e is Exception) {
        errorMessage = e.toString()
            .replaceAll('Exception: ', '')
            .replaceAll('ServerException: ', '')
            .replaceAll('AuthenticationException: ', '')
            .replaceAll('NetworkException: ', '')
            .trim();
      } else {
        errorMessage = e.toString();
      }
      throw Exception(errorMessage.isEmpty ? 'Failed to delete cart' : errorMessage);
    }
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    try {
      final response = await remoteDataSource.getCartItems();
      return response.data.map((model) => _mapCartItemModelToEntity(model)).toList();
    } catch (e) {
      String errorMessage;
      if (e is Exception) {
        errorMessage = e.toString()
            .replaceAll('Exception: ', '')
            .replaceAll('ServerException: ', '')
            .replaceAll('AuthenticationException: ', '')
            .replaceAll('NetworkException: ', '')
            .trim();
      } else {
        errorMessage = e.toString();
      }
      throw Exception(errorMessage.isEmpty ? 'Failed to get cart items' : errorMessage);
    }
  }

  @override
  Future<CartItem> addCartItem({
    required int cartId,
    required int productId,
    required int quantity,
  }) async {
    try {
      final response = await remoteDataSource.addCartItem(
        cartId: cartId,
        productId: productId,
        quantity: quantity,
      );
      return _mapCartItemModelToEntity(response.data);
    } catch (e) {
      String errorMessage;
      if (e is Exception) {
        errorMessage = e.toString()
            .replaceAll('Exception: ', '')
            .replaceAll('ServerException: ', '')
            .replaceAll('AuthenticationException: ', '')
            .replaceAll('NetworkException: ', '')
            .trim();
      } else {
        errorMessage = e.toString();
      }
      throw Exception(errorMessage.isEmpty ? 'Failed to add item to cart' : errorMessage);
    }
  }

  @override
  Future<CartItem> updateCartItem({
    required int cartItemId,
    required int quantity,
  }) async {
    try {
      final response = await remoteDataSource.updateCartItem(
        cartItemId: cartItemId,
        quantity: quantity,
      );
      return _mapCartItemModelToEntity(response.data);
    } catch (e) {
      String errorMessage;
      if (e is Exception) {
        errorMessage = e.toString()
            .replaceAll('Exception: ', '')
            .replaceAll('ServerException: ', '')
            .replaceAll('AuthenticationException: ', '')
            .replaceAll('NetworkException: ', '')
            .trim();
      } else {
        errorMessage = e.toString();
      }
      throw Exception(errorMessage.isEmpty ? 'Failed to update cart item' : errorMessage);
    }
  }

  @override
  Future<void> deleteCartItem(int cartItemId) async {
    try {
      await remoteDataSource.deleteCartItem(cartItemId);
    } catch (e) {
      String errorMessage;
      if (e is Exception) {
        errorMessage = e.toString()
            .replaceAll('Exception: ', '')
            .replaceAll('ServerException: ', '')
            .replaceAll('AuthenticationException: ', '')
            .replaceAll('NetworkException: ', '')
            .trim();
      } else {
        errorMessage = e.toString();
      }
      throw Exception(errorMessage.isEmpty ? 'Failed to delete cart item' : errorMessage);
    }
  }
}

