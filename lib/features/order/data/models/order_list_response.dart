import 'package:json_annotation/json_annotation.dart';
import 'order_model.dart';

part 'order_list_response.g.dart';

@JsonSerializable()
class OrderListResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data', fromJson: _dataFromJson, defaultValue: <OrderModel>[])
  final List<OrderModel> data;

  @JsonKey(name: 'status_code')
  final int statusCode;

  @JsonKey(name: 'meta')
  final OrderListMeta? meta;

  const OrderListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
    this.meta,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    // Handle null data field
    if (json['data'] == null) {
      // Return empty list if data is null
      final safeJson = Map<String, dynamic>.from(json);
      safeJson['data'] = <dynamic>[];
      return _$OrderListResponseFromJson(safeJson);
    }
    
    // Ensure data is a List before parsing
    final dataValue = json['data'];
    if (dataValue is! List) {
      // If it's not a list (e.g., it's a Map), return empty list
      final safeJson = Map<String, dynamic>.from(json);
      safeJson['data'] = <dynamic>[];
      return _$OrderListResponseFromJson(safeJson);
    }
    
    return _$OrderListResponseFromJson(json);
  }

  static List<OrderModel> _dataFromJson(dynamic json) {
    if (json == null) {
      return [];
    }
    if (json is! List) {
      // If it's not a list, return empty list
      return [];
    }
    if (json.isEmpty) {
      return [];
    }
    return json
        .map((orderJson) {
          if (orderJson is! Map<String, dynamic>) {
            throw Exception('Order item is not a Map: ${orderJson.runtimeType}');
          }
          return OrderModel.fromJson(orderJson);
        })
        .toList();
  }

  Map<String, dynamic> toJson() => _$OrderListResponseToJson(this);
}

@JsonSerializable()
class OrderListMeta {
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

  const OrderListMeta({
    required this.count,
    this.next,
    this.previous,
    required this.currentPage,
    required this.totalPages,
  });

  factory OrderListMeta.fromJson(Map<String, dynamic> json) =>
      _$OrderListMetaFromJson(json);

  Map<String, dynamic> toJson() => _$OrderListMetaToJson(this);
}

