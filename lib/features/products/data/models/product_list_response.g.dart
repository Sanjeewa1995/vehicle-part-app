// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductListResponse _$ProductListResponseFromJson(Map<String, dynamic> json) =>
    ProductListResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ProductListResponse._dataFromJson(
        json['data'] as Map<String, dynamic>,
      ),
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$ProductListResponseToJson(
  ProductListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'status_code': instance.statusCode,
};

ProductListData _$ProductListDataFromJson(Map<String, dynamic> json) =>
    ProductListData(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? []
          : ProductListData._productsFromJson(json['data']),
      statusCode: (json['status_code'] as num).toInt(),
      meta: json['meta'] == null
          ? null
          : ProductListMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductListDataToJson(ProductListData instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'status_code': instance.statusCode,
      'meta': instance.meta,
    };

ProductListMeta _$ProductListMetaFromJson(Map<String, dynamic> json) =>
    ProductListMeta(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      currentPage: (json['current_page'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
    );

Map<String, dynamic> _$ProductListMetaToJson(ProductListMeta instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'current_page': instance.currentPage,
      'total_pages': instance.totalPages,
    };
