import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_token_store.dart';

SecureTokenStore createSecureTokenStore() => SecureTokenStoreIo();

/// Desktop/IO implementation using OS encrypted keychain / libsecret.
class SecureTokenStoreIo implements SecureTokenStore {
  final FlutterSecureStorage _storage;

  SecureTokenStoreIo([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() {
    return _storage.deleteAll();
  }
}
