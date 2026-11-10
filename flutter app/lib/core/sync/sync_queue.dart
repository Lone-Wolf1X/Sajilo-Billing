import 'package:drift/drift.dart';

/// Local queue table for pending sync operations to SAISA backend.
@DataClassName('SyncQueueItem')
class SyncQueueItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get opType => text()();
  TextColumn get payloadJson => text()();
  TextColumn get idempotencyKey => text().unique()();
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get serverResponseJson => text().nullable()();
}
