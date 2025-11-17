import 'package:dio/dio.dart';
import 'package:vehicle_part_app/core/network/api_client.dart';
import 'package:vehicle_part_app/core/constants/api_constants.dart';
import 'package:vehicle_part_app/core/error/exceptions.dart';
import 'package:vehicle_part_app/features/order/data/models/create_order_request.dart';
import 'package:vehicle_part_app/features/order/data/models/create_order_response.dart';
import 'package:vehicle_part_app/features/order/data/models/order_list_response.dart';

abstract class OrderRemoteDataSource {
  Future<CreateOrderResponse> createOrder(CreateOrderRequest request);
  Future<OrderListResponse> getOrders({
    int page = 1,
    int pageSize = 20,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient apiClient;

  OrderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CreateOrderResponse> createOrder(CreateOrderRequest request) async {
    try {
      final response = await apiClient.post(
        ApiConstants.createOrder,
        data: request.toJson(),
      );
      
      return CreateOrderResponse.fromJson(response.data);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message ?? "Unknown error"}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderListResponse> getOrders({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.createOrder,
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );

      final responseData = response.data;
      
      // Ensure responseData is a Map
      if (responseData is! Map<String, dynamic>) {
        // If response is not a map, return empty orders response
        return OrderListResponse(
          success: true,
          message: 'No orders found',
          data: [],
          statusCode: 200,
        );
      }

      final success = responseData['success'] as bool?;
      if (success == false) {
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

      // Handle nested data structure: response.data.data contains the orders array
      // and response.data.meta contains pagination info
      final nestedData = responseData['data'];
      
      if (nestedData is Map<String, dynamic>) {
        // Extract the actual orders array from nested data.data
        final ordersData = nestedData['data'];
        final metaData = nestedData['meta'];
        
        // Create a flattened response structure for OrderListResponse
        final flattenedResponse = Map<String, dynamic>.from(responseData);
        flattenedResponse['data'] = ordersData ?? <dynamic>[];
        if (metaData != null) {
          flattenedResponse['meta'] = metaData;
        }
        
        return OrderListResponse.fromJson(flattenedResponse);
      }
      
      // Fallback: Use the safe fromJson that handles empty/null data gracefully
      return OrderListResponse.fromJson(responseData);
    } on AppException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      // If parsing fails, return empty orders instead of throwing error
      // This handles cases where API returns unexpected format
      if (e.toString().contains('type cast') || 
          e.toString().contains('subtype') ||
          e.toString().contains('List')) {
        return OrderListResponse(
          success: true,
          message: 'No orders found',
          data: [],
          statusCode: 200,
        );
      }
      throw Exception(e.toString());
    }
  }
}

