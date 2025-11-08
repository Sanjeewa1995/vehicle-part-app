import '../entities/user.dart';
import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<AuthTokens?> getStoredTokens();
  Future<User?> getStoredUser();
  Future<bool> isAuthenticated();
}

