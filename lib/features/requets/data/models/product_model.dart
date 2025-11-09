import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends Product {
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

  ProductModel({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    this.productImage,
  }) : super(
          id: productId,
          name: productName,
          description: productDescription,
          price: productPrice,
          image: productImage,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

