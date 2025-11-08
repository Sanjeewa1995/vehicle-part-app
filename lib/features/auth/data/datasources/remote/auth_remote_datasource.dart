import 'package:dio/dio.dart';
import 'package:vehicle_part_app/core/network/api_client.dart';
import 'package:vehicle_part_app/core/constants/api_constants.dart';
import 'package:vehicle_part_app/core/error/exceptions.dart';
import 'package:vehicle_part_app/features/auth/data/models/login_request.dart';
import 'package:vehicle_part_app/features/auth/data/models/login_response.dart';
import 'package:vehicle_part_app/features/auth/data/models/register_request.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<LoginResponse> register(RegisterRequest request);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await apiClient.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<LoginResponse> register(RegisterRequest request) async {
    try {
      final response = await apiClient.post(
        ApiConstants.register,
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post(ApiConstants.logout);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
