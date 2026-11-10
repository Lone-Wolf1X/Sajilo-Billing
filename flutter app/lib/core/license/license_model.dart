class LicenseStatus {
  final bool active;
  final bool isTrial;
  final String plan;
  final String licenseId;
  final String companyName;
  final String panNumber;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final int daysRemaining;
  final int maxUsers;
  final List<String> allowedFeatures;
  final bool expired;

  const LicenseStatus({
    required this.active,
    required this.isTrial,
    required this.plan,
    required this.licenseId,
    required this.companyName,
    required this.panNumber,
    required this.issuedAt,
    required this.expiresAt,
    required this.daysRemaining,
    required this.maxUsers,
    required this.allowedFeatures,
    required this.expired,
  });

  factory LicenseStatus.fromJson(Map<String, dynamic> json) {
    return LicenseStatus(
      active: json['active'] as bool? ?? false,
      isTrial: json['isTrial'] as bool? ?? false,
      plan: json['plan'] as String? ?? 'TRIAL',
      licenseId: json['licenseId'] as String? ?? 'N/A',
      companyName: json['companyName'] as String? ?? '',
      panNumber: json['panNumber'] as String? ?? '',
      issuedAt: json['issuedAt'] != null
          ? DateTime.tryParse(json['issuedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'].toString()) ??
              DateTime.now().add(const Duration(days: 30))
          : DateTime.now().add(const Duration(days: 30)),
      daysRemaining: (json['daysRemaining'] as num?)?.toInt() ?? 30,
      maxUsers: (json['maxUsers'] as num?)?.toInt() ?? 2,
      allowedFeatures: (json['allowedFeatures'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['POS', 'DOUBLE_ENTRY', 'REPORTS', 'IRD_TAX'],
      expired: json['expired'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'active': active,
        'isTrial': isTrial,
        'plan': plan,
        'licenseId': licenseId,
        'companyName': companyName,
        'panNumber': panNumber,
        'issuedAt': issuedAt.toIso8601String(),
        'expiresAt': expiresAt.toIso8601String(),
        'daysRemaining': daysRemaining,
        'maxUsers': maxUsers,
        'allowedFeatures': allowedFeatures,
        'expired': expired,
      };

  bool isFeatureAllowed(String feature) {
    if (expired) return false;
    return allowedFeatures.contains(feature);
  }

  static LicenseStatus default30DayTrial({int daysLeft = 30}) {
    final now = DateTime.now();
    return LicenseStatus(
      active: true,
      isTrial: true,
      plan: 'TRIAL',
      licenseId: 'TRIAL-EVAL-30D',
      companyName: 'Evaluation License',
      panNumber: '',
      issuedAt: now,
      expiresAt: now.add(Duration(days: daysLeft)),
      daysRemaining: daysLeft,
      maxUsers: 2,
      allowedFeatures: const [
        'POS',
        'PURCHASE',
        'INVENTORY',
        'REPORTS',
        'IRD_TAX',
        'SMTP_EMAIL',
        'MULTI_USER'
      ],
      expired: daysLeft <= 0,
    );
  }
}
