import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Wholesale suppliers / vendors.
class Suppliers extends Table with SyncTableMixin {
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get phone => text().nullable()();
  TextColumn get panVat => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get contactPerson => text().nullable()();
}

