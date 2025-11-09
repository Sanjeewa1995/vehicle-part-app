// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      id: CartItemModel._idFromJson(json['id']),
      cart: CartModel.fromJson(json['cart'] as Map<String, dynamic>),
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: CartItemModel._quantityFromJson(json['quantity']),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cart': instance.cart,
      'product': instance.product,
      'quantity': instance.quantity,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
