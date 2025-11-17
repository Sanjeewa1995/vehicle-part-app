// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    CreateOrderRequest(
      cartId: (json['cart_id'] as num).toInt(),
      shippingAddress: ShippingAddressModel.fromJson(
        json['shipping_address'] as Map<String, dynamic>,
      ),
      source: json['source'] as String,
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$CreateOrderRequestToJson(CreateOrderRequest instance) =>
    <String, dynamic>{
      'cart_id': instance.cartId,
      'shipping_address': instance.shippingAddress.toJson(),
      'source': instance.source,
      'currency': instance.currency,
    };
