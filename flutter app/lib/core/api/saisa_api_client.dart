import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../errors/api_exception.dart';
import '../storage/token_storage.dart';

/// Singleton Dio-based HTTP client for SAISA backend.
///
/// Responsibilities:
///   - Attach JWT to every request
///   - Attach X-Tenant-Id (defense in depth; backend trusts JWT, but this helps logs)
///   - On 401: attempt refresh once, retry original request
///   - On refresh failure: clear session (caller observes `onSessionExpired`)
///   - Convert errors to ApiException
class SaisaApiClient {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  /// Callback invoked when session dies (401 and refresh failed).
  /// The auth provider sets this to trigger logout in the UI.
  VoidCallback? onSessionExpired;

  bool _isRefreshing = false;
  final List<Completer<void>> _refreshWaiters = [];

  SaisaApiClient({required TokenStorage tokenStorage, Dio? dio})
      : _tokenStorage = tokenStorage,
        _dio = dio ?? Dio() {
    _dio.options
      ..baseUrl = '${AppConfig.baseUrl}/api/${AppConfig.apiVersion}'
      ..connectTimeout = AppConfig.connectTimeout
      ..receiveTimeout = AppConfig.receiveTimeout
      ..headers['Content-Type'] = 'application/json'
      ..validateStatus = (status) => status != null && status < 500;

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    ));
  }

  Future<void> _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.getAccessToken();
    final tenantId = await _tokenStorage.getTenantId();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    if (tenantId != null) {
      options.headers['X-Tenant-Id'] = tenantId.toString();
    }

    if (AppConfig.isDebug) {
      debugPrint('→ ${options.method} ${options.uri}');
    }

    handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    // Treat 4xx (< 500) as exceptions too
    final status = response.statusCode ?? 0;
    if (status >= 400) {
      final body = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: ApiException.fromResponse(body, status),
        ),
      );
      return;
    }
    handler.next(response);
  }

  Future<void> _onError(DioException error, ErrorInterceptorHandler handler) async {
    final apiException = _toApiException(error);

    // Attempt refresh on 401 (once)
    if (apiException.isUnauthorized &&
        error.requestOptions.path != '/auth/refresh' &&
        error.requestOptions.path != '/auth/login') {
      try {
        await _refreshOrWait();
        // Retry original request
        final retried = await _dio.fetch(error.requestOptions);
        handler.resolve(retried);
        return;
      } catch (_) {
        // Refresh failed → expire session
        await _tokenStorage.clear();
        onSessionExpired?.call();
        handler.reject(DioException(
          requestOptions: error.requestOptions,
          error: ApiException.unauthorized(),
        ));
        return;
      }
    }

    handler.reject(DioException(
      requestOptions: error.requestOptions,
      error: apiException,
    ));
  }

  Future<void> _refreshOrWait() async {
    if (_isRefreshing) {
      final completer = Completer<void>();
      _refreshWaiters.add(completer);
      return completer.future;
    }

    _isRefreshing = true;
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) throw ApiException.unauthorized();

      // Bare request (no interceptors) to avoid recursion
      final bare = Dio(BaseOptions(
        baseUrl: _dio.options.baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
      ));
      final resp = await bare.post('/auth/refresh', data: {'refreshToken': refreshToken});

      final body = resp.data as Map<String, dynamic>;
      await _tokenStorage.saveSession(
        accessToken: body['accessToken'] as String,
        refreshToken: body['refreshToken'] as String,
        userId: (body['userId'] as num).toInt(),
        tenantId: (body['tenantId'] as num).toInt(),
        tenantCode: body['tenantCode'] as String? ?? '',
        roles: (body['roles'] as List?)?.cast<String>() ?? const [],
        fullName: body['fullName'] as String?,
      );

      for (final w in _refreshWaiters) {
        w.complete();
      }
    } catch (e) {
      for (final w in _refreshWaiters) {
        w.completeError(e);
      }
      rethrow;
    } finally {
      _refreshWaiters.clear();
      _isRefreshing = false;
    }
  }

  ApiException _toApiException(DioException error) {
    if (error.error is ApiException) return error.error as ApiException;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return ApiException.network();
    }

    final response = error.response;
    if (response != null && response.data is Map<String, dynamic>) {
      return ApiException.fromResponse(
        response.data as Map<String, dynamic>,
        response.statusCode,
      );
    }

    return ApiException(
      code: 'HTTP_ERROR',
      message: error.message ?? 'Request failed',
      statusCode: response?.statusCode,
    );
  }

  // ============ Public typed methods ============

  Future<T> get<T>(String path, {Map<String, dynamic>? query}) async {
    final r = await _dio.get(path, queryParameters: query);
    return r.data as T;
  }

  Future<T> post<T>(String path, {dynamic data}) async {
    final r = await _dio.post(path, data: data);
    return r.data as T;
  }

  Future<T> put<T>(String path, {dynamic data}) async {
    final r = await _dio.put(path, data: data);
    return r.data as T;
  }

  Future<T> delete<T>(String path, {Map<String, dynamic>? query}) async {
    final r = await _dio.delete(path, queryParameters: query);
    return r.data as T;
  }

  Dio get raw => _dio;
}
