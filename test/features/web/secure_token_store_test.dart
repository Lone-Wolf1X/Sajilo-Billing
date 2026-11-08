import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/core/platform/secure_token_store_web.dart';

void main() {
  group('SecureTokenStore Tests', () {
    test('SecureTokenStoreWeb operates in-memory only', () async {
      final store = SecureTokenStoreWeb();

      expect(await store.read(key: 'refresh_token'), isNull);

      await store.write(key: 'refresh_token', value: 'secret_token_123');
      expect(await store.read(key: 'refresh_token'), equals('secret_token_123'));

      await store.delete(key: 'refresh_token');
      expect(await store.read(key: 'refresh_token'), isNull);

      await store.write(key: 'key1', value: 'val1');
      await store.write(key: 'key2', value: 'val2');
      await store.deleteAll();
      expect(await store.read(key: 'key1'), isNull);
      expect(await store.read(key: 'key2'), isNull);
    });

    test('SecureTokenStoreWeb source code contains NO localStorage writes (grep assertion)', () {
      final file = File('lib/core/platform/secure_token_store_web.dart');
      expect(file.existsSync(), isTrue);

      final content = file.readAsStringSync();
      expect(content.contains('localStorage'), isFalse,
          reason: 'Web token store must never write tokens to localStorage');
      expect(content.contains('window.localStorage'), isFalse);
      expect(content.contains('sessionStorage'), isFalse);
    });
  });
}
