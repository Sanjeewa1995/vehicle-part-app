import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/store_product.dart';
import '../../../requets/data/models/vehicle_part_request_model.dart';

part 'store_product_model.g.dart';

@JsonSerializable()
class StoreProductModel extends StoreProduct {
  @JsonKey(name: 'id')
  final int productId;

  @JsonKey(name: 'name')
  final String productName;

  @JsonKey(name: 'description')
  final String productDescription;

  @JsonKey(name: 'price')
  final String productPrice;

  @JsonKey(name: 'image')
  final String? productImage;

  @JsonKey(name: 'request', fromJson: _requestFromJson, includeIfNull: false)
  final VehiclePartRequestModel? productRequest;

  @JsonKey(name: 'created_at')
  final String productCreatedAt;

  @JsonKey(name: 'updated_at')
  final String productUpdatedAt;

  static VehiclePartRequestModel? _requestFromJson(dynamic json) {
    if (json == null) return null;
    if (json is! Map<String, dynamic>) {
      // If request is not a Map, return null instead of throwing
      return null;
    }
    
    // Handle cases where request object might be missing required fields
    // Create a safe copy and provide defaults for missing fields
    final safeJson = Map<String, dynamic>.from(json);
    
    // If user field is missing or null, we can't create a valid VehiclePartRequestModel
    // So return null instead of throwing
    if (safeJson['user'] == null || safeJson['user'] is! Map<String, dynamic>) {
      return null;
    }
    
    // If products field is missing or null, provide empty list
    if (safeJson['products'] == null || safeJson['products'] is! List) {
      safeJson['products'] = <dynamic>[];
    }
    
    try {
      return VehiclePartRequestModel.fromJson(safeJson);
    } catch (e) {
      // If parsing fails, return null instead of throwing
      // This allows products to be displayed even if request parsing fails
      return null;
    }
  }

  StoreProductModel({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    this.productImage,
    this.productRequest,
    required this.productCreatedAt,
    required this.productUpdatedAt,
  }) : super(
          id: productId,
          name: productName,
          description: productDescription,
          price: productPrice,
          image: productImage,
          request: productRequest,
          createdAt: DateTime.parse(productCreatedAt),
          updatedAt: DateTime.parse(productUpdatedAt),
        );

  factory StoreProductModel.fromJson(Map<String, dynamic> json) =>
      _$StoreProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreProductModelToJson(this);
}

