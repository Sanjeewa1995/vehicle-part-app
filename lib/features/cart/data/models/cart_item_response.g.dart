// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemResponse _$CartItemResponseFromJson(Map<String, dynamic> json) =>
    CartItemResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: CartItemModel.fromJson(json['data'] as Map<String, dynamic>),
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$CartItemResponseToJson(CartItemResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'status_code': instance.statusCode,
    };
