import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores JWT access token, refresh token, and tenant info in OS secure storage.
///
/// On macOS: Keychain
/// On Windows: Credential Manager / DPAPI
/// On Linux: libsecret
///
/// NEVER store tokens in SharedPreferences or plain files.
class TokenStorage {
  static const _kAccessToken = 'saisa_access_token';
  static const _kRefreshToken = 'saisa_refresh_token';
  static const _kUserId = 'saisa_user_id';
  static const _kTenantId = 'saisa_tenant_id';
  static const _kTenantCode = 'saisa_tenant_code';
  static const _kRoles = 'saisa_roles';
  static const _kFullName = 'saisa_full_name';

  final FlutterSecureStorage _storage;

  TokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              mOptions: MacOsOptions(useDataProtectionKeyChain: true),
            );

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required int userId,
    required int tenantId,
    required String tenantCode,
    required List<String> roles,
    String? fullName,
  }) async {
    await Future.wait([
      _storage.write(key: _kAccessToken, value: accessToken),
      _storage.write(key: _kRefreshToken, value: refreshToken),
      _storage.write(key: _kUserId, value: userId.toString()),
      _storage.write(key: _kTenantId, value: tenantId.toString()),
      _storage.write(key: _kTenantCode, value: tenantCode),
      _storage.write(key: _kRoles, value: roles.join(',')),
      if (fullName != null) _storage.write(key: _kFullName, value: fullName),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: _kAccessToken);
  Future<String?> getRefreshToken() => _storage.read(key: _kRefreshToken);
  Future<String?> getTenantCode() => _storage.read(key: _kTenantCode);
  Future<String?> getFullName() => _storage.read(key: _kFullName);

  Future<int?> getUserId() async {
    final v = await _storage.read(key: _kUserId);
    return v != null ? int.tryParse(v) : null;
  }

  Future<int?> getTenantId() async {
    final v = await _storage.read(key: _kTenantId);
    return v != null ? int.tryParse(v) : null;
  }

  Future<List<String>> getRoles() async {
    final v = await _storage.read(key: _kRoles);
    return v != null && v.isNotEmpty ? v.split(',') : <String>[];
  }

  Future<bool> hasSession() async {
    final t = await getAccessToken();
    return t != null && t.isNotEmpty;
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
