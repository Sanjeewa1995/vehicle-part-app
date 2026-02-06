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
import 'package:vehicle_part_app/features/auth/data/models/user_model.dart';
import 'package:vehicle_part_app/features/auth/data/models/change_password_request.dart';
import 'package:vehicle_part_app/features/auth/data/models/change_password_response.dart';
import 'package:vehicle_part_app/features/auth/data/models/logout_request.dart';
import 'package:vehicle_part_app/features/auth/data/models/delete_account_request.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<LoginResponse> register(RegisterRequest request);
  Future<PasswordResetResponse> forgotPassword(PasswordResetRequest request);
  Future<VerifyOTPResponse> verifyOTP(VerifyOTPRequest request);
  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequest request);
  Future<UpdateProfileResponse> updateProfile(UpdateProfileRequest request);
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request);
  Future<void> logout(LogoutRequest request);
  Future<void> deleteAccount(DeleteAccountRequest request);
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
                if (fieldErrors.isNotEmpty) {
                  errorMessage = fieldErrors.join(', ');
                }
              }
            }
          }

          if (errorMessage == null || errorMessage.isEmpty) {
            errorMessage = responseData['error'] as String?;
          }

          throw Exception(errorMessage ?? 'Invalid input. Please check your information and try again.');
        }
      }

      return ResetPasswordResponse.fromJson(responseData);
    } on DioException catch (e) {
      // Extract actual error message from response data before it gets converted
      final responseData = e.response?.data;
      String? errorMessage;
      
      if (responseData is Map<String, dynamic>) {
        // Try to extract the actual error message
        errorMessage = responseData['message'] as String?;
        
        if (errorMessage == null || errorMessage.isEmpty) {
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
              if (fieldErrors.isNotEmpty) {
                errorMessage = fieldErrors.join(', ');
              }
            }
          }
        }
        
        if (errorMessage == null || errorMessage.isEmpty) {
          errorMessage = responseData['error'] as String?;
        }
        
        if (errorMessage == null || errorMessage.isEmpty) {
          errorMessage = responseData['detail'] as String?;
        }
      }
      
      // If we extracted a specific error message, throw it directly without conversion
      if (errorMessage != null && errorMessage.isNotEmpty) {
        throw Exception(errorMessage);
      }
      
      // Fallback to original exception message
      throw Exception(e.message ?? 'An error occurred');
    } catch (e) {
      // apiClient.post converts DioException to Exception for 400/422 errors
      // and preserves the original error message, so we can just rethrow it
      if (e is Exception) {
        rethrow;
      }
      throw Exception(e.toString());
    }
  }

  @override
  Future<UpdateProfileResponse> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await apiClient.put(
        ApiConstants.updateProfile,
        data: request.toJson(),
      );
      
      // Handle null or different response formats
      if (response.data == null) {
        throw Exception('Profile update failed: Empty response from server');
      }
      
      // Check if response.data is already a Map
      if (response.data is! Map<String, dynamic>) {
        throw Exception('Profile update failed: Invalid response format');
      }
      
      final responseData = response.data as Map<String, dynamic>;
      
      // Handle different response structures
      // If response has 'data' field, use it; otherwise use the response directly
      if (responseData.containsKey('data') && responseData['data'] != null) {
        final data = responseData['data'] as Map<String, dynamic>;
        // If data contains user, create response with it
        if (data.containsKey('user')) {
          return UpdateProfileResponse(
            message: responseData['message'] as String? ?? 'Profile updated successfully',
            user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
          );
        }
      }
      
      // If response has 'user' directly, use it
      if (responseData.containsKey('user')) {
        return UpdateProfileResponse(
          message: responseData['message'] as String? ?? 'Profile updated successfully',
          user: UserModel.fromJson(responseData['user'] as Map<String, dynamic>),
        );
      }
      
      // Try to parse as UpdateProfileResponse directly
      return UpdateProfileResponse.fromJson(responseData);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Profile update failed: ${e.toString()}');
    }
  }

  @override
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await apiClient.post(
        ApiConstants.changePassword,
        data: request.toJson(),
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
                if (fieldErrors.isNotEmpty) {
                  errorMessage = fieldErrors.join(', ');
                }
              }
            }
          }

          if (errorMessage == null || errorMessage.isEmpty) {
            errorMessage = responseData['error'] as String?;
          }

          throw Exception(errorMessage ?? 'Invalid input. Please check your information and try again.');
        }
      }

      return ChangePasswordResponse.fromJson(responseData);
    } on DioException catch (e) {
      // Extract actual error message from response data before it gets converted
      final responseData = e.response?.data;
      String? errorMessage;
      
      if (responseData is Map<String, dynamic>) {
        // Try to extract the actual error message
        errorMessage = responseData['message'] as String?;
        
        if (errorMessage == null || errorMessage.isEmpty) {
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
              if (fieldErrors.isNotEmpty) {
                errorMessage = fieldErrors.join(', ');
              }
            }
          }
        }
        
        if (errorMessage == null || errorMessage.isEmpty) {
          errorMessage = responseData['error'] as String?;
        }
        
        if (errorMessage == null || errorMessage.isEmpty) {
          errorMessage = responseData['detail'] as String?;
        }
      }
      
      // If we extracted a specific error message, throw it directly without conversion
      if (errorMessage != null && errorMessage.isNotEmpty) {
        throw Exception(errorMessage);
      }
      
      // Fallback to original exception message
      throw Exception(e.message ?? 'An error occurred');
    } on AppException {
      rethrow;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(e.toString());
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

  @override
  Future<void> deleteAccount(DeleteAccountRequest request) async {
    try {
      await apiClient.delete(
        ApiConstants.deleteAccount,
        data: request.toJson(),
      );
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
