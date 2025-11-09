import 'package:json_annotation/json_annotation.dart';
import 'cart_model.dart';

part 'cart_response.g.dart';

@JsonSerializable()
class CartResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final CartModel data;

  @JsonKey(name: 'status_code')
  final int statusCode;

  CartResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) =>
      _$CartResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CartResponseToJson(this);
}

