import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Stores local credentials for offline username/password authentication.
class LocalAuth extends Table with SyncTableMixin {
  TextColumn get username => text().unique()();
  TextColumn get passwordHash => text()();
  TextColumn get passwordSalt => text()();
  TextColumn get securityQuestion => text().withDefault(const Constant('What is your shop name?'))();
  TextColumn get securityAnswerHash => text().nullable()();
  IntColumn get failedAttempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get lockedUntil => dateTime().nullable()();
  TextColumn get displayName => text().nullable()();
}

