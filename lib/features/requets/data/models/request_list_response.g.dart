// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestListResponse _$RequestListResponseFromJson(Map<String, dynamic> json) =>
    RequestListResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => VehiclePartRequestModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      statusCode: (json['status_code'] as num).toInt(),
      meta: json['meta'] == null
          ? null
          : RequestListMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RequestListResponseToJson(
  RequestListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'status_code': instance.statusCode,
  'meta': instance.meta,
};

RequestListMeta _$RequestListMetaFromJson(Map<String, dynamic> json) =>
    RequestListMeta(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      currentPage: (json['current_page'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
    );

Map<String, dynamic> _$RequestListMetaToJson(RequestListMeta instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'current_page': instance.currentPage,
      'total_pages': instance.totalPages,
    };
