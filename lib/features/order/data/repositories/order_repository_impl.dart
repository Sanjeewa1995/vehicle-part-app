import 'package:vehicle_part_app/core/error/exceptions.dart';
import 'package:vehicle_part_app/features/order/data/datasources/order_remote_datasource.dart';
import 'package:vehicle_part_app/features/order/data/models/create_order_request.dart';
import 'package:vehicle_part_app/features/order/data/models/shipping_address_model.dart';
import 'package:vehicle_part_app/features/order/data/models/order_list_response.dart';
import 'package:vehicle_part_app/features/order/data/models/order_detail_response.dart';
import 'package:vehicle_part_app/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> createOrder({
    required int cartId,
    required Map<String, dynamic> shippingAddress,
    required String source,
    required String currency,
  }) async {
    try {
      final shippingAddressModel = ShippingAddressModel(
        firstName: shippingAddress['first_name'] as String,
        lastName: shippingAddress['last_name'] as String,
        country: shippingAddress['country'] as String,
        state: shippingAddress['state'] as String,
        postCode: shippingAddress['post_code'] as String,
        city: shippingAddress['city'] as String,
        address1: shippingAddress['address1'] as String,
      );

      final request = CreateOrderRequest(
        cartId: cartId,
        shippingAddress: shippingAddressModel,
        source: source,
        currency: currency,
      );

      final response = await remoteDataSource.createOrder(request);
      
      if (response.success && response.data != null) {
        return {
          'success': true,
          'message': response.message,
          'orderId': response.data!.id,
          'status': response.data!.status,
          'total': response.data!.total,
        };
      } else {
        throw Exception(response.message);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Order creation failed: ${e.toString()}');
    }
  }

  @override
  Future<OrderListResponse> getOrders({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return await remoteDataSource.getOrders(
        page: page,
        pageSize: pageSize,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to load orders: ${e.toString()}');
    }
  }

  @override
  Future<OrderDetailResponse> getOrderById(int id) async {
    try {
      return await remoteDataSource.getOrderById(id);
    } on AppException {
      rethrow;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to load order details: ${e.toString()}');
    }
  }
}

