import 'package:drift/drift.dart';
import '../sync_status.dart';

/// Mixin providing common fields across all tables for offline-first synchronization
/// and auditability. Includes soft-delete flag so deleted records propagate
/// safely to remote backends during future sync.
mixin SyncTableMixin on Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus => textEnum<SyncStatus>().withDefault(Constant(SyncStatus.pending.name))();
  TextColumn get remoteId => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
