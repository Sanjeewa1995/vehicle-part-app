import 'package:vehicle_part_app/core/network/api_client.dart';
import 'package:vehicle_part_app/core/constants/api_constants.dart';
import 'package:vehicle_part_app/core/error/exceptions.dart';
import '../../models/product_list_response.dart';

abstract class ProductRemoteDataSource {
  Future<ProductListResponse> getProducts({
    int page = 1,
    int pageSize = 10,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProductListResponse> getProducts({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.storeProducts,
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );

      final responseData = response.data;
      
      // Debug: Print response structure
      if (responseData is Map<String, dynamic>) {
        // Check if responseData has the expected structure
        if (responseData['data'] == null) {
          throw Exception('API response missing data field. Response: ${responseData.toString()}');
        }
        
        final success = responseData['success'] as bool?;
        if (success == false) {
          // Extract error message from common API error format
          String? errorMessage = responseData['message'] as String?;

          if (errorMessage == null || errorMessage.isEmpty) {
            final errors = responseData['errors'] as Map<String, dynamic>?;
            if (errors != null) {
              final nonFieldErrors = errors['non_field_errors'] as List?;
              if (nonFieldErrors != null && nonFieldErrors.isNotEmpty) {
                final firstError = nonFieldErrors.first;
                errorMessage = firstError is String ? firstError : firstError.toString();
              }
            }
          }

          if (errorMessage == null || errorMessage.isEmpty) {
            errorMessage = responseData['error'] as String?;
          }

          throw Exception(errorMessage ?? 'An error occurred');
        }
      } else {
        throw Exception('Invalid response format: ${responseData.runtimeType}');
      }

      try {
        return ProductListResponse.fromJson(responseData as Map<String, dynamic>);
      } catch (e) {
        throw Exception('Failed to parse product response: $e. Response data: $responseData');
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

