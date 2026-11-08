import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Inventory/product catalog table (stub for Phase 1, ready for Phase 2).
class Inventories extends Table with SyncTableMixin {
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get sku => text().nullable()();
  TextColumn get unit => text().withDefault(const Constant('pcs'))();
  RealColumn get unitPrice => real().withDefault(const Constant(0.0))();
  RealColumn get costPrice => real().withDefault(const Constant(0.0))();
  RealColumn get stockQuantity => real().withDefault(const Constant(0.0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

