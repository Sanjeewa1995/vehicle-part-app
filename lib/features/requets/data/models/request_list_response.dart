import 'package:json_annotation/json_annotation.dart';
import 'vehicle_part_request_model.dart';

part 'request_list_response.g.dart';

@JsonSerializable()
class RequestListResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final List<VehiclePartRequestModel> data;

  @JsonKey(name: 'status_code')
  final int statusCode;

  @JsonKey(name: 'meta')
  final RequestListMeta? meta;

  const RequestListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
    this.meta,
  });

  factory RequestListResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestListResponseToJson(this);
}

@JsonSerializable()
class RequestListMeta {
  @JsonKey(name: 'count')
  final int count;

  @JsonKey(name: 'next')
  final String? next;

  @JsonKey(name: 'previous')
  final String? previous;

  @JsonKey(name: 'current_page')
  final int currentPage;

  @JsonKey(name: 'total_pages')
  final int totalPages;

  const RequestListMeta({
    required this.count,
    this.next,
    this.previous,
    required this.currentPage,
    required this.totalPages,
  });

  factory RequestListMeta.fromJson(Map<String, dynamic> json) =>
      _$RequestListMetaFromJson(json);

  Map<String, dynamic> toJson() => _$RequestListMetaToJson(this);
}

