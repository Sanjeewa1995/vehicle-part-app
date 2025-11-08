import 'package:dio/dio.dart';
import 'package:vehicle_part_app/core/network/api_client.dart';
import 'package:vehicle_part_app/core/constants/api_constants.dart';
import 'package:vehicle_part_app/core/error/exceptions.dart';
import '../../models/request_list_response.dart';
import '../../models/request_detail_response.dart';
import '../../models/create_request_data.dart';

abstract class RequestRemoteDataSource {
  Future<RequestListResponse> getRequests({
    int page = 1,
    int pageSize = 10,
  });

  Future<RequestDetailResponse> getRequestById(int id);

  Future<RequestDetailResponse> createRequest(CreateRequestData data);
}

class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
  final ApiClient apiClient;

  RequestRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<RequestListResponse> getRequests({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.vehiclePartRequests,
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
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
      }

      return RequestListResponse.fromJson(responseData);
    } on AppException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<RequestDetailResponse> getRequestById(int id) async {
    try {
      final response = await apiClient.get(
        ApiConstants.vehiclePartRequestDetail(id),
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
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
      }

      return RequestDetailResponse.fromJson(responseData);
    } on AppException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<RequestDetailResponse> createRequest(CreateRequestData data) async {
    try {
      // Create FormData for multipart/form-data upload
      final formData = FormData.fromMap({
        'vehicle_type': data.vehicleType,
        'vehicle_model': data.vehicleModel,
        'vehicle_year': data.vehicleYear.toString(), // Convert to string for form-data
        'part_name': data.partName,
        'description': data.description,
        if (data.partNumber != null && data.partNumber!.isNotEmpty)
          'part_number': data.partNumber,
        if (data.vehicleImagePath != null)
          'vehicle_image': await MultipartFile.fromFile(
            data.vehicleImagePath!,
            filename: data.vehicleImagePath!.split('/').last,
          ),
        if (data.partImagePath != null)
          'part_image': await MultipartFile.fromFile(
            data.partImagePath!,
            filename: data.partImagePath!.split('/').last,
          ),
        if (data.partVideoPath != null)
          'part_video': await MultipartFile.fromFile(
            data.partVideoPath!,
            filename: data.partVideoPath!.split('/').last,
          ),
      });

      // Use longer timeout for file uploads (especially videos)
      final timeout = data.partVideoPath != null ? 120000 : 60000;

      // Don't set contentType explicitly - Dio will automatically set it with boundary for FormData
      final response = await apiClient.post(
        ApiConstants.vehiclePartRequests,
        data: formData,
        options: Options(
          sendTimeout: Duration(milliseconds: timeout),
          receiveTimeout: Duration(milliseconds: timeout),
        ),
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
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
      }

      return RequestDetailResponse.fromJson(responseData);
    } on AppException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

