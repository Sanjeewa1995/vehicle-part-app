// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderResponse _$CreateOrderResponseFromJson(Map<String, dynamic> json) =>
    CreateOrderResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : OrderData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateOrderResponseToJson(
  CreateOrderResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

OrderData _$OrderDataFromJson(Map<String, dynamic> json) => OrderData(
  id: (json['id'] as num).toInt(),
  status: json['status'] as String,
  total: json['total'] is String 
      ? double.parse(json['total'] as String)
      : (json['total'] as num).toDouble(),
);

Map<String, dynamic> _$OrderDataToJson(OrderData instance) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'total': instance.total,
};
