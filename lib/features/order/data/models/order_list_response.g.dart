// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderListResponse _$OrderListResponseFromJson(Map<String, dynamic> json) =>
    OrderListResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? []
          : OrderListResponse._dataFromJson(json['data']),
      statusCode: (json['status_code'] as num).toInt(),
      meta: json['meta'] == null
          ? null
          : OrderListMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderListResponseToJson(OrderListResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'status_code': instance.statusCode,
      'meta': instance.meta,
    };

OrderListMeta _$OrderListMetaFromJson(Map<String, dynamic> json) =>
    OrderListMeta(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      currentPage: (json['current_page'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
    );

Map<String, dynamic> _$OrderListMetaToJson(OrderListMeta instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'current_page': instance.currentPage,
      'total_pages': instance.totalPages,
    };
