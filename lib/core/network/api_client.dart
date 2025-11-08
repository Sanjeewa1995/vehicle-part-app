import 'package:dio/dio.dart';
import '../../config/env.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';

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
        onError: (error, handler) {
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
