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
  final int id;
  final String status;
  final double total;

  const OrderData({
    required this.id,
    required this.status,
    required this.total,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) =>
      _$OrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDataToJson(this);
}

