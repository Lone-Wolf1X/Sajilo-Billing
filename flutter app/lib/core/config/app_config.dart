import 'package:flutter/foundation.dart';

/// Global app config.
/// Backend URL resolution:
///   - Debug / dev: localhost:8080 (SAISA Spring Boot)
///   - Production: bundled backend on 127.0.0.1:8080 (auto-started by desktop shell)
class AppConfig {
  AppConfig._();

  static const String _defaultBaseUrl = 'http://localhost:8080';

  static String get baseUrl {
    const fromEnv = String.fromEnvironment('SAISA_API_URL');
    if (fromEnv.isNotEmpty) return fromEnv;
    return _defaultBaseUrl;
  }

  static const String apiVersion = 'v1';
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// App identity for logging / audit
  static String get appName => 'Sajilo Billing';
  static String get appVersion => '1.0.0';
  static bool get isDebug => kDebugMode;
}

