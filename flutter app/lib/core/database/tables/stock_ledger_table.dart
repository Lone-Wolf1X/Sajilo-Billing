import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Source-of-truth stock audit ledger.
/// Every inventory movement (Purchase IN, Sale OUT, Adjustment, Returns, Voids)
/// must append an immutable entry to this table.
class StockLedger extends Table with SyncTableMixin {
  TextColumn get itemId => text()();
  RealColumn get qtyChange => real()(); // Positive for IN, Negative for OUT
  TextColumn get reason => text()(); // 'PURCHASE', 'SALE', 'ADJUSTMENT', 'SALE_VOID', 'PURCHASE_RETURN'
  TextColumn get refType => text()(); // 'PURCHASE', 'SALE', 'STOCK_ADJUSTMENT'
  TextColumn get refId => text()();
  TextColumn get notes => text().nullable()();
}

