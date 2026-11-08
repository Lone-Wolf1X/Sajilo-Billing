import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/sync_status.dart';

/// Repository for creating and reading backup audit records.
class BackupRepository {
  final AppDatabase _db;
  final Uuid _uuid;

  BackupRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  /// Logs the initiation of a backup/restore operation.
  Future<String> logStart({
    required String location,
    required String fileName,
    String? googleAccountEmail,
    DateTime? startedAt,
  }) async {
    final id = _uuid.v4();
    final now = startedAt ?? DateTime.now().toUtc();

    await _db.into(_db.backupLogs).insert(
          BackupLogsCompanion(
            id: Value(id),
            startedAt: Value(now),
            status: const Value('in_progress'),
            location: Value(location),
            fileName: Value(fileName),
            sizeBytes: const Value(0),
            googleAccountEmail: Value(googleAccountEmail),
            createdAt: Value(now),
            updatedAt: Value(now),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
    return id;
  }

  /// Marks a backup operation as successfully completed.
  Future<void> logSuccess({
    required String id,
    required int sizeBytes,
  }) async {
    final now = DateTime.now().toUtc();
    await (_db.update(_db.backupLogs)..where((tbl) => tbl.id.equals(id))).write(
      BackupLogsCompanion(
        finishedAt: Value(now),
        status: const Value('success'),
        sizeBytes: Value(sizeBytes),
        updatedAt: Value(now),
      ),
    );
  }

  /// Marks a backup operation as failed with an error message.
  Future<void> logFailure({
    required String id,
    required String errorMessage,
  }) async {
    final now = DateTime.now().toUtc();
    await (_db.update(_db.backupLogs)..where((tbl) => tbl.id.equals(id))).write(
      BackupLogsCompanion(
        finishedAt: Value(now),
        status: const Value('failed'),
        errorMessage: Value(errorMessage),
        updatedAt: Value(now),
      ),
    );
  }

  /// Retrieves the most recent backup logs.
  Future<List<BackupLog>> getRecentLogs({int limit = 20}) {
    return (_db.select(_db.backupLogs)
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.startedAt),
            (tbl) => OrderingTerm.desc(tbl.createdAt),
          ])
          ..limit(limit))
        .get();
  }

  /// Real-time stream of recent backup logs.
  Stream<List<BackupLog>> watchRecentLogs({int limit = 20}) {
    return (_db.select(_db.backupLogs)
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.startedAt),
            (tbl) => OrderingTerm.desc(tbl.createdAt),
          ])
          ..limit(limit))
        .watch();
  }

  /// Gets the timestamp of the most recent successful backup.
  Future<DateTime?> getLastSuccessfulBackupTime({String? location}) async {
    final query = _db.select(_db.backupLogs)
      ..where((tbl) => tbl.status.equals('success'));
    if (location != null) {
      query.where((tbl) => tbl.location.equals(location));
    }
    query
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAt)])
      ..limit(1);

    final results = await query.get();
    if (results.isEmpty) return null;
    return results.first.finishedAt ?? results.first.startedAt;
  }
}
