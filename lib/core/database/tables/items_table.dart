import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Item / product master table.
/// Amounts are stored as integer paisa (1 Rupee = 100 Paisa) to avoid float rounding errors.
/// [stockQty] is a cached value kept in sync with [StockLedger] transactions.
class Items extends Table with SyncTableMixin {
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get nepaliName => text().nullable()();
  TextColumn get sku => text().unique()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get unit => text().withDefault(const Constant('pcs'))();
  IntColumn get purchasePricePaisa => integer().withDefault(const Constant(0))();
  IntColumn get sellingPricePaisa => integer().withDefault(const Constant(0))();
  RealColumn get stockQty => real().withDefault(const Constant(0.0))();
  RealColumn get lowStockThreshold => real().withDefault(const Constant(5.0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

