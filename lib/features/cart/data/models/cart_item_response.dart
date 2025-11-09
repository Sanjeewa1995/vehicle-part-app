import 'package:json_annotation/json_annotation.dart';
import 'cart_item_model.dart';

part 'cart_item_response.g.dart';

@JsonSerializable()
class CartItemResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final CartItemModel data;

  @JsonKey(name: 'status_code')
  final int statusCode;

  CartItemResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  factory CartItemResponse.fromJson(Map<String, dynamic> json) =>
      _$CartItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemResponseToJson(this);
}

