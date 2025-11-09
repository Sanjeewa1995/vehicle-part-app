import 'package:vehicle_part_app/core/network/api_client.dart';
import 'package:vehicle_part_app/core/constants/api_constants.dart';
import 'package:vehicle_part_app/core/error/exceptions.dart';
import '../models/cart_response.dart';
import '../models/cart_item_list_response.dart';
import '../models/cart_item_response.dart';
import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<CartResponse> createCart();
  Future<CartResponse> getCart(int cartId);
  Future<void> deleteCart(int cartId);
  Future<CartItemListResponse> getCartItems();
  Future<CartItemResponse> addCartItem({
    required int cartId,
    required int productId,
    required int quantity,
  });
  Future<CartItemResponse> updateCartItem({
    required int cartItemId,
    required int quantity,
  });
  Future<void> deleteCartItem(int cartItemId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient apiClient;

  CartRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CartResponse> createCart() async {
    try {
      final response = await apiClient.post(
        ApiConstants.carts,
        data: {},
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final success = responseData['success'] as bool?;
        if (success == false) {
          String? errorMessage = responseData['message'] as String?;
          throw Exception(errorMessage ?? 'Failed to create cart');
        }
      }

      return CartResponse.fromJson(responseData);
    } on AppException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CartResponse> getCart(int cartId) async {
    try {
      final response = await apiClient.get(
        ApiConstants.cartDetail(cartId),
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final success = responseData['success'] as bool?;
        if (success == false) {
          String? errorMessage = responseData['message'] as String?;
          throw Exception(errorMessage ?? 'Failed to get cart');
        }
      }

      return CartResponse.fromJson(responseData);
    } on AppException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteCart(int cartId) async {
    try {
      final response = await apiClient.delete(
        ApiConstants.cartDetail(cartId),
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final success = responseData['success'] as bool?;
        if (success == false) {
          String? errorMessage = responseData['message'] as String?;
          throw Exception(errorMessage ?? 'Failed to delete cart');
        }
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CartItemListResponse> getCartItems() async {
    try {
      final response = await apiClient.get(
        ApiConstants.cartItems,
      );

      final responseData = response.data;
      
      // Handle null response
      if (responseData == null) {
        return CartItemListResponse(
          success: true,
          message: 'Cart items retrieved successfully',
          data: [],
          statusCode: 200,
        );
      }
      
      // Handle different response structures
      if (responseData is List) {
        // If response is directly a list, wrap it in the expected format
        return CartItemListResponse(
          success: true,
          message: 'Cart items retrieved successfully',
          data: responseData
              .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          statusCode: 200,
        );
      }
      
      if (responseData is Map<String, dynamic>) {
        final success = responseData['success'] as bool?;
        if (success == false) {
          String? errorMessage = responseData['message'] as String?;
          throw Exception(errorMessage ?? 'Failed to get cart items');
        }
        
        // Check if data exists
        final data = responseData['data'];
        if (data == null) {
          return CartItemListResponse(
            success: success ?? true,
            message: responseData['message'] as String? ?? 'Cart items retrieved successfully',
            data: [],
            statusCode: (responseData['status_code'] as num?)?.toInt() ?? 200,
          );
        }
        
        // Handle nested data structure (data.data contains the actual list)
        if (data is Map<String, dynamic>) {
          final nestedData = data['data'];
          if (nestedData is List) {
            // Extract the actual list from nested structure
            return CartItemListResponse(
              success: success ?? true,
              message: responseData['message'] as String? ?? 'Cart items retrieved successfully',
              data: nestedData
                  .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
              statusCode: (responseData['status_code'] as num?)?.toInt() ?? 200,
            );
          } else if (nestedData is Map<String, dynamic>) {
            // Single item in nested structure
            return CartItemListResponse(
              success: success ?? true,
              message: responseData['message'] as String? ?? 'Cart items retrieved successfully',
              data: [CartItemModel.fromJson(nestedData)],
              statusCode: (responseData['status_code'] as num?)?.toInt() ?? 200,
            );
          }
        }
        
        // Ensure data is a List before parsing
        if (data is List) {
          return CartItemListResponse.fromJson(responseData);
        } else if (data is Map<String, dynamic>) {
          // If data is a single Map (single item), wrap it in a List
          return CartItemListResponse(
            success: success ?? true,
            message: responseData['message'] as String? ?? 'Cart items retrieved successfully',
            data: [CartItemModel.fromJson(data)],
            statusCode: (responseData['status_code'] as num?)?.toInt() ?? 200,
          );
        } else {
          // If data is not a list or map, return empty
          return CartItemListResponse(
            success: success ?? true,
            message: responseData['message'] as String? ?? 'Cart items retrieved successfully',
            data: [],
            statusCode: (responseData['status_code'] as num?)?.toInt() ?? 200,
          );
        }
      }

      // Fallback: try to parse as Map
      try {
        return CartItemListResponse.fromJson(responseData as Map<String, dynamic>);
      } catch (e) {
        // Return empty cart on parse error
        return CartItemListResponse(
          success: true,
          message: 'Cart items retrieved successfully',
          data: [],
          statusCode: 200,
        );
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CartItemResponse> addCartItem({
    required int cartId,
    required int productId,
    required int quantity,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.cartItems,
        data: {
          'cart_id': cartId,
          'product_id': productId,
          'quantity': quantity,
        },
      );

      final responseData = response.data;
      
      // Handle null response
      if (responseData == null) {
        throw Exception('Failed to add item to cart: Empty response from server');
      }
      
      // Check if responseData is a Map
      if (responseData is! Map<String, dynamic>) {
        throw Exception('Failed to add item to cart: Invalid response format');
      }
      
      final success = responseData['success'] as bool?;
      if (success == false) {
        String? errorMessage = responseData['message'] as String?;
        throw Exception(errorMessage ?? 'Failed to add item to cart');
      }
      
      // Handle nested data structure (data.data contains the actual item)
      final data = responseData['data'];
      if (data != null) {
        if (data is Map<String, dynamic>) {
          final nestedData = data['data'];
          if (nestedData is Map<String, dynamic>) {
            // Extract the actual item from nested structure
            return CartItemResponse(
              success: success ?? true,
              message: responseData['message'] as String? ?? 'Cart item added successfully',
              data: CartItemModel.fromJson(nestedData),
              statusCode: (responseData['status_code'] as num?)?.toInt() ?? 200,
            );
          } else if (data['id'] != null) {
            // Data is directly the cart item (not nested)
            return CartItemResponse(
              success: success ?? true,
              message: responseData['message'] as String? ?? 'Cart item added successfully',
              data: CartItemModel.fromJson(data),
              statusCode: (responseData['status_code'] as num?)?.toInt() ?? 200,
            );
          }
        }
      }

      // Check if data field exists and is not null before parsing
      final responseDataField = responseData['data'];
      if (responseDataField == null || responseDataField is! Map<String, dynamic>) {
        throw Exception('Failed to add item to cart: Invalid or missing data in response');
      }

      // Try to parse as CartItemResponse directly
      return CartItemResponse.fromJson(responseData);
    } on AppException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CartItemResponse> updateCartItem({
    required int cartItemId,
    required int quantity,
  }) async {
    try {
      final response = await apiClient.patch(
        ApiConstants.cartItemDetail(cartItemId),
        data: {
          'quantity': quantity,
        },
      );

      final responseData = response.data;
      final statusCode = response.statusCode ?? 200;
      
      // Handle 204 No Content or null response (some APIs return null on successful update)
      if (responseData == null) {
        if (statusCode == 204 || statusCode == 200) {
          // Update was successful but no response body, throw special exception
          // The caller should refresh the cart to get updated data
          throw Exception('UPDATE_SUCCESS_NO_RESPONSE');
        }
        throw Exception('Failed to update cart item: Empty response from server');
      }
      
      // Check if responseData is a Map
      if (responseData is! Map<String, dynamic>) {
        throw Exception('Failed to update cart item: Invalid response format');
      }
      
      final success = responseData['success'] as bool?;
      if (success == false) {
        String? errorMessage = responseData['message'] as String?;
        throw Exception(errorMessage ?? 'Failed to update cart item');
      }
      
      // Handle nested data structure (data.data contains the actual item)
      final data = responseData['data'];
      if (data != null) {
        if (data is Map<String, dynamic>) {
          final nestedData = data['data'];
          if (nestedData is Map<String, dynamic>) {
            // Extract the actual item from nested structure
            return CartItemResponse(
              success: success ?? true,
              message: responseData['message'] as String? ?? 'Cart item updated successfully',
              data: CartItemModel.fromJson(nestedData),
              statusCode: (responseData['status_code'] as num?)?.toInt() ?? statusCode,
            );
          } else if (data['id'] != null) {
            // Data is directly the cart item (not nested)
            return CartItemResponse(
              success: success ?? true,
              message: responseData['message'] as String? ?? 'Cart item updated successfully',
              data: CartItemModel.fromJson(data),
              statusCode: (responseData['status_code'] as num?)?.toInt() ?? statusCode,
            );
          }
        }
      }

      // Check if data field exists and is not null before parsing
      final responseDataField = responseData['data'];
      if (responseDataField == null || responseDataField is! Map<String, dynamic>) {
        // If update was successful but no valid data, refresh cart
        if (success == true || statusCode == 200 || statusCode == 204) {
          throw Exception('UPDATE_SUCCESS_NO_RESPONSE');
        }
        throw Exception('Failed to update cart item: Invalid or missing data in response');
      }

      // Try to parse as CartItemResponse directly
      return CartItemResponse.fromJson(responseData);
    } on AppException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteCartItem(int cartItemId) async {
    try {
      final response = await apiClient.delete(
        ApiConstants.cartItemDetail(cartItemId),
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final success = responseData['success'] as bool?;
        if (success == false) {
          String? errorMessage = responseData['message'] as String?;
          throw Exception(errorMessage ?? 'Failed to delete cart item');
        }
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

