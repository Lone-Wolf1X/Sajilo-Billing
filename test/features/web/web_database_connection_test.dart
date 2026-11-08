import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/core/database/app_database.dart';
import 'package:sajilo_billing/core/database/web_database_connection.dart';

void main() {
  group('WebDatabase & AppDatabase QueryExecutor Tests', () {
    test('AppDatabase works with injected QueryExecutor for cross-platform portability', () async {
      final db = AppDatabase(NativeDatabase.memory());

      // Verify tables and schema version
      expect(db.schemaVersion, equals(4));

      // Test insertion into business profile
      await db.into(db.businessProfiles).insert(
            BusinessProfilesCompanion.insert(
              id: 'test-biz-1',
              businessName: 'Web Test Shop',
              panVatNumber: '123456789',
              contactNumber: '9841000000',
            ),
          );

      final profile = await db.select(db.businessProfiles).getSingle();
      expect(profile.businessName, equals('Web Test Shop'));

      await db.close();
    });

    test('WebDatabase.open returns a valid LazyDatabase QueryExecutor', () {
      final executor = WebDatabase.open(
        databaseName: 'test_web_db',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );

      expect(executor, isA<QueryExecutor>());
      expect(executor, isA<LazyDatabase>());
    });
  });
}
