// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingAddressModel _$ShippingAddressModelFromJson(
  Map<String, dynamic> json,
) => ShippingAddressModel(
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  country: json['country'] as String,
  state: json['state'] as String,
  postCode: json['post_code'] as String,
  city: json['city'] as String,
  address1: json['address1'] as String,
);

Map<String, dynamic> _$ShippingAddressModelToJson(
  ShippingAddressModel instance,
) => <String, dynamic>{
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'country': instance.country,
  'state': instance.state,
  'post_code': instance.postCode,
  'city': instance.city,
  'address1': instance.address1,
};
