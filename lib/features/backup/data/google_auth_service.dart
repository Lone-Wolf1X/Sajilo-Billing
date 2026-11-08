import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../domain/backup_error.dart';

/// User profile information from Google OpenID.
class GoogleUserInfo {
  final String email;
  final String name;
  final String? picture;

  const GoogleUserInfo({
    required this.email,
    required this.name,
    this.picture,
  });

  factory GoogleUserInfo.fromJson(Map<String, dynamic> json) {
    return GoogleUserInfo(
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? json['email'] as String? ?? 'Google User',
      picture: json['picture'] as String?,
    );
  }
}

/// Service managing OAuth 2.0 PKCE authentication flow for Desktop (macOS, Windows, Linux)
/// and secure token lifecycle.
class GoogleAuthService {
  static const String _kRefreshTokenKey = 'google_drive_refresh_token';
  static const String _kEmailKey = 'google_account_email';
  static const String _kNameKey = 'google_account_name';

  static const String defaultClientId = String.fromEnvironment('GOOGLE_CLIENT_ID');
  static const String defaultClientSecret = String.fromEnvironment('GOOGLE_CLIENT_SECRET');

  static const List<String> requiredScopes = [
    'https://www.googleapis.com/auth/drive.file',
    'openid',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  final FlutterSecureStorage _secureStorage;
  final http.Client _httpClient;

  String? _cachedAccessToken;
  DateTime? _accessTokenExpiry;

  GoogleAuthService({
    FlutterSecureStorage? secureStorage,
    http.Client? httpClient,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _httpClient = httpClient ?? http.Client();

  /// Redacts sensitive tokens for logging.
  static String redactToken(String? token) {
    if (token == null || token.isEmpty) return 'null';
    if (token.length <= 8) return '***';
    return '${token.substring(0, 4)}...${token.substring(token.length - 4)}';
  }

  /// Generates a cryptographically random PKCE code verifier (RFC 7636).
  static String generateCodeVerifier([int length = 64]) {
    const charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Generates a PKCE S256 code challenge from the given [codeVerifier].
  static String generateCodeChallenge(String codeVerifier) {
    final bytes = ascii.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  /// Checks if a valid refresh token exists in secure storage.
  Future<bool> isSignedIn() async {
    try {
      final token = await _secureStorage.read(key: _kRefreshTokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      debugPrint('[GoogleAuthService] Error checking sign-in status: $e');
      return false;
    }
  }

  /// Returns the saved email of the connected Google account.
  Future<String?> getConnectedEmail() async {
    try {
      return await _secureStorage.read(key: _kEmailKey);
    } catch (_) {
      return null;
    }
  }

  /// Returns the saved display name of the connected Google account.
  Future<String?> getConnectedName() async {
    try {
      return await _secureStorage.read(key: _kNameKey);
    } catch (_) {
      return null;
    }
  }

  /// Resolves the Client ID from parameter, dart-define, or throws if missing.
  String _resolveClientId(String? overrideId) {
    final id = overrideId?.trim() ?? defaultClientId.trim();
    if (id.isEmpty) {
      throw const OAuthConfigurationException(
        'Google Client ID is missing. Supply via --dart-define=GOOGLE_CLIENT_ID or Settings.',
      );
    }
    return id;
  }

  /// Resolves the Client Secret from parameter or dart-define (may be empty for public clients).
  String _resolveClientSecret(String? overrideSecret) {
    return overrideSecret?.trim() ?? defaultClientSecret.trim();
  }

  /// Initiates the Desktop OAuth 2.0 PKCE loopback authorization flow.
  Future<GoogleUserInfo> signIn({
    String? clientId,
    String? clientSecret,
  }) async {
    final effectiveClientId = _resolveClientId(clientId);
    final effectiveClientSecret = _resolveClientSecret(clientSecret);

    final codeVerifier = generateCodeVerifier();
    final codeChallenge = generateCodeChallenge(codeVerifier);

    // Bind ephemeral loopback HTTP server
    HttpServer? server;
    try {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    } catch (e) {
      throw NetworkException('Failed to bind local loopback server for OAuth: $e');
    }

    final redirectUri = 'http://127.0.0.1:${server.port}';
    final completer = Completer<String>();

    // Listen for single incoming redirect request
    server.listen((HttpRequest request) async {
      final uri = request.uri;
      final code = uri.queryParameters['code'];
      final error = uri.queryParameters['error'];

      final response = request.response;
      response.headers.contentType = ContentType.html;

      if (error != null) {
        response.statusCode = HttpStatus.badRequest;
        response.write('''
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>Sajilo Billing - Authentication Failed</title></head>
<body style="font-family: system-ui, -apple-system, sans-serif; text-align: center; padding: 48px;">
  <h2 style="color: #d32f2f;">Authentication Failed</h2>
  <p>$error</p>
  <p>You may close this tab and return to Sajilo Billing.</p>
</body>
</html>
''');
        await response.close();
        if (!completer.isCompleted) {
          completer.completeError(UserCancelledException('OAuth error: $error'));
        }
      } else if (code != null) {
        response.statusCode = HttpStatus.ok;
        response.write('''
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>Sajilo Billing - Authentication Complete</title></head>
<body style="font-family: system-ui, -apple-system, sans-serif; text-align: center; padding: 48px;">
  <h2 style="color: #2e7d32;">Authentication Successful!</h2>
  <p>Your Google account has been connected to Sajilo Billing.</p>
  <p style="color: #666;">You can safely close this window and return to the application.</p>
</body>
</html>
''');
        await response.close();
        if (!completer.isCompleted) {
          completer.complete(code);
        }
      } else {
        response.statusCode = HttpStatus.badRequest;
        response.write('Invalid request');
        await response.close();
      }
    });

    final authUrl = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
      'client_id': effectiveClientId,
      'redirect_uri': redirectUri,
      'response_type': 'code',
      'scope': requiredScopes.join(' '),
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
      'access_type': 'offline',
      'prompt': 'consent',
    });

    debugPrint('[GoogleAuthService] Launching OAuth browser: $authUrl');
    final launched = await launchUrl(authUrl, mode: LaunchMode.externalApplication);
    if (!launched) {
      await server.close(force: true);
      throw const NetworkException('Failed to launch system browser for Google sign-in.');
    }

    String authCode;
    try {
      authCode = await completer.future.timeout(
        const Duration(minutes: 3),
        onTimeout: () => throw const UserCancelledException('Google sign-in timed out.'),
      );
    } finally {
      await server.close(force: true);
    }

    // Exchange auth code for tokens
    final tokenResponse = await _exchangeCodeForTokens(
      code: authCode,
      codeVerifier: codeVerifier,
      redirectUri: redirectUri,
      clientId: effectiveClientId,
      clientSecret: effectiveClientSecret,
    );

    final accessToken = tokenResponse['access_token'] as String;
    final refreshToken = tokenResponse['refresh_token'] as String?;
    final expiresIn = tokenResponse['expires_in'] as int? ?? 3600;

    _cachedAccessToken = accessToken;
    _accessTokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));

    if (refreshToken != null) {
      await _secureStorage.write(key: _kRefreshTokenKey, value: refreshToken);
    }

    // Fetch user info
    final userInfo = await _fetchUserInfo(accessToken);
    await _secureStorage.write(key: _kEmailKey, value: userInfo.email);
    await _secureStorage.write(key: _kNameKey, value: userInfo.name);

    debugPrint('[GoogleAuthService] Connected successfully as ${userInfo.email}');
    return userInfo;
  }

  /// Exchanges authorization code for access and refresh tokens.
  Future<Map<String, dynamic>> _exchangeCodeForTokens({
    required String code,
    required String codeVerifier,
    required String redirectUri,
    required String clientId,
    required String clientSecret,
  }) async {
    final tokenUri = Uri.https('oauth2.googleapis.com', '/token');
    final body = {
      'client_id': clientId,
      if (clientSecret.isNotEmpty) 'client_secret': clientSecret,
      'code': code,
      'code_verifier': codeVerifier,
      'grant_type': 'authorization_code',
      'redirect_uri': redirectUri,
    };

    final response = await _httpClient.post(tokenUri, body: body);
    if (response.statusCode != 200) {
      debugPrint('[GoogleAuthService] Token exchange failed: ${response.statusCode} - ${response.body}');
      throw NetworkException('Token exchange failed: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Refreshes the access token using the stored refresh token.
  Future<String> _refreshAccessToken() async {
    final refreshToken = await _secureStorage.read(key: _kRefreshTokenKey);
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const AuthRevokedException('No refresh token found. Please sign in again.');
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
      // Refresh token revoked or invalid
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

    // If Google issued a new refresh token, store it
    if (data.containsKey('refresh_token')) {
      await _secureStorage.write(key: _kRefreshTokenKey, value: data['refresh_token'] as String);
    }

    return newAccessToken;
  }

  /// Returns a valid access token, refreshing if expiring within 5 minutes.
  Future<String> getValidAccessToken() async {
    final now = DateTime.now();
    if (_cachedAccessToken != null &&
        _accessTokenExpiry != null &&
        _accessTokenExpiry!.isAfter(now.add(const Duration(minutes: 5)))) {
      return _cachedAccessToken!;
    }

    return await _refreshAccessToken();
  }

  /// Fetches basic user profile from Google UserInfo endpoint.
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

  /// Signs out the user, revoking the token at Google and deleting stored keys.
  Future<void> signOut() async {
    try {
      final token = _cachedAccessToken ?? await _secureStorage.read(key: _kRefreshTokenKey);
      if (token != null) {
        final revokeUri = Uri.https('oauth2.googleapis.com', '/revoke', {'token': token});
        await _httpClient.post(revokeUri);
      }
    } catch (e) {
      debugPrint('[GoogleAuthService] Token revocation error (ignored): $e');
    } finally {
      _cachedAccessToken = null;
      _accessTokenExpiry = null;
      await _secureStorage.delete(key: _kRefreshTokenKey);
      await _secureStorage.delete(key: _kEmailKey);
      await _secureStorage.delete(key: _kNameKey);
      debugPrint('[GoogleAuthService] Signed out and cleared local credentials.');
    }
  }
}
