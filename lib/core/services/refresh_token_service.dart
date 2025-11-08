import 'dart:async';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../../config/env.dart';
import 'token_service.dart';

class RefreshTokenService {
  static bool _isRefreshing = false;
  static final List<_PendingRequest> _pendingRequests = [];

  /// Refresh the access token using the refresh token
  static Future<Map<String, String>> refreshToken() async {
    final refreshToken = await TokenService.getRefreshToken();
    
    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception('No refresh token available');
    }

    try {
      // Create a temporary Dio instance without auth interceptor to avoid recursion
      final dio = Dio(
        BaseOptions(
          baseUrl: Env.apiBaseUrl,
          headers: {'Content-Type': ApiConstants.contentType},
        ),
      );

      final response = await dio.post(
        ApiConstants.refreshToken,
        data: {
          'refresh': refreshToken,
        },
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final accessToken = responseData['access'] as String?;
        final newRefreshToken = responseData['refresh'] as String?;

        if (accessToken == null) {
          throw Exception('Failed to refresh token: No access token in response');
        }

        // Save new tokens
        await TokenService.setAccessToken(accessToken);
        if (newRefreshToken != null) {
          await TokenService.setRefreshToken(newRefreshToken);
        }

        return {
          'access': accessToken,
          'refresh': newRefreshToken ?? refreshToken,
        };
      }

      throw Exception('Invalid response format');
    } catch (e) {
      // Clear tokens on refresh failure
      await TokenService.clearTokens();
      throw Exception('Failed to refresh token: ${e.toString()}');
    }
  }

  /// Handle token refresh with queue management to prevent multiple simultaneous refreshes
  static Future<String> refreshTokenWithQueue() async {
    // If already refreshing, wait for the current refresh to complete
    if (_isRefreshing) {
      final completer = Completer<String>();
      _pendingRequests.add(_PendingRequest(completer));
      return completer.future;
    }

    _isRefreshing = true;

    try {
      final tokens = await refreshToken();
      final accessToken = tokens['access']!;

      // Resolve all pending requests
      for (final pendingRequest in _pendingRequests) {
        pendingRequest.completer.complete(accessToken);
      }
      _pendingRequests.clear();

      return accessToken;
    } catch (e) {
      // Reject all pending requests
      for (final pendingRequest in _pendingRequests) {
        pendingRequest.completer.completeError(e);
      }
      _pendingRequests.clear();
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }
}

class _PendingRequest {
  final Completer<String> completer;

  _PendingRequest(this.completer);
}

