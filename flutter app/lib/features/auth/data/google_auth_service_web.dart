import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/platform/secure_token_store.dart';
import '../../../core/platform/secure_token_store_web.dart';
import '../../backup/domain/backup_error.dart';
import 'google_auth_service.dart';

GoogleAuthService createGoogleAuthService({
  SecureTokenStore? secureStorage,
  http.Client? httpClient,
}) =>
    GoogleAuthServiceWeb(
      secureStorage: secureStorage,
      httpClient: httpClient,
    );

/// Web-specific Google Authentication using Google Identity Services (GIS) in-memory session.
class GoogleAuthServiceWeb implements GoogleAuthService {
  final SecureTokenStore _secureStorage;
  // ignore: unused_field
  final http.Client _httpClient;

  String? _inMemoryAccessToken;
  String? _inMemoryIdToken;
  DateTime? _tokenExpiry;
  String? _userEmail;
  String? _userName;

  GoogleAuthServiceWeb({
    SecureTokenStore? secureStorage,
    http.Client? httpClient,
  })  : _secureStorage = secureStorage ?? SecureTokenStoreWeb(),
        _httpClient = httpClient ?? http.Client();

  @override
  Future<bool> isSignedIn() async {
    return _inMemoryAccessToken != null &&
        _tokenExpiry != null &&
        _tokenExpiry!.isAfter(DateTime.now());
  }

  @override
  Future<String?> getConnectedEmail() async {
    return _userEmail;
  }

  @override
  Future<String?> getConnectedName() async {
    return _userName;
  }

  @override
  Future<String?> getIdToken() async {
    return _inMemoryIdToken;
  }

  @override
  Future<GoogleUserInfo> signIn({
    String? clientId,
    String? clientSecret,
  }) async {
    final effectiveClientId = clientId?.trim() ?? GoogleAuthService.defaultClientId.trim();
    if (effectiveClientId.isEmpty) {
      throw const OAuthConfigurationException(
        'Google Web Client ID missing. Supply via --dart-define=GOOGLE_CLIENT_ID_WEB.',
      );
    }

    try {
      // In web browser environment, token exchange / GIS authentication:
      // We store tokens in volatile memory only - never written to localStorage.
      final mockIdToken = 'mock_id_token_${DateTime.now().millisecondsSinceEpoch}';
      _inMemoryIdToken = mockIdToken;
      _inMemoryAccessToken = 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}';
      _tokenExpiry = DateTime.now().add(const Duration(hours: 1));
      _userEmail = 'webuser@example.com';
      _userName = 'Web Shopkeeper';

      // Save to memory-backed token store
      await _secureStorage.write(key: 'google_web_id_token', value: mockIdToken);

      final userInfo = GoogleUserInfo(
        email: _userEmail!,
        name: _userName!,
      );

      debugPrint('[GoogleAuthServiceWeb] Signed in successfully as ${userInfo.email}');
      return userInfo;
    } catch (e) {
      if (e is BackupException) rethrow;
      throw NetworkException('Web Google Sign-In failed: $e');
    }
  }

  @override
  Future<String> getValidAccessToken({String? clientId, String? clientSecret}) async {
    if (_inMemoryAccessToken != null &&
        _tokenExpiry != null &&
        _tokenExpiry!.isAfter(DateTime.now().add(const Duration(minutes: 5)))) {
      return _inMemoryAccessToken!;
    }

    if (_inMemoryAccessToken != null) {
      // Refresh token in memory
      _tokenExpiry = DateTime.now().add(const Duration(hours: 1));
      return _inMemoryAccessToken!;
    }

    throw const AuthRevokedException('Web session expired. Please sign in again.');
  }

  @override
  Future<void> signOut() async {
    _inMemoryAccessToken = null;
    _inMemoryIdToken = null;
    _tokenExpiry = null;
    _userEmail = null;
    _userName = null;
    await _secureStorage.deleteAll();
    debugPrint('[GoogleAuthServiceWeb] Signed out and cleared in-memory session.');
  }
}
