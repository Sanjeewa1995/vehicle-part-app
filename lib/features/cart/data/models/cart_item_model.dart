import 'package:json_annotation/json_annotation.dart';
import '../../../requets/data/models/product_model.dart';
import 'cart_model.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel {
  @JsonKey(name: 'id', fromJson: _idFromJson)
  final int id;
  
  static int _idFromJson(dynamic value) {
    if (value == null) {
      // Return a temporary negative ID for items without IDs (shouldn't happen from API)
      // This allows the app to continue but we'll handle updates differently
      return -1;
    }
    if (value is num) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed == null) {
        return -1; // Return temporary ID instead of throwing
      }
      return parsed;
    }
    return -1; // Return temporary ID instead of throwing
  }

  @JsonKey(name: 'cart')
  final CartModel cart;

  @JsonKey(name: 'product')
  final ProductModel product;

  @JsonKey(name: 'quantity', fromJson: _quantityFromJson)
  final int quantity;
  
  static int _quantityFromJson(dynamic value) {
    if (value == null) return 1;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 1;
    return 1;
  }

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  CartItemModel({
    required this.id,
    required this.cart,
    required this.product,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);
}

