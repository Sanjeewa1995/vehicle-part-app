import 'dart:convert';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../models/login_request.dart';
import '../models/user_model.dart';

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
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
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
