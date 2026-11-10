import '../../../core/api/saisa_api_client.dart';
import '../../../core/errors/api_exception.dart';
import '../../../core/storage/token_storage.dart';
import '../domain/auth_models.dart';

class AuthRepository {
  final SaisaApiClient _api;
  final TokenStorage _storage;

  AuthRepository({required SaisaApiClient api, required TokenStorage storage})
      : _api = api,
        _storage = storage;

  /// Login with tenant code + username + password.
  Future<AuthUser> login({
    required String tenantCode,
    required String username,
    required String password,
  }) async {
    try {
      final resp = await _api.post<Map<String, dynamic>>(
        '/auth/login',
        data: LoginRequest(
          tenantCode: tenantCode,
          username: username,
          password: password,
        ).toJson(),
      );

      final auth = AuthResponse.fromJson(resp);
      await _storage.saveSession(
        accessToken: auth.accessToken,
        refreshToken: auth.refreshToken,
        userId: auth.userId,
        tenantId: auth.tenantId,
        tenantCode: auth.tenantCode,
        roles: auth.roles,
        fullName: auth.fullName,
      );

      return AuthUser(
        userId: auth.userId,
        tenantId: auth.tenantId,
        tenantCode: auth.tenantCode,
        roles: auth.roles,
        fullName: auth.fullName,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        code: 'LOGIN_FAILED',
        message: 'Login failed: $e',
      );
    }
  }

  /// Logout: clear tokens. No backend call (JWT is stateless).
  Future<void> logout() => _storage.clear();

  /// Check if there's an existing session (for auto-login on app start).
  Future<AuthUser?> restoreSession() async {
    if (!await _storage.hasSession()) return null;

    final userId = await _storage.getUserId();
    final tenantId = await _storage.getTenantId();
    final tenantCode = await _storage.getTenantCode();
    final roles = await _storage.getRoles();
    final fullName = await _storage.getFullName();

    if (userId == null || tenantId == null) {
      await _storage.clear();
      return null;
    }

    return AuthUser(
      userId: userId,
      tenantId: tenantId,
      tenantCode: tenantCode ?? '',
      roles: roles,
      fullName: fullName,
    );
  }
}
