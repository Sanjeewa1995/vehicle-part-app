import 'package:dio/dio.dart';
import 'package:vehicle_part_app/core/network/api_client.dart';
import 'package:vehicle_part_app/core/constants/api_constants.dart';
import 'package:vehicle_part_app/core/error/exceptions.dart';
import 'package:vehicle_part_app/features/order/data/models/create_order_request.dart';
import 'package:vehicle_part_app/features/order/data/models/create_order_response.dart';

abstract class OrderRemoteDataSource {
  Future<CreateOrderResponse> createOrder(CreateOrderRequest request);
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
}

