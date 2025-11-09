import 'package:json_annotation/json_annotation.dart';
import 'cart_item_model.dart';

part 'cart_item_list_response.g.dart';

@JsonSerializable()
class CartItemListResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final List<CartItemModel> data;

  @JsonKey(name: 'status_code')
  final int statusCode;

  CartItemListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  factory CartItemListResponse.fromJson(Map<String, dynamic> json) =>
      _$CartItemListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemListResponseToJson(this);
}

