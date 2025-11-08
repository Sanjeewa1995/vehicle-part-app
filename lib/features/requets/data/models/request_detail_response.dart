import 'package:json_annotation/json_annotation.dart';
import 'vehicle_part_request_model.dart';

part 'request_detail_response.g.dart';

@JsonSerializable()
class RequestDetailResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final VehiclePartRequestModel data;

  @JsonKey(name: 'status_code')
  final int statusCode;

  const RequestDetailResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  factory RequestDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestDetailResponseToJson(this);
}

