import '../entities/user.dart';
import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  });
  Future<void> logout();
  Future<AuthTokens?> getStoredTokens();
  Future<User?> getStoredUser();
  Future<bool> isAuthenticated();
}

