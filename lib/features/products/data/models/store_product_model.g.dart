// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreProductModel _$StoreProductModelFromJson(Map<String, dynamic> json) =>
    StoreProductModel(
      productId: (json['id'] as num).toInt(),
      productName: json['name'] as String,
      productDescription: json['description'] as String,
      productPrice: json['price'] as String,
      productImage: json['image'] as String?,
      productRequest: StoreProductModel._requestFromJson(json['request']),
      productCreatedAt: json['created_at'] as String,
      productUpdatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$StoreProductModelToJson(StoreProductModel instance) =>
    <String, dynamic>{
      'id': instance.productId,
      'name': instance.productName,
      'description': instance.productDescription,
      'price': instance.productPrice,
      'image': instance.productImage,
      'request': ?instance.productRequest,
      'created_at': instance.productCreatedAt,
      'updated_at': instance.productUpdatedAt,
    };
