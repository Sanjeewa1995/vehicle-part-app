import 'package:json_annotation/json_annotation.dart';

part 'create_order_response.g.dart';

@JsonSerializable()
class CreateOrderResponse {
  final bool success;
  final String message;
  final OrderData? data;

  const CreateOrderResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderResponseToJson(this);
}

@JsonSerializable()
class OrderData {
  @JsonKey(name: 'id', fromJson: _idFromJson)
  final int id;
  
  final String status;
  
  @JsonKey(name: 'total', fromJson: _totalFromJson)
  final double total;

  const OrderData({
    required this.id,
    required this.status,
    required this.total,
  });

  static int _idFromJson(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _totalFromJson(dynamic value) {
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is num) return value.toDouble();
    return 0.0;
  }

  factory OrderData.fromJson(Map<String, dynamic> json) {
    // Handle type conversion safely for id and total
    final idValue = json['id'];
    final totalValue = json['total'];
    
    return OrderData(
      id: _idFromJson(idValue),
      status: json['status'] as String,
      total: _totalFromJson(totalValue),
    );
  }

  Map<String, dynamic> toJson() => _$OrderDataToJson(this);
}

