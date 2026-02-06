import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../config/env.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';
import '../services/refresh_token_service.dart';
import '../utils/error_message_helper.dart';

class ApiClient {
  late final Dio _dio;

  final Future<String?> Function()? getAccessToken;

  ApiClient({this.getAccessToken}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env
            .apiBaseUrl, // Base URL without /v1 since endpoints include /api/v1
        connectTimeout: const Duration(
          milliseconds: AppConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: AppConstants.receiveTimeout,
        ),
        headers: {'Content-Type': ApiConstants.contentType},
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Remove Content-Type header for FormData - Dio will set it automatically with boundary
          if (options.data is FormData) {
            options.headers.remove('Content-Type');
          }

          // Add auth token if available
          if (getAccessToken != null) {
            final token = await getAccessToken!();
            if (token != null && token.isNotEmpty) {
              options.headers[ApiConstants.authorization] =
                  '${ApiConstants.bearer} $token';
            }
          }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized - try to refresh token
          if (error.response?.statusCode == 401) {
            // Skip refresh for login/refresh endpoints to avoid infinite loops
            final requestPath = error.requestOptions.path;
            if (requestPath.contains('/auth/login') ||
                requestPath.contains('/auth/register') ||
                requestPath.contains('/token/refresh')) {
              return handler.next(_handleError(error));
            }

            try {
              // Refresh the token
              final newAccessToken = await RefreshTokenService.refreshTokenWithQueue();

              // Update the request with new token
              error.requestOptions.headers[ApiConstants.authorization] =
                  '${ApiConstants.bearer} $newAccessToken';

              // Retry the original request
              final opts = Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
              );

              final response = await _dio.request(
                error.requestOptions.path,
                options: opts,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );

              return handler.resolve(response);
            } catch (e) {
              // Refresh failed - clear tokens and return original error
              return handler.next(_handleError(error));
            }
          }

          return handler.next(_handleError(error));
        },
      ),
    );
  }

  DioException _handleError(DioException error) {
    final responseData = error.response?.data;
    String message = 'An error occurred';
    
    if (responseData is Map<String, dynamic>) {
      // Extract error message from common API error format
      String? extractedMessage = responseData['message'] ?? 
                                 responseData['error'] ??
                                 responseData['detail'];
      
      if (extractedMessage != null) {
        message = extractedMessage;
      }
      
      // Handle non_field_errors format
      if (responseData.containsKey('errors')) {
        final errors = responseData['errors'] as Map<String, dynamic>?;
        if (errors != null) {
          final nonFieldErrors = errors['non_field_errors'] as List?;
          if (nonFieldErrors != null && nonFieldErrors.isNotEmpty) {
            final firstError = nonFieldErrors.first;
            message = firstError is String ? firstError : firstError.toString();
          }
        }
      }
      
      // Convert to user-friendly message
      message = ErrorMessageHelper.getUserFriendlyMessage(message);
    }
    
    return DioException(
      requestOptions: error.requestOptions,
      response: error.response,
      type: error.type,
      message: message,
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(e.message ?? e);
      throw Exception(userFriendlyMessage);
    } on AppException catch (e) {
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(e.message);
      throw AppException(userFriendlyMessage, statusCode: e.statusCode);
    } catch (e) {
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(e);
      throw Exception(userFriendlyMessage);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      String errorMessage = e.message ?? 'An error occurred';
      
      // Handle specific DioException types
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Connection timeout. Please check your internet connection and try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network settings.';
      } else if (e.type == DioExceptionType.badResponse && statusCode == null) {
        errorMessage = 'Server error. Please try again later.';
      }
      
      // Try to extract more detailed error message from response
      if (responseData is Map<String, dynamic>) {
        // Extract error message from common API error format
        String? extractedMessage = responseData['message'] ?? 
                                   responseData['error'] ?? 
                                   responseData['detail'];
        
        if (extractedMessage != null) {
          errorMessage = extractedMessage;
        }
        
        // Handle non_field_errors format
        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as Map<String, dynamic>?;
          if (errors != null) {
            final nonFieldErrors = errors['non_field_errors'] as List?;
            if (nonFieldErrors != null && nonFieldErrors.isNotEmpty) {
              final firstError = nonFieldErrors.first;
              errorMessage = firstError is String ? firstError : firstError.toString();
            } else {
              // Handle field-specific errors
              final fieldErrors = errors.entries
                  .where((e) => e.key != 'non_field_errors')
                  .map((e) {
                    final value = e.value;
                    if (value is List && value.isNotEmpty) {
                      return '${e.key}: ${value.first}';
                    }
                    return '${e.key}: $value';
                  })
                  .toList();
              if (fieldErrors.isNotEmpty && extractedMessage == null) {
                errorMessage = fieldErrors.join(', ');
              }
            }
          }
        }
      } else if (responseData is String) {
        errorMessage = responseData;
      }
      
      // For validation errors (400, 422), preserve the original error message
      // without converting it to generic messages, as these are usually user-friendly
      if (statusCode == 400 || statusCode == 422) {
        // Always preserve the original error message for validation errors
        // These are typically user-friendly messages from the API
        throw Exception(errorMessage);
      }
      
      // Build technical error message for parsing
      final technicalMessage = statusCode != null 
          ? 'HTTP $statusCode: $errorMessage'
          : errorMessage;
      
      // Convert to user-friendly message
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(technicalMessage);
      
      throw Exception(userFriendlyMessage);
    } on AppException catch (e) {
      // Convert AppException messages to user-friendly format
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(e.message);
      throw AppException(userFriendlyMessage, statusCode: e.statusCode);
    } catch (e) {
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(e);
      throw Exception(userFriendlyMessage);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(e.message ?? e);
      throw Exception(userFriendlyMessage);
    } on AppException catch (e) {
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(e.message);
      throw AppException(userFriendlyMessage, statusCode: e.statusCode);
    } catch (e) {
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(e);
      throw Exception(userFriendlyMessage);
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(e.message ?? e);
      throw Exception(userFriendlyMessage);
    } on AppException catch (e) {
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(e.message);
      throw AppException(userFriendlyMessage, statusCode: e.statusCode);
    } catch (e) {
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(e);
      throw Exception(userFriendlyMessage);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(e.message ?? e);
      throw Exception(userFriendlyMessage);
    } on AppException catch (e) {
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(e.message);
      throw AppException(userFriendlyMessage, statusCode: e.statusCode);
    } catch (e) {
      final userFriendlyMessage = ErrorMessageHelper.getUserFriendlyMessage(e);
      throw Exception(userFriendlyMessage);
    }
  }
}
