import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  @JsonKey(name: 'id', fromJson: _idFromJson)
  final int id;

  static int _idFromJson(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @JsonKey(name: 'total', fromJson: _totalFromJson)
  final double total;

  static double _totalFromJson(dynamic value) {
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is num) return value.toDouble();
    return 0.0;
  }

  @JsonKey(name: 'currency')
  final String currency;

  @JsonKey(name: 'reference_number')
  final String referenceNumber;

  @JsonKey(name: 'source')
  final String source;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'cart_id', fromJson: _cartIdFromJson)
  final int? cartId;

  static int? _cartIdFromJson(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const OrderModel({
    required this.id,
    required this.total,
    required this.currency,
    required this.referenceNumber,
    required this.source,
    required this.status,
    this.cartId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

