class AdminUser {
  final int id;
  final String username;
  final String email;
  final String? fullName;
  final String status; // ACTIVE, DISABLED, LOCKED
  final List<String> roles;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final bool systemUser;

  const AdminUser({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    required this.status,
    required this.roles,
    this.lastLoginAt,
    this.createdAt,
    this.systemUser = false,
  });

  factory AdminUser.fromJson(Map<String, dynamic> j) => AdminUser(
        id: (j['id'] as num).toInt(),
        username: j['username'] as String,
        email: j['email'] as String,
        fullName: j['fullName'] as String?,
        status: j['status'] as String? ?? 'ACTIVE',
        roles: (j['roles'] as List?)?.cast<String>() ?? const [],
        lastLoginAt: j['lastLoginAt'] != null
            ? DateTime.parse(j['lastLoginAt'] as String)
            : null,
        createdAt: j['createdAt'] != null
            ? DateTime.parse(j['createdAt'] as String)
            : null,
        systemUser: j['systemUser'] as bool? ?? false,
      );

  String get displayName => (fullName != null && fullName!.isNotEmpty) ? fullName! : username;
  bool get isActive => status == 'ACTIVE';
  bool get isAdmin => roles.contains('ADMIN');
  String get primaryRole => roles.isNotEmpty ? roles.first : 'VIEWER';
}

