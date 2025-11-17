import 'package:json_annotation/json_annotation.dart';
import 'shipping_address_model.dart';

part 'create_order_request.g.dart';

@JsonSerializable()
class CreateOrderRequest {
  @JsonKey(name: 'cart_id')
  final int cartId;

  @JsonKey(name: 'shipping_address')
  final ShippingAddressModel shippingAddress;

  final String source;

  final String currency;

  const CreateOrderRequest({
    required this.cartId,
    required this.shippingAddress,
    required this.source,
    required this.currency,
  });

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}

