import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Audit log for local and Google Drive backup & restore operations.
class BackupLogs extends Table with SyncTableMixin {
  /// When the backup/restore operation was initiated.
  DateTimeColumn get startedAt => dateTime()();

  /// When the backup/restore operation completed (or failed).
  DateTimeColumn get finishedAt => dateTime().nullable()();

  /// Status of the operation: 'success', 'failed', 'in_progress', etc.
  TextColumn get status => text().withLength(min: 1, max: 32)();

  /// Destination / source: 'local' or 'drive'.
  TextColumn get location => text().withLength(min: 1, max: 32)();

  /// Filename of the backup archive (e.g. sajilo_backup_20261108_120000.zip).
  TextColumn get fileName => text().withLength(min: 1, max: 255)();

  /// Size of the backup archive in bytes.
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();

  /// Human-readable error message if operation failed.
  TextColumn get errorMessage => text().nullable()();

  /// Connected Google account email if location is 'drive'.
  TextColumn get googleAccountEmail => text().nullable()();
}

