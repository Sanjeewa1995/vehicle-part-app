import 'package:json_annotation/json_annotation.dart';

part 'request_stats_response.g.dart';

@JsonSerializable()
class RequestStatsResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final RequestStatsData data;

  @JsonKey(name: 'status_code')
  final int statusCode;

  const RequestStatsResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  factory RequestStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestStatsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestStatsResponseToJson(this);
}

@JsonSerializable()
class RequestStatsData {
  @JsonKey(name: 'total_requests', fromJson: _intFromJson)
  final int totalRequests;

  @JsonKey(name: 'pending_requests', fromJson: _intFromJson)
  final int pendingRequests;

  @JsonKey(name: 'in_progress_requests', fromJson: _intFromJson)
  final int inProgressRequests;

  @JsonKey(name: 'completed_requests', fromJson: _intFromJson)
  final int completedRequests;

  @JsonKey(name: 'cancelled_requests', fromJson: _intFromJson)
  final int cancelledRequests;

  const RequestStatsData({
    required this.totalRequests,
    required this.pendingRequests,
    required this.inProgressRequests,
    required this.completedRequests,
    required this.cancelledRequests,
  });

  static int _intFromJson(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory RequestStatsData.fromJson(Map<String, dynamic> json) =>
      _$RequestStatsDataFromJson(json);

  Map<String, dynamic> toJson() => _$RequestStatsDataToJson(this);
}

