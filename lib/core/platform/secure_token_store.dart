import 'secure_token_store_io.dart'
    if (dart.library.html) 'secure_token_store_web.dart' as impl;

/// Cross-platform abstraction for storing sensitive authentication tokens.
/// - Desktop (IO): Backed by OS keychain / encrypted storage via flutter_secure_storage.
/// - Web: Strictly in-memory storage (never written to localStorage or cookies).
abstract class SecureTokenStore {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
  Future<void> deleteAll();

  static SecureTokenStore create() => impl.createSecureTokenStore();
}
