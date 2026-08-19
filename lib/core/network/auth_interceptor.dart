import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../navigation/navigation_service.dart';
import '../storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService storage;

  AuthInterceptor(this.storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  // Static variables to hold the active refresh future and redirect state
  static Future<String?>? _refreshFuture;
  static bool _isRedirecting = false;

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode == 401) {
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken != null) {
        final newAccessToken = await _getNewToken(refreshToken);
        if (newAccessToken != null) {
          final requestOptions = response.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          try {
            final dio = Dio();
            final retriedResponse = await dio.fetch(requestOptions);
            return handler.resolve(retriedResponse);
          } catch (e) {
            return handler.reject(
              DioException(requestOptions: requestOptions, error: e),
            );
          }
        } else {
          await storage.clearToken();
          await storage.clearRefreshToken();
          _redirectToLogin();
        }
      } else {
        await storage.clearToken();
        _redirectToLogin();
      }
    }

    final newToken = response.headers['authorization']?.first;
    if (newToken != null) {
      await storage.saveToken(newToken.replaceFirst('Bearer ', ''));
    }

    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken != null) {
        final newAccessToken = await _getNewToken(refreshToken);
        if (newAccessToken != null) {
          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          try {
            final dio = Dio();
            final response = await dio.fetch(requestOptions);
            return handler.resolve(response);
          } catch (e) {
            return handler.next(
              DioException(requestOptions: requestOptions, error: e),
            );
          }
        } else {
          // Token refresh failed completely. Clear all session states.
          await storage.clearToken();
          await storage.clearRefreshToken();
          _redirectToLogin();
        }
      } else {
        // No refresh token available. Clear access token and redirect.
        await storage.clearToken();
        _redirectToLogin();
      }
    }
    super.onError(err, handler);
  }

  void _redirectToLogin() {
    if (!_isRedirecting) {
      _isRedirecting = true;
      final context = NavigationService.navigatorKey.currentContext;

      if (context != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              title: Text(
                "Session Expired",
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              content: Text(
                "Your session has expired. Please log in again.",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    NavigationService.navigatorKey.currentState
                        ?.pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => SignInScreen()),
                          (route) => false,
                        )
                        .then((_) {
                          _isRedirecting = false;
                        });
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        // Fallback redirection if context is not available
        NavigationService.navigatorKey.currentState
            ?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => SignInScreen()),
              (route) => false,
            )
            .then((_) {
              _isRedirecting = false;
            });
      }
    }
  }

  Future<String?> _getNewToken(String refreshToken) async {
    if (_refreshFuture != null) {
      return _refreshFuture;
    }

    _refreshFuture = _performTokenRefresh(refreshToken);

    try {
      final newToken = await _refreshFuture;
      return newToken;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<String?> _performTokenRefresh(String refreshToken) async {
    try {
      final tempDio = Dio(
        BaseOptions(
          baseUrl: "https://api.vetnow.app/",
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      final response = await tempDio.post(
        "/api/v1/auth/token/refresh",
        data: {"refreshToken": refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final meta = data['meta'] as Map<String, dynamic>?;
        if (meta != null && meta['token'] != null) {
          final tokenData = meta['token'] as Map<String, dynamic>;
          final newAccessToken = tokenData['accessToken'] as String?;
          final newRefreshToken = tokenData['refreshToken'] as String?;

          if (newAccessToken != null) {
            await storage.saveToken(newAccessToken);
            if (newRefreshToken != null) {
              await storage.saveRefreshToken(newRefreshToken);
            }
            return newAccessToken;
          }
        }
      }
    } catch (e) {
      print("Failed to refresh token: $e");
    }
    return null;
  }
}
