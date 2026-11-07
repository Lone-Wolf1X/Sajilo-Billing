import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Line items associated with a purchase.
/// All monetary values stored as integer paisa (1 Rs = 100 Paisa).
class PurchaseItems extends Table with SyncTableMixin {
  TextColumn get purchaseId => text()();
  TextColumn get itemId => text()();
  TextColumn get itemName => text()();
  TextColumn get unit => text().withDefault(const Constant('pcs'))();
  RealColumn get quantity => real()();
  IntColumn get ratePaisa => integer()();
  IntColumn get discountPaisa => integer().withDefault(const Constant(0))();
  IntColumn get taxablePaisa => integer()();
  IntColumn get vatPaisa => integer().withDefault(const Constant(0))();
  IntColumn get lineTotalPaisa => integer()();
}
