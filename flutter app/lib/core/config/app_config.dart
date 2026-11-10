import 'package:flutter/foundation.dart';

/// Global app config.
/// Backend URL resolution:
///   - Debug / dev: localhost:8080 (SAISA Spring Boot)
///   - Production: bundled backend on 127.0.0.1:8080 (auto-started by desktop shell)
class AppConfig {
  AppConfig._();

  static const String _devBaseUrl = 'http://localhost:8080';
  static const String _prodBaseUrl = 'https://nextgeninnovations.com.np/saisa-api';

  static String get baseUrl {
    const fromEnv = String.fromEnvironment('SAISA_API_URL');
    if (fromEnv.isNotEmpty) return fromEnv;
    return kReleaseMode ? _prodBaseUrl : _devBaseUrl;
  }

  static const String apiVersion = 'v1';
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// App identity for logging / audit
  static String get appName => 'SAISA Pro';
  static String get appTagline => 'Enterprise Accounting & Sajilo Billing POS';
  static String get appVersion => '1.0.0';
  static bool get isDebug => kDebugMode;
}

