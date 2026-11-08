import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:sajilo_billing/core/database/app_database.dart';
import 'package:sajilo_billing/features/auth/data/google_auth_service.dart';
import 'package:sajilo_billing/features/sync/data/sync_engine.dart';

class MockGoogleAuthService implements GoogleAuthService {
  @override
  Future<String?> getIdToken() async => 'mock_test_id_token_123';

  @override
  Future<String?> getConnectedEmail() async => 'test@example.com';

  @override
  Future<String?> getConnectedName() async => 'Test User';

  @override
  Future<String> getValidAccessToken({String? clientId, String? clientSecret}) async => 'mock_access_token';

  @override
  Future<bool> isSignedIn() async => true;

  @override
  Future<GoogleUserInfo> signIn({String? clientId, String? clientSecret}) async {
    return const GoogleUserInfo(email: 'test@example.com', name: 'Test User');
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  late AppDatabase db;
  late MockGoogleAuthService auth;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    auth = MockGoogleAuthService();
  });

  tearDown(() async {
    await db.close();
  });

  group('SyncEngine Web & Scheduling Tests', () {
    test('triggerPullOnLogin invokes sync and updates lastSyncedAt', () async {
      int healthCalls = 0;
      int pullCalls = 0;
      int pushCalls = 0;

      final mockClient = MockClient((request) async {
        if (request.url.path == '/health') {
          healthCalls++;
          return http.Response(jsonEncode({'status': 'ok'}), 200);
        }
        if (request.url.path == '/api/sync/push') {
          pushCalls++;
          expect(request.headers['Authorization'], equals('Bearer mock_test_id_token_123'));
          return http.Response(jsonEncode({'status': 'success'}), 200);
        }
        if (request.url.path == '/api/sync/pull') {
          pullCalls++;
          expect(request.headers['Authorization'], equals('Bearer mock_test_id_token_123'));
          return http.Response(jsonEncode({'status': 'success', 'changes': []}), 200);
        }
        return http.Response('Not Found', 404);
      });

      final engine = SyncEngine(
        db: db,
        auth: auth,
        client: mockClient,
        baseUrl: 'http://localhost:8080',
      );

      await engine.triggerPullOnLogin();

      expect(healthCalls, equals(1));
      expect(pushCalls, equals(1));
      expect(pullCalls, equals(1));
      expect(engine.currentState.isPaused, isFalse);
      expect(engine.currentState.lastSyncedAt, isNotNull);

      engine.dispose();
    });

    test('triggerPullOnFocus triggers sync successfully', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'status': 'ok'}), 200);
      });

      final engine = SyncEngine(
        db: db,
        auth: auth,
        client: mockClient,
        baseUrl: 'http://localhost:8080',
      );

      await engine.triggerPullOnFocus();
      expect(engine.currentState.isSyncing, isFalse);
      expect(engine.currentState.lastSyncedAt, isNotNull);

      engine.dispose();
    });

    test('Server unreachable sets isPaused: true with error message', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server error', 500);
      });

      final engine = SyncEngine(
        db: db,
        auth: auth,
        client: mockClient,
        baseUrl: 'http://localhost:8080',
      );

      await engine.sync();

      expect(engine.currentState.isPaused, isTrue);
      expect(engine.currentState.errorMessage, isNotNull);

      engine.dispose();
    });
  });
}
