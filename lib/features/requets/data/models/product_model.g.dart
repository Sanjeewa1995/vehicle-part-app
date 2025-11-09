// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  productId: (json['id'] as num).toInt(),
  productName: json['name'] as String,
  productDescription: json['description'] as String,
  productPrice: json['price'] as String,
  productImage: json['image'] as String?,
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.productId,
      'name': instance.productName,
      'description': instance.productDescription,
      'price': instance.productPrice,
      'image': instance.productImage,
    };
