// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestStatsResponse _$RequestStatsResponseFromJson(
  Map<String, dynamic> json,
) => RequestStatsResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: RequestStatsData.fromJson(json['data'] as Map<String, dynamic>),
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$RequestStatsResponseToJson(
  RequestStatsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'status_code': instance.statusCode,
};

RequestStatsData _$RequestStatsDataFromJson(
  Map<String, dynamic> json,
) => RequestStatsData(
  totalRequests: RequestStatsData._intFromJson(json['total_requests']),
  pendingRequests: RequestStatsData._intFromJson(json['pending_requests']),
  inProgressRequests: RequestStatsData._intFromJson(
    json['in_progress_requests'],
  ),
  completedRequests: RequestStatsData._intFromJson(json['completed_requests']),
  cancelledRequests: RequestStatsData._intFromJson(json['cancelled_requests']),
);

Map<String, dynamic> _$RequestStatsDataToJson(RequestStatsData instance) =>
    <String, dynamic>{
      'total_requests': instance.totalRequests,
      'pending_requests': instance.pendingRequests,
      'in_progress_requests': instance.inProgressRequests,
      'completed_requests': instance.completedRequests,
      'cancelled_requests': instance.cancelledRequests,
    };
