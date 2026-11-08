import 'secure_token_store.dart';

SecureTokenStore createSecureTokenStore() => SecureTokenStoreWeb();

/// Web implementation storing tokens strictly in volatile in-memory state.
/// Notice: Never writes tokens to browser persistent storage or web storage.
class SecureTokenStoreWeb implements SecureTokenStore {
  final Map<String, String> _memoryStore = <String, String>{};

  @override
  Future<void> write({required String key, required String value}) async {
    _memoryStore[key] = value;
  }

  @override
  Future<String?> read({required String key}) async {
    return _memoryStore[key];
  }

  @override
  Future<void> delete({required String key}) async {
    _memoryStore.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _memoryStore.clear();
  }
}
