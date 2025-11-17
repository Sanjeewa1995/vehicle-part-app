// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailResponse _$OrderDetailResponseFromJson(Map<String, dynamic> json) =>
    OrderDetailResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: OrderDetailData.fromJson(json['data'] as Map<String, dynamic>),
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$OrderDetailResponseToJson(
  OrderDetailResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'status_code': instance.statusCode,
};

OrderDetailData _$OrderDetailDataFromJson(Map<String, dynamic> json) =>
    OrderDetailData(
      id: OrderDetailData._idFromJson(json['id']),
      total: OrderDetailData._totalFromJson(json['total']),
      currency: json['currency'] as String,
      referenceNumber: json['reference_number'] as String,
      source: json['source'] as String,
      status: json['status'] as String,
      cartId: OrderDetailData._cartIdFromJson(json['cart_id']),
      shippingAddress: ShippingAddress.fromJson(
        json['shipping_address'] as Map<String, dynamic>,
      ),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$OrderDetailDataToJson(OrderDetailData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'total': instance.total,
      'currency': instance.currency,
      'reference_number': instance.referenceNumber,
      'source': instance.source,
      'status': instance.status,
      'cart_id': instance.cartId,
      'shipping_address': instance.shippingAddress,
      'items': instance.items,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

ShippingAddress _$ShippingAddressFromJson(Map<String, dynamic> json) =>
    ShippingAddress(
      id: ShippingAddress._idFromJson(json['id']),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      country: json['country'] as String,
      state: json['state'] as String,
      postCode: json['post_code'] as String,
      city: json['city'] as String,
      address1: json['address1'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ShippingAddressToJson(ShippingAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'country': instance.country,
      'state': instance.state,
      'post_code': instance.postCode,
      'city': instance.city,
      'address1': instance.address1,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  id: OrderItem._idFromJson(json['id']),
  product: OrderProduct.fromJson(json['product'] as Map<String, dynamic>),
  price: OrderItem._priceFromJson(json['price']),
  currency: json['currency'] as String,
  quantity: (json['quantity'] as num).toInt(),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
  'id': instance.id,
  'product': instance.product,
  'price': instance.price,
  'currency': instance.currency,
  'quantity': instance.quantity,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

OrderProduct _$OrderProductFromJson(Map<String, dynamic> json) => OrderProduct(
  id: OrderProduct._idFromJson(json['id']),
  name: json['name'] as String,
  description: json['description'] as String,
  price: OrderProduct._priceFromJson(json['price']),
  image: json['image'] as String?,
);

Map<String, dynamic> _$OrderProductToJson(OrderProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'image': instance.image,
    };
