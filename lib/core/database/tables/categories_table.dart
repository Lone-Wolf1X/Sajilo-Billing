import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Product categories (e.g. Rice & Grains, Oils, Spices, Dairy, Snacks).
class Categories extends Table with SyncTableMixin {
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get nepaliName => text().nullable()();
  TextColumn get description => text().nullable()();
}
