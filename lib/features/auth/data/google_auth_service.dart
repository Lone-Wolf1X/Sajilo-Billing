import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/platform/secure_token_store.dart';

import 'google_auth_service_io.dart'
    if (dart.library.html) 'google_auth_service_web.dart' as impl;

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

/// Abstract contract for Google Authentication across Desktop (IO) and Web platforms.
abstract class GoogleAuthService {
  static const String defaultDesktopClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID_DESKTOP',
    defaultValue: String.fromEnvironment(
      'GOOGLE_CLIENT_ID',
      defaultValue: '612120463137-ft0pdu8j2d00tef1birjtb0r3djlfdpg.apps.googleusercontent.com',
    ),
  );

  static const String defaultWebClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID_WEB',
    defaultValue: String.fromEnvironment(
      'GOOGLE_CLIENT_ID',
      defaultValue: '612120463137-ft0pdu8j2d00tef1birjtb0r3djlfdpg.apps.googleusercontent.com',
    ),
  );

  static String get defaultClientId => kIsWeb ? defaultWebClientId : defaultDesktopClientId;

  static const String defaultClientSecret = String.fromEnvironment('GOOGLE_CLIENT_SECRET');

  static const List<String> requiredScopes = [
    'https://www.googleapis.com/auth/drive.file',
    'openid',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  factory GoogleAuthService({
    SecureTokenStore? secureStorage,
    http.Client? httpClient,
  }) =>
      impl.createGoogleAuthService(
        secureStorage: secureStorage,
        httpClient: httpClient,
      );

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

  Future<bool> isSignedIn();
  Future<String?> getConnectedEmail();
  Future<String?> getConnectedName();
  Future<GoogleUserInfo> signIn({String? clientId, String? clientSecret});
  Future<String> getValidAccessToken({String? clientId, String? clientSecret});
  Future<String?> getIdToken();
  Future<void> signOut();
}
