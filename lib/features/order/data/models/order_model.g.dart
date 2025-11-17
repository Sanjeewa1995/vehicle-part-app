// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: OrderModel._idFromJson(json['id']),
  total: OrderModel._totalFromJson(json['total']),
  currency: json['currency'] as String,
  referenceNumber: json['reference_number'] as String,
  source: json['source'] as String,
  status: json['status'] as String,
  cartId: OrderModel._cartIdFromJson(json['cart_id']),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'total': instance.total,
      'currency': instance.currency,
      'reference_number': instance.referenceNumber,
      'source': instance.source,
      'status': instance.status,
      'cart_id': instance.cartId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
