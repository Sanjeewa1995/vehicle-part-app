import 'package:dio/dio.dart';
import '../../config/env.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';
import '../services/refresh_token_service.dart';

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
    if (responseData is Map<String, dynamic>) {
      final message =
          responseData['message'] ??
          responseData['error'] ??
          'An error occurred';
      return DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        type: error.type,
        message: message,
      );
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException(
          'Connection timeout',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          throw AuthenticationException('Unauthorized', statusCode: statusCode);
        } else if (statusCode == 404) {
          throw NotFoundException('Resource not found', statusCode: statusCode);
        } else if (statusCode != null && statusCode >= 500) {
          throw ServerException('Server error', statusCode: statusCode);
        }
        throw ServerException(
          error.response?.data['message'] ?? 'An error occurred',
          statusCode: statusCode,
        );
      default:
        throw NetworkException(
          'Network error',
          statusCode: error.response?.statusCode,
        );
    }
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
      throw Exception(e.message);
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
      throw Exception(e.message);
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
      throw Exception(e.message);
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
        throw Exception(e.message);
    }
  }
}
