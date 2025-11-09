// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemListResponse _$CartItemListResponseFromJson(
  Map<String, dynamic> json,
) => CartItemListResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$CartItemListResponseToJson(
  CartItemListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'status_code': instance.statusCode,
};
