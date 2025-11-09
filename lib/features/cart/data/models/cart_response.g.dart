// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartResponse _$CartResponseFromJson(Map<String, dynamic> json) => CartResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: CartModel.fromJson(json['data'] as Map<String, dynamic>),
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$CartResponseToJson(CartResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'status_code': instance.statusCode,
    };
