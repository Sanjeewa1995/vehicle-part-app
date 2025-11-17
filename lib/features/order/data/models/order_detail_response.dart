import 'package:json_annotation/json_annotation.dart';

part 'order_detail_response.g.dart';

@JsonSerializable()
class OrderDetailResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final OrderDetailData data;

  @JsonKey(name: 'status_code')
  final int statusCode;

  const OrderDetailResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailResponseToJson(this);
}

@JsonSerializable()
class OrderDetailData {
  @JsonKey(name: 'id', fromJson: _idFromJson)
  final int id;

  @JsonKey(name: 'total', fromJson: _totalFromJson)
  final double total;

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

  @JsonKey(name: 'shipping_address')
  final ShippingAddress shippingAddress;

  @JsonKey(name: 'items')
  final List<OrderItem> items;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const OrderDetailData({
    required this.id,
    required this.total,
    required this.currency,
    required this.referenceNumber,
    required this.source,
    required this.status,
    this.cartId,
    required this.shippingAddress,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
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

  static int? _cartIdFromJson(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  factory OrderDetailData.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailDataToJson(this);
}

@JsonSerializable()
class ShippingAddress {
  @JsonKey(name: 'id', fromJson: _idFromJson)
  final int id;

  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  @JsonKey(name: 'country')
  final String country;

  @JsonKey(name: 'state')
  final String state;

  @JsonKey(name: 'post_code')
  final String postCode;

  @JsonKey(name: 'city')
  final String city;

  @JsonKey(name: 'address1')
  final String address1;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const ShippingAddress({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.state,
    required this.postCode,
    required this.city,
    required this.address1,
    required this.createdAt,
    required this.updatedAt,
  });

  static int _idFromJson(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);

  String get fullName => '$firstName $lastName';
  
  String get fullAddress => '$address1, $city, $state, $postCode, $country';
}

@JsonSerializable()
class OrderItem {
  @JsonKey(name: 'id', fromJson: _idFromJson)
  final int id;

  @JsonKey(name: 'product')
  final OrderProduct product;

  @JsonKey(name: 'price', fromJson: _priceFromJson)
  final double price;

  @JsonKey(name: 'currency')
  final String currency;

  @JsonKey(name: 'quantity')
  final int quantity;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const OrderItem({
    required this.id,
    required this.product,
    required this.price,
    required this.currency,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  static int _idFromJson(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _priceFromJson(dynamic value) {
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is num) return value.toDouble();
    return 0.0;
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

@JsonSerializable()
class OrderProduct {
  @JsonKey(name: 'id', fromJson: _idFromJson)
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'price', fromJson: _priceFromJson)
  final double price;

  @JsonKey(name: 'image')
  final String? image;

  const OrderProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
  });

  static int _idFromJson(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _priceFromJson(dynamic value) {
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is num) return value.toDouble();
    return 0.0;
  }

  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductToJson(this);
}

