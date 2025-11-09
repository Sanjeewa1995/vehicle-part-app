import 'package:equatable/equatable.dart';
import '../../../requets/domain/entities/product.dart';

class CartItem extends Equatable {
  final int? cartItemId; // ID from API, null for local items
  final Product product;
  final int quantity;
  final DateTime addedAt;

  const CartItem({
    this.cartItemId,
    required this.product,
    this.quantity = 1,
    required this.addedAt,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    int? cartItemId,
    Product? product,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      cartItemId: cartItemId ?? this.cartItemId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  List<Object?> get props => [cartItemId, product.id, quantity, addedAt];
}

