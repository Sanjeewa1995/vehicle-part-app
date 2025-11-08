// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestDetailResponse _$RequestDetailResponseFromJson(
  Map<String, dynamic> json,
) => RequestDetailResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: VehiclePartRequestModel.fromJson(json['data'] as Map<String, dynamic>),
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$RequestDetailResponseToJson(
  RequestDetailResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'status_code': instance.statusCode,
};
