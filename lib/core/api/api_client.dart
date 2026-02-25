import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lost_n_found/core/api/api_endpoints.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  late final Dio _dio;
  final _tokenManager = _TokenManager();

  // Callback for handling logout/session expiry
  static void Function()? onTokenExpired;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectionTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Language': 'en',
        },
        // Validate status codes to handle errors properly
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // IMPORTANT: Order of interceptors matters!
    // 1. Auth Interceptor (adds token to requests and handles refresh)
    _dio.interceptors.add(_AuthInterceptor(_dio, _tokenManager));

    // 2. Retry Interceptor (retries on network failures)
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
        retryEvaluator: (error, attempt) {
          // Retry on connection errors and timeouts, not on 4xx/5xx
          return error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError;
        },
      ),
    );

    // 3. Logger Interceptor (should be last to log final request/response)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  Dio get dio => _dio;

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Multipart request for file uploads
  Future<Response> uploadFile(
    String path, {
    required FormData formData,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    return _dio.post(
      path,
      data: formData,
      options: options,
      onSendProgress: onSendProgress,
    );
  }

  // PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Download file with progress
  Future<Response> downloadFile(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    return _dio.download(
      urlPath,
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }

  /// Save authentication tokens
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _tokenManager.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  /// Get current access token
  Future<String?> getAccessToken() => _tokenManager.getAccessToken();

  /// Get current refresh token
  Future<String?> getRefreshToken() => _tokenManager.getRefreshToken();

  /// Clear all stored tokens (logout)
  Future<void> clearTokens() => _tokenManager.clearTokens();

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _tokenManager.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Set custom header for all requests
  void setHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  /// Remove custom header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  /// Set language header
  void setLanguage(String languageCode) {
    setHeader('Accept-Language', languageCode);
  }
}

// Token Manager - Handles token storage and retrieval
class _TokenManager {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
}

// Auth Interceptor - Handles authentication and token refresh
class _AuthInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final _TokenManager _tokenManager;

  // Lock to prevent multiple simultaneous refresh requests
  Completer<bool>? _refreshCompleter;

  // Public endpoints that don't require authentication
  static final _publicEndpoints = [
    ApiEndpoints.batches,
    ApiEndpoints.categories,
    ApiEndpoints.studentLogin,
    ApiEndpoints.studentRegister,
  ];

  _AuthInterceptor(this._dio, this._tokenManager);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Check if this is a public endpoint
      final isPublicEndpoint = _isPublicEndpoint(options);

      if (!isPublicEndpoint) {
        // Add access token to request
        final accessToken = await _tokenManager.getAccessToken();
        if (accessToken != null && accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
      }

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Failed to prepare request: $e',
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - Token expired
    if (err.response?.statusCode == 401) {
      final options = err.requestOptions;

      // Don't attempt refresh for auth endpoints
      if (options.path == ApiEndpoints.studentLogin ||
          options.path == ApiEndpoints.studentRegister) {
        return handler.next(err);
      }

      try {
        // Attempt to refresh token
        final refreshed = await _refreshToken();

        if (refreshed) {
          // Retry the original request with new token
          final accessToken = await _tokenManager.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          // Create a new Dio instance to avoid interceptor recursion
          final response = await _dio.fetch(options);
          return handler.resolve(response);
        } else {
          // Refresh failed, clear tokens and trigger logout callback
          await _tokenManager.clearTokens();
          ApiClient.onTokenExpired?.call();
          return handler.next(err);
        }
      } catch (e) {
        // Refresh failed, clear tokens and trigger logout callback
        await _tokenManager.clearTokens();
        ApiClient.onTokenExpired?.call();
        return handler.next(err);
      }
    }

    // Handle other errors
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Check if response contains new tokens (e.g., after login)
    try {
      if (response.requestOptions.path == ApiEndpoints.studentLogin &&
          response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final accessToken = data['accessToken'] ?? data['token'];
          final refreshToken = data['refreshToken'];

          if (accessToken != null) {
            await _tokenManager.saveTokens(
              accessToken: accessToken.toString(),
              refreshToken: refreshToken?.toString(),
            );
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving tokens from response: $e');
      }
    }

    handler.next(response);
  }

  /// Refresh the access token using refresh token
  Future<bool> _refreshToken() async {
    // If a refresh is already in progress, wait for it
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = await _tokenManager.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        _refreshCompleter!.complete(false);
        _refreshCompleter = null;
        return false;
      }

      // Make refresh token request
      // TODO: Update this endpoint based on your API
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['accessToken'] ?? data['token'];
        final newRefreshToken = data['refreshToken'];

        if (newAccessToken != null) {
          await _tokenManager.saveTokens(
            accessToken: newAccessToken.toString(),
            refreshToken: newRefreshToken?.toString() ?? refreshToken,
          );

          _refreshCompleter!.complete(true);
          _refreshCompleter = null;
          return true;
        }
      }

      _refreshCompleter!.complete(false);
      _refreshCompleter = null;
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Token refresh failed: $e');
      }
      _refreshCompleter!.complete(false);
      _refreshCompleter = null;
      return false;
    }
  }

  /// Check if the endpoint is public (doesn't require authentication)
  bool _isPublicEndpoint(RequestOptions options) {
    // Check if it's a GET request to public endpoints
    final isPublicGet =
        options.method == 'GET' &&
        _publicEndpoints.any((endpoint) => options.path.startsWith(endpoint));

    // Check if it's an auth endpoint
    final isAuthEndpoint =
        options.path == ApiEndpoints.studentLogin ||
        options.path == ApiEndpoints.studentRegister;

    return isPublicGet || isAuthEndpoint;
  }
}
