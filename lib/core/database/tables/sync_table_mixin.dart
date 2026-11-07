import 'package:drift/drift.dart';
import '../sync_status.dart';

/// Mixin providing common fields across all tables for offline-first synchronization.
mixin SyncTableMixin on Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus => textEnum<SyncStatus>().withDefault(Constant(SyncStatus.pending.name))();
  TextColumn get remoteId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
