import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_part_app/features/auth/domain/entities/auth_tokens.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens(AuthTokens tokens);
  Future<AuthTokens?> getTokens();
  Future<void> clearTokens();
  Future<void> saveUser(String userJson);
  Future<String?> getUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';

  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveTokens(AuthTokens tokens) async {
    await sharedPreferences.setString(_accessTokenKey, tokens.accessToken);
    await sharedPreferences.setString(_refreshTokenKey, tokens.refreshToken);
  }

  @override
  Future<AuthTokens?> getTokens() async {
    final accessToken = sharedPreferences.getString(_accessTokenKey);
    final refreshToken = sharedPreferences.getString(_refreshTokenKey);

    if (accessToken != null && refreshToken != null) {
      return AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
    return null;
  }

  @override
  Future<void> clearTokens() async {
    await sharedPreferences.remove(_accessTokenKey);
    await sharedPreferences.remove(_refreshTokenKey);
  }

  @override
  Future<void> saveUser(String userJson) async {
    await sharedPreferences.setString(_userKey, userJson);
  }

  @override
  Future<String?> getUser() async {
    return sharedPreferences.getString(_userKey);
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(_userKey);
  }
}

