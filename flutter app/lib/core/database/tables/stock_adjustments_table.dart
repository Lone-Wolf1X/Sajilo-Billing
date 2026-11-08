import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Audited manual stock adjustments (damage, physical audit correction, expiry).
class StockAdjustments extends Table with SyncTableMixin {
  TextColumn get itemId => text()();
  RealColumn get previousQty => real()();
  RealColumn get adjustmentQty => real()(); // Delta
  RealColumn get newQty => real()();
  TextColumn get reason => text()(); // e.g. 'Physical Count Discrepancy', 'Damaged', 'Expired'
  TextColumn get notes => text().nullable()();
}

