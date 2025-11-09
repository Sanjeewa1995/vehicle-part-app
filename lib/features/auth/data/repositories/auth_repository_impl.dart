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
import '../models/logout_request.dart';
import '../models/user_model.dart';
import '../../../../core/services/token_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await remoteDataSource.login(request);
      if (response.success) {
        // Save tokens
        await localDataSource.saveTokens(response.data.tokens);

        // Save user
        final userJson = jsonEncode(response.data.user.toJson());
        await localDataSource.saveUser(userJson);

        return response.data.user;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Login failed: ${e.toString()}');
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
        throw Exception(response.message);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> forgotPassword(String email) async {
    try {
      final request = PasswordResetRequest(email: email);
      final response = await remoteDataSource.forgotPassword(request);
      return response.success;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> verifyOTP(String email, String otp) async {
    try {
      final request = VerifyOTPRequest(email: email, otp: otp);
      final response = await remoteDataSource.verifyOTP(request);
      return response.success;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('OTP verification failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    try {
      final request = ResetPasswordRequest(
        email: email,
        otp: otp,
        newPassword: newPassword,
        newPasswordConfirm: newPasswordConfirm,
      );
      final response = await remoteDataSource.resetPassword(request);
      return response.success;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Password reset failed: ${e.toString()}');
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
      throw Exception('Profile update failed: ${e.toString()}');
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
      throw Exception('Password change failed: ${e.toString()}');
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
