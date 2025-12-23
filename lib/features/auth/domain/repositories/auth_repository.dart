import '../entities/user.dart';
import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<User> login(String phone, String password);
  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  });
  Future<bool> forgotPassword(String phone);
  Future<bool> verifyOTP(String phone, String otp);
  Future<bool> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
    required String newPasswordConfirm,
  });
  Future<User> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
  });
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirm,
  });
  Future<void> logout();
  Future<bool> deleteAccount(String password);
  Future<AuthTokens?> getStoredTokens();
  Future<User?> getStoredUser();
  Future<bool> isAuthenticated();
}

