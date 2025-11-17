import 'package:json_annotation/json_annotation.dart';

part 'shipping_address_model.g.dart';

@JsonSerializable()
class ShippingAddressModel {
  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  final String country;

  final String state;

  @JsonKey(name: 'post_code')
  final String postCode;

  final String city;

  @JsonKey(name: 'address1')
  final String address1;

  const ShippingAddressModel({
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.state,
    required this.postCode,
    required this.city,
    required this.address1,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressModelToJson(this);
}

