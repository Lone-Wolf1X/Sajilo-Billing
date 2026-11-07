import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Line items associated with a sale invoice.
class SaleItems extends Table with SyncTableMixin {
  TextColumn get saleId => text()();
  TextColumn get itemName => text()();
  RealColumn get unitPrice => real()();
  RealColumn get quantity => real()();
  RealColumn get amount => real()();
  TextColumn get unit => text().withDefault(const Constant('pcs'))();
}
