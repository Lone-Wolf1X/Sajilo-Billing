import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/saisa_api_client.dart';
import 'license_model.dart';
import 'license_verifier.dart';

class LicenseService {
  static const _kActiveLicenseJson = 'sajilo_active_license_json';
  static const _kFirstLaunchTimestamp = 'sajilo_first_launch_epoch';

  final SaisaApiClient _apiClient;
  final FlutterSecureStorage _storage;
  final LicenseVerifier _verifier;

  LicenseVerifier get verifier => _verifier;

  LicenseService({
    required SaisaApiClient apiClient,
    FlutterSecureStorage? storage,
    LicenseVerifier? verifier,
  })  : _apiClient = apiClient,
        _storage = storage ?? const FlutterSecureStorage(),
        _verifier = verifier ?? LicenseVerifier();

  Future<LicenseStatus> getLicenseStatus() async {
    // 1. Try fetching live status from backend
    try {
      final response = await _apiClient.get('/api/v1/licenses/status');
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final status =
            LicenseStatus.fromJson(response.data as Map<String, dynamic>);
        // Cache locally for offline resilience
        await _storage.write(
            key: _kActiveLicenseJson, value: jsonEncode(status.toJson()));
        return status;
      }
    } catch (_) {
      // Offline fallback: continue below
    }

    // 2. Try loading cached license from secure storage
    final cached = await _storage.read(key: _kActiveLicenseJson);
    if (cached != null) {
      try {
        final data = jsonDecode(cached) as Map<String, dynamic>;
        return LicenseStatus.fromJson(data);
      } catch (_) {}
    }

    // 3. Fallback: 30-Day Evaluation Trial
    return await _computeLocalTrialStatus();
  }

  Future<LicenseStatus> activateLicense({
    required Uint8List zipBytes,
    required String password,
  }) async {
    final zipBase64 = base64Encode(zipBytes);
    final response = await _apiClient.post(
      '/api/v1/licenses/activate',
      data: {
        'zipBase64': zipBase64,
        'zipPassword': password,
      },
    );

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      final status =
          LicenseStatus.fromJson(response.data as Map<String, dynamic>);
      await _storage.write(
          key: _kActiveLicenseJson, value: jsonEncode(status.toJson()));
      return status;
    } else {
      throw Exception('License activation failed: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> generateLicense({
    required String tenantCode,
    required String companyName,
    required String panNumber,
    required String plan,
    required int durationDays,
    required int maxUsers,
    required List<String> allowedFeatures,
    required String zipPassword,
    String? deliveryEmail,
  }) async {
    final response = await _apiClient.post(
      '/api/v1/licenses/generate',
      data: {
        'tenantCode': tenantCode,
        'companyName': companyName,
        'panNumber': panNumber,
        'plan': plan,
        'durationDays': durationDays,
        'maxUsers': maxUsers,
        'allowedFeatures': allowedFeatures,
        'zipPassword': zipPassword,
        'deliveryEmail': deliveryEmail,
      },
    );

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Failed to generate license: ${response.data}');
    }
  }

  Future<LicenseStatus> _computeLocalTrialStatus() async {
    final now = DateTime.now();
    final firstLaunchStr = await _storage.read(key: _kFirstLaunchTimestamp);
    int firstLaunchEpoch;

    if (firstLaunchStr == null) {
      firstLaunchEpoch = now.millisecondsSinceEpoch;
      await _storage.write(
        key: _kFirstLaunchTimestamp,
        value: firstLaunchEpoch.toString(),
      );
    } else {
      firstLaunchEpoch =
          int.tryParse(firstLaunchStr) ?? now.millisecondsSinceEpoch;
    }

    final firstLaunchDate =
        DateTime.fromMillisecondsSinceEpoch(firstLaunchEpoch);
    final trialExpiresAt = firstLaunchDate.add(const Duration(days: 30));
    final daysLeft = trialExpiresAt.difference(now).inDays;

    return LicenseStatus(
      active: daysLeft >= 0,
      isTrial: true,
      plan: 'TRIAL',
      licenseId: 'TRIAL-EVAL-30D',
      companyName: 'Evaluation License (परीक्षण)',
      panNumber: '',
      issuedAt: firstLaunchDate,
      expiresAt: trialExpiresAt,
      daysRemaining: daysLeft > 0 ? daysLeft : 0,
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
      expired: daysLeft < 0,
    );
  }
}
