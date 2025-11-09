import 'package:dio/dio.dart';
import 'package:vehicle_part_app/core/network/api_client.dart';
import 'package:vehicle_part_app/core/constants/api_constants.dart';
import 'package:vehicle_part_app/core/error/exceptions.dart';
import 'package:vehicle_part_app/features/auth/data/models/login_request.dart';
import 'package:vehicle_part_app/features/auth/data/models/login_response.dart';
import 'package:vehicle_part_app/features/auth/data/models/register_request.dart';
import 'package:vehicle_part_app/features/auth/data/models/password_reset_request.dart';
import 'package:vehicle_part_app/features/auth/data/models/password_reset_response.dart';
import 'package:vehicle_part_app/features/auth/data/models/verify_otp_request.dart';
import 'package:vehicle_part_app/features/auth/data/models/verify_otp_response.dart';
import 'package:vehicle_part_app/features/auth/data/models/reset_password_request.dart';
import 'package:vehicle_part_app/features/auth/data/models/reset_password_response.dart';
import 'package:vehicle_part_app/features/auth/data/models/update_profile_request.dart';
import 'package:vehicle_part_app/features/auth/data/models/update_profile_response.dart';
import 'package:vehicle_part_app/features/auth/data/models/change_password_request.dart';
import 'package:vehicle_part_app/features/auth/data/models/change_password_response.dart';
import 'package:vehicle_part_app/features/auth/data/models/logout_request.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<LoginResponse> register(RegisterRequest request);
  Future<PasswordResetResponse> forgotPassword(PasswordResetRequest request);
  Future<VerifyOTPResponse> verifyOTP(VerifyOTPRequest request);
  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequest request);
  Future<UpdateProfileResponse> updateProfile(UpdateProfileRequest request);
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request);
  Future<void> logout(LogoutRequest request);
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
  Future<PasswordResetResponse> forgotPassword(PasswordResetRequest request) async {
    try {
      final response = await apiClient.post(
        ApiConstants.passwordReset,
        data: request.toJson(),
      );
      return PasswordResetResponse.fromJson(response.data);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<VerifyOTPResponse> verifyOTP(VerifyOTPRequest request) async {
    try {
      final response = await apiClient.post(
        ApiConstants.verifyOTP,
        data: request.toJson(),
      );
      return VerifyOTPResponse.fromJson(response.data);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await apiClient.post(
        ApiConstants.passwordResetConfirm,
        data: request.toJson(),
      );
      return ResetPasswordResponse.fromJson(response.data);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UpdateProfileResponse> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await apiClient.put(
        ApiConstants.updateProfile,
        data: request.toJson(),
      );
      return UpdateProfileResponse.fromJson(response.data);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await apiClient.post(
        ApiConstants.changePassword,
        data: request.toJson(),
      );
      return ChangePasswordResponse.fromJson(response.data);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> logout(LogoutRequest request) async {
    try {
      await apiClient.post(
        ApiConstants.logout,
        data: request.toJson(),
      );
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
