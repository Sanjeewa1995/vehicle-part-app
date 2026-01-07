import 'dart:convert';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/password_reset_request.dart';
import '../models/verify_otp_request.dart';
import '../models/reset_password_request.dart';
import '../models/update_profile_request.dart';
import '../models/change_password_request.dart';
import '../models/logout_request.dart';
import '../models/delete_account_request.dart';
import '../models/user_model.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/utils/error_message_helper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login(String phone, String password) async {
    try {
      final request = LoginRequest(phone: phone, password: password);
      final response = await remoteDataSource.login(request);
      if (response.success) {
        // Save tokens
        await localDataSource.saveTokens(response.data.tokens);

        // Save user
        final userJson = jsonEncode(response.data.user.toJson());
        await localDataSource.saveUser(userJson);

        return response.data.user;
      } else {
        throw Exception(ErrorMessageHelper.getUserFriendlyMessage(response.message));
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(ErrorMessageHelper.getUserFriendlyMessage('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        password: password,
        passwordConfirm: confirmPassword,
      );
      final response = await remoteDataSource.register(request);
      if (response.success) {
        // Save tokens
        await localDataSource.saveTokens(response.data.tokens);

        // Save user
        final userJson = jsonEncode(response.data.user.toJson());
        await localDataSource.saveUser(userJson);

        return response.data.user;
      } else {
        throw Exception(ErrorMessageHelper.getUserFriendlyMessage(response.message));
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(ErrorMessageHelper.getUserFriendlyMessage('Registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<bool> forgotPassword(String phone) async {
    try {
      final request = PasswordResetRequest(phone: phone);
      final response = await remoteDataSource.forgotPassword(request);
      if (response.success) {
        return true;
      } else {
        throw Exception(ErrorMessageHelper.getUserFriendlyMessage(response.message));
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(ErrorMessageHelper.getUserFriendlyMessage('Password reset failed: ${e.toString()}'));
    }
  }

  @override
  Future<bool> verifyOTP(String phone, String otp) async {
    try {
      final request = VerifyOTPRequest(phone: phone, otp: otp);
      final response = await remoteDataSource.verifyOTP(request);
      if (response.success) {
        return true;
      } else {
        throw Exception(ErrorMessageHelper.getUserFriendlyMessage(response.message));
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(ErrorMessageHelper.getUserFriendlyMessage('OTP verification failed: ${e.toString()}'));
    }
  }

  @override
  Future<bool> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    try {
      final request = ResetPasswordRequest(
        phone: phone,
        otp: otp,
        newPassword: newPassword,
        newPasswordConfirm: newPasswordConfirm,
      );
      final response = await remoteDataSource.resetPassword(request);
      if (response.success) {
        return true;
      } else {
        throw Exception(ErrorMessageHelper.getUserFriendlyMessage(response.message));
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(ErrorMessageHelper.getUserFriendlyMessage('Password reset failed: ${e.toString()}'));
    }
  }

  @override
  Future<User> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      final request = UpdateProfileRequest(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
      final response = await remoteDataSource.updateProfile(request);
      
      // Update stored user
      final userJson = jsonEncode(response.user.toJson());
      await localDataSource.saveUser(userJson);

      return response.user;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(ErrorMessageHelper.getUserFriendlyMessage('Profile update failed: ${e.toString()}'));
    }
  }

  @override
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    try {
      final request = ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirm: newPasswordConfirm,
      );
      final response = await remoteDataSource.changePassword(request);
      return response.message.isNotEmpty;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(ErrorMessageHelper.getUserFriendlyMessage('Password change failed: ${e.toString()}'));
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Get refresh token before clearing
      final refreshToken = await TokenService.getRefreshToken();
      if (refreshToken != null) {
        final request = LogoutRequest(refresh: refreshToken);
        await remoteDataSource.logout(request);
      }
    } catch (e) {
      // Even if API call fails, clear local data
    } finally {
      await localDataSource.clearTokens();
      await localDataSource.clearUser();
    }
  }

  @override
  Future<bool> deleteAccount(String password) async {
    try {
      // Get refresh token for the request
      final refreshToken = await TokenService.getRefreshToken();
      final request = DeleteAccountRequest(
        password: password,
        refresh: refreshToken,
      );
      await remoteDataSource.deleteAccount(request);
      
      // Clear local data after successful deletion
      await localDataSource.clearTokens();
      await localDataSource.clearUser();
      
      return true;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(ErrorMessageHelper.getUserFriendlyMessage('Account deletion failed: ${e.toString()}'));
    }
  }

  @override
  Future<AuthTokens?> getStoredTokens() async {
    return await localDataSource.getTokens();
  }

  @override
  Future<User?> getStoredUser() async {
    final userJson = await localDataSource.getUser();
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  @override
  Future<bool> isAuthenticated() async {
    final tokens = await getStoredTokens();
    return tokens != null;
  }
}
