import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/core/database/app_database.dart';
import 'package:sajilo_billing/features/backup/data/backup_repository.dart';

void main() {
  late AppDatabase db;
  late BackupRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = BackupRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('BackupRepository Audit Logging Tests', () {
    test('Logs start, success, and retrieves logs in reverse chronological order', () async {
      final t1 = DateTime.now().toUtc().subtract(const Duration(minutes: 5));
      final t2 = DateTime.now().toUtc();

      // 1. Log start
      final id1 = await repo.logStart(
        location: 'local',
        fileName: 'sajilo_backup_1.sqlite',
        startedAt: t1,
      );
      expect(id1, isNotEmpty);

      // 2. Mark success
      await repo.logSuccess(id: id1, sizeBytes: 1048576);

      // 3. Log a drive backup
      final id2 = await repo.logStart(
        location: 'drive',
        fileName: 'sajilo_backup_2.zip',
        googleAccountEmail: 'shopkeeper@gmail.com',
        startedAt: t2,
      );
      await repo.logSuccess(id: id2, sizeBytes: 2097152);

      // 4. Retrieve logs
      final logs = await repo.getRecentLogs(limit: 10);
      expect(logs.length, equals(2));

      // Most recent should be id2
      expect(logs.first.id, equals(id2));
      expect(logs.first.location, equals('drive'));
      expect(logs.first.status, equals('success'));
      expect(logs.first.googleAccountEmail, equals('shopkeeper@gmail.com'));
      expect(logs.first.sizeBytes, equals(2097152));

      expect(logs[1].id, equals(id1));
      expect(logs[1].location, equals('local'));
      expect(logs[1].status, equals('success'));
      expect(logs[1].sizeBytes, equals(1048576));
    });

    test('Logs failures with error messages properly', () async {
      final id = await repo.logStart(
        location: 'drive',
        fileName: 'failed_backup.zip',
      );

      await repo.logFailure(id: id, errorMessage: 'Network connection timed out');

      final logs = await repo.getRecentLogs(limit: 5);
      expect(logs.length, equals(1));
      expect(logs.first.status, equals('failed'));
      expect(logs.first.errorMessage, equals('Network connection timed out'));
    });

    test('getLastSuccessfulBackupTime accurately filters by status and location', () async {
      // No backups yet
      expect(await repo.getLastSuccessfulBackupTime(), isNull);

      // Failed backup
      final failedId = await repo.logStart(location: 'drive', fileName: 'fail.zip');
      await repo.logFailure(id: failedId, errorMessage: 'Error');
      expect(await repo.getLastSuccessfulBackupTime(), isNull);

      // Successful local backup
      final localId = await repo.logStart(location: 'local', fileName: 'local.sqlite');
      await repo.logSuccess(id: localId, sizeBytes: 500);

      final lastTime = await repo.getLastSuccessfulBackupTime();
      expect(lastTime, isNotNull);
      expect(await repo.getLastSuccessfulBackupTime(location: 'drive'), isNull);
      expect(await repo.getLastSuccessfulBackupTime(location: 'local'), isNotNull);
    });
  });
}
