import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../core/platform/secure_token_store.dart';
import '../../backup/domain/backup_error.dart';
import 'google_auth_service.dart';

GoogleAuthService createGoogleAuthService({
  SecureTokenStore? secureStorage,
  http.Client? httpClient,
}) =>
    GoogleAuthServiceIo(
      secureStorage: secureStorage,
      httpClient: httpClient,
    );

/// Desktop-specific implementation using local loopback HTTP server + PKCE.
class GoogleAuthServiceIo implements GoogleAuthService {
  static const String _kRefreshTokenKey = 'google_drive_refresh_token';
  static const String _kIdTokenKey = 'google_account_id_token';
  static const String _kEmailKey = 'google_account_email';
  static const String _kNameKey = 'google_account_name';

  final SecureTokenStore _secureStorage;
  final http.Client _httpClient;

  String? _cachedAccessToken;
  String? _cachedIdToken;
  DateTime? _accessTokenExpiry;

  GoogleAuthServiceIo({
    SecureTokenStore? secureStorage,
    http.Client? httpClient,
  })  : _secureStorage = secureStorage ?? SecureTokenStore.create(),
        _httpClient = httpClient ?? http.Client();

  @override
  Future<bool> isSignedIn() async {
    try {
      final token = await _secureStorage.read(key: _kRefreshTokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      debugPrint('[GoogleAuthServiceIo] Error checking sign-in status: $e');
      return false;
    }
  }

  @override
  Future<String?> getConnectedEmail() async {
    try {
      return await _secureStorage.read(key: _kEmailKey);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getConnectedName() async {
    try {
      return await _secureStorage.read(key: _kNameKey);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getIdToken() async {
    if (_cachedIdToken != null) return _cachedIdToken;
    return await _secureStorage.read(key: _kIdTokenKey);
  }

  String _resolveClientId(String? overrideId) {
    final id = overrideId?.trim() ?? GoogleAuthService.defaultClientId.trim();
    if (id.isEmpty) {
      throw const OAuthConfigurationException(
        'Google Client ID is missing. Supply via --dart-define=GOOGLE_CLIENT_ID_DESKTOP or Settings.',
      );
    }
    return id;
  }

  String _resolveClientSecret(String? overrideSecret) {
    return overrideSecret?.trim() ?? GoogleAuthService.defaultClientSecret.trim();
  }

  @override
  Future<GoogleUserInfo> signIn({
    String? clientId,
    String? clientSecret,
  }) async {
    final effectiveClientId = _resolveClientId(clientId);
    final effectiveClientSecret = _resolveClientSecret(clientSecret);

    HttpServer? server;
    try {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final port = server.port;
      final redirectUri = 'http://127.0.0.1:$port';

      final codeVerifier = GoogleAuthService.generateCodeVerifier(64);
      final codeChallenge = GoogleAuthService.generateCodeChallenge(codeVerifier);

      final queryParams = {
        'client_id': effectiveClientId,
        'redirect_uri': redirectUri,
        'response_type': 'code',
        'scope': GoogleAuthService.requiredScopes.join(' '),
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256',
        'access_type': 'offline',
        'prompt': 'consent',
      };

      final authUrl = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', queryParams);
      debugPrint('[GoogleAuthServiceIo] Launching OAuth browser: $authUrl');

      final launched = await launchUrl(authUrl, mode: LaunchMode.externalApplication);
      if (!launched) {
        throw const NetworkException('Failed to launch system browser for authorization.');
      }

      final authCode = await _listenForAuthCode(server);

      final tokenData = await _exchangeCodeForTokens(
        authCode: authCode,
        codeVerifier: codeVerifier,
        clientId: effectiveClientId,
        clientSecret: effectiveClientSecret,
        redirectUri: redirectUri,
      );

      final refreshToken = tokenData['refresh_token'] as String?;
      final accessToken = tokenData['access_token'] as String;
      final idToken = tokenData['id_token'] as String?;
      final expiresIn = tokenData['expires_in'] as int? ?? 3600;

      if (refreshToken == null) {
        final existingRefresh = await _secureStorage.read(key: _kRefreshTokenKey);
        if (existingRefresh == null) {
          throw const OAuthConfigurationException(
            'Google did not return a refresh_token. Revoke previous permissions at myaccount.google.com/permissions and retry.',
          );
        }
      } else {
        await _secureStorage.write(key: _kRefreshTokenKey, value: refreshToken);
      }

      if (idToken != null) {
        _cachedIdToken = idToken;
        await _secureStorage.write(key: _kIdTokenKey, value: idToken);
      }

      _cachedAccessToken = accessToken;
      _accessTokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));

      final userInfo = await _fetchUserInfo(accessToken);
      await _secureStorage.write(key: _kEmailKey, value: userInfo.email);
      await _secureStorage.write(key: _kNameKey, value: userInfo.name);

      debugPrint('[GoogleAuthServiceIo] Connected successfully as ${userInfo.email}');
      return userInfo;
    } finally {
      await server?.close(force: true);
    }
  }

  Future<String> _listenForAuthCode(HttpServer server) async {
    final completer = Completer<String>();

    final sub = server.timeout(const Duration(minutes: 5)).listen((HttpRequest request) async {
      try {
        final uri = request.uri;
        final error = uri.queryParameters['error'];
        final code = uri.queryParameters['code'];

        if (error != null) {
          request.response
            ..statusCode = HttpStatus.badRequest
            ..headers.contentType = ContentType.html
            ..write('<html><body><h3>Sign-in cancelled or failed ($error). You can close this window.</h3></body></html>');
          await request.response.close();

          if (error == 'access_denied') {
            completer.completeError(const UserCancelledException('Google sign-in was cancelled.'));
          } else {
            completer.completeError(OAuthConfigurationException('OAuth error from Google: $error'));
          }
          return;
        }

        if (code != null) {
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.html
            ..write('<html><body style="font-family: sans-serif; text-align: center; padding-top: 50px;">'
                '<h2>Connected to Google Drive!</h2>'
                '<p>You can close this tab and return to Sajilo Billing.</p>'
                '</body></html>');
          await request.response.close();
          completer.complete(code);
          return;
        }

        request.response
          ..statusCode = HttpStatus.badRequest
          ..write('Invalid request');
        await request.response.close();
      } catch (e) {
        if (!completer.isCompleted) completer.completeError(e);
      }
    }, onError: (err) {
      if (!completer.isCompleted) {
        if (err is TimeoutException) {
          completer.completeError(const UserCancelledException('Google sign-in timed out. Please try again.'));
        } else {
          completer.completeError(NetworkException('OAuth server error: $err'));
        }
      }
    });

    try {
      return await completer.future;
    } finally {
      await sub.cancel();
    }
  }

  Future<Map<String, dynamic>> _exchangeCodeForTokens({
    required String authCode,
    required String codeVerifier,
    required String clientId,
    required String clientSecret,
    required String redirectUri,
  }) async {
    final tokenUri = Uri.https('oauth2.googleapis.com', '/token');
    final body = {
      'code': authCode,
      'code_verifier': codeVerifier,
      'client_id': clientId,
      if (clientSecret.isNotEmpty) 'client_secret': clientSecret,
      'redirect_uri': redirectUri,
      'grant_type': 'authorization_code',
    };

    final response = await _httpClient.post(tokenUri, body: body);
    if (response.statusCode != 200) {
      debugPrint('[GoogleAuthServiceIo] Token exchange failed: ${response.statusCode} - ${response.body}');
      throw NetworkException('Token exchange failed: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<String> _refreshAccessToken() async {
    final refreshToken = await _secureStorage.read(key: _kRefreshTokenKey);
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const AuthRevokedException('No Google refresh token found. Please sign in again.');
    }

    final clientId = _resolveClientId(null);
    final clientSecret = _resolveClientSecret(null);

    final tokenUri = Uri.https('oauth2.googleapis.com', '/token');
    final body = {
      'client_id': clientId,
      if (clientSecret.isNotEmpty) 'client_secret': clientSecret,
      'refresh_token': refreshToken,
      'grant_type': 'refresh_token',
    };

    final response = await _httpClient.post(tokenUri, body: body);
    if (response.statusCode == 400 || response.statusCode == 401) {
      await signOut();
      throw const AuthRevokedException('Google authorization revoked or expired.');
    }

    if (response.statusCode != 200) {
      throw NetworkException('Failed to refresh token: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final newAccessToken = data['access_token'] as String;
    final expiresIn = data['expires_in'] as int? ?? 3600;

    _cachedAccessToken = newAccessToken;
    _accessTokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));

    if (data.containsKey('refresh_token')) {
      await _secureStorage.write(key: _kRefreshTokenKey, value: data['refresh_token'] as String);
    }
    if (data.containsKey('id_token')) {
      _cachedIdToken = data['id_token'] as String;
      await _secureStorage.write(key: _kIdTokenKey, value: _cachedIdToken!);
    }

    return newAccessToken;
  }

  @override
  Future<String> getValidAccessToken({String? clientId, String? clientSecret}) async {
    final now = DateTime.now();
    if (_cachedAccessToken != null &&
        _accessTokenExpiry != null &&
        _accessTokenExpiry!.isAfter(now.add(const Duration(minutes: 5)))) {
      return _cachedAccessToken!;
    }

    return await _refreshAccessToken();
  }

  Future<GoogleUserInfo> _fetchUserInfo(String accessToken) async {
    final uri = Uri.https('www.googleapis.com', '/oauth2/v3/userinfo');
    final response = await _httpClient.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      return const GoogleUserInfo(email: 'unknown', name: 'Google User');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return GoogleUserInfo.fromJson(data);
  }

  @override
  Future<void> signOut() async {
    try {
      final token = _cachedAccessToken ?? await _secureStorage.read(key: _kRefreshTokenKey);
      if (token != null) {
        final revokeUri = Uri.https('oauth2.googleapis.com', '/revoke', {'token': token});
        await _httpClient.post(revokeUri);
      }
    } catch (e) {
      debugPrint('[GoogleAuthServiceIo] Token revocation error (ignored): $e');
    } finally {
      _cachedAccessToken = null;
      _cachedIdToken = null;
      _accessTokenExpiry = null;
      await _secureStorage.delete(key: _kRefreshTokenKey);
      await _secureStorage.delete(key: _kIdTokenKey);
      await _secureStorage.delete(key: _kEmailKey);
      await _secureStorage.delete(key: _kNameKey);
      debugPrint('[GoogleAuthServiceIo] Signed out and cleared local credentials.');
    }
  }
}
