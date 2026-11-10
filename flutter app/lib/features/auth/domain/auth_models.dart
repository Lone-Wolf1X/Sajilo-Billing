/// Login request — matches SAISA's LoginRequest DTO
class LoginRequest {
  final String tenantCode;
  final String username;
  final String password;

  const LoginRequest({
    required this.tenantCode,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'tenantCode': tenantCode,
        'username': username,
        'password': password,
      };
}

/// Auth response from SAISA backend
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresInSeconds;
  final int userId;
  final int tenantId;
  final String tenantCode;
  final List<String> roles;
  final String? fullName;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresInSeconds,
    required this.userId,
    required this.tenantId,
    required this.tenantCode,
    required this.roles,
    this.fullName,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> j) {
    return AuthResponse(
      accessToken: j['accessToken'] as String,
      refreshToken: j['refreshToken'] as String,
      tokenType: j['tokenType'] as String? ?? 'Bearer',
      expiresInSeconds: (j['expiresInSeconds'] as num?)?.toInt() ?? 900,
      userId: (j['userId'] as num).toInt(),
      tenantId: (j['tenantId'] as num).toInt(),
      tenantCode: j['tenantCode'] as String? ?? '',
      roles: (j['roles'] as List?)?.cast<String>() ?? const [],
      fullName: j['fullName'] as String?,
    );
  }
}

/// Public user info exposed to UI (no tokens)
class AuthUser {
  final int userId;
  final int tenantId;
  final String tenantCode;
  final List<String> roles;
  final String? fullName;

  const AuthUser({
    required this.userId,
    required this.tenantId,
    required this.tenantCode,
    required this.roles,
    this.fullName,
  });

  bool hasRole(String role) => roles.contains(role);
  bool get isAdmin => hasRole('ADMIN');
  String get displayName => fullName ?? tenantCode;
}

