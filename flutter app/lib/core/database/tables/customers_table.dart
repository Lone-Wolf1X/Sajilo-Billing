import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Retail customers (walk-in and registered khata/credit customers).
class Customers extends Table with SyncTableMixin {
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get phone => text().nullable()();
  TextColumn get panVat => text().nullable()();
  TextColumn get address => text().nullable()();
}

