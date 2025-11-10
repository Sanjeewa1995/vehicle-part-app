import 'package:json_annotation/json_annotation.dart';
import 'store_product_model.dart';

part 'product_list_response.g.dart';

@JsonSerializable()
class ProductListResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data', fromJson: _dataFromJson)
  final ProductListData data;

  @JsonKey(name: 'status_code')
  final int statusCode;

  const ProductListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    // Handle null data field
    if (json['data'] == null) {
      throw Exception('Data field is null in API response');
    }
    
    // Ensure data is a Map before parsing
    final dataValue = json['data'];
    if (dataValue is! Map<String, dynamic>) {
      throw Exception('Data field is not a Map: ${dataValue.runtimeType}');
    }
    
    // Create a safe copy with proper typing
    final safeJson = Map<String, dynamic>.from(json);
    safeJson['data'] = dataValue;
    
    return _$ProductListResponseFromJson(safeJson);
  }

  static ProductListData _dataFromJson(Map<String, dynamic> json) {
    return ProductListData.fromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductListResponseToJson(this);
}

@JsonSerializable()
class ProductListData {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data', fromJson: _productsFromJson, defaultValue: <StoreProductModel>[])
  final List<StoreProductModel> data;

  @JsonKey(name: 'status_code')
  final int statusCode;

  @JsonKey(name: 'meta')
  final ProductListMeta? meta;

  const ProductListData({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
    this.meta,
  });

  static List<StoreProductModel> _productsFromJson(dynamic json) {
    if (json == null) {
      return [];
    }
    if (json is! List) {
      // If it's not a list, try to handle it gracefully
      return [];
    }
    if (json.isEmpty) {
      return [];
    }
    return json
        .map((productJson) {
          if (productJson is! Map<String, dynamic>) {
            throw Exception('Product item is not a Map: ${productJson.runtimeType}');
          }
          return StoreProductModel.fromJson(productJson);
        })
        .toList();
  }

  factory ProductListData.fromJson(Map<String, dynamic> json) =>
      _$ProductListDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListDataToJson(this);
}

@JsonSerializable()
class ProductListMeta {
  @JsonKey(name: 'count')
  final int count;

  @JsonKey(name: 'next')
  final String? next;

  @JsonKey(name: 'previous')
  final String? previous;

  @JsonKey(name: 'current_page')
  final int currentPage;

  @JsonKey(name: 'total_pages')
  final int totalPages;

  const ProductListMeta({
    required this.count,
    this.next,
    this.previous,
    required this.currentPage,
    required this.totalPages,
  });

  factory ProductListMeta.fromJson(Map<String, dynamic> json) =>
      _$ProductListMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListMetaToJson(this);
}

