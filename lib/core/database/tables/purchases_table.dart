import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Stock purchases from suppliers.
/// All monetary values stored as integer paisa (1 Rs = 100 Paisa).
class Purchases extends Table with SyncTableMixin {
  TextColumn get supplierId => text().nullable()();
  TextColumn get supplierName => text()();
  TextColumn get supplierPan => text().nullable()();
  TextColumn get billNumber => text().nullable()();
  DateTimeColumn get purchaseDate => dateTime().withDefault(currentDateAndTime)();
  IntColumn get subtotalPaisa => integer().withDefault(const Constant(0))();
  IntColumn get discountPaisa => integer().withDefault(const Constant(0))();
  IntColumn get taxablePaisa => integer().withDefault(const Constant(0))();
  IntColumn get vatPaisa => integer().withDefault(const Constant(0))();
  IntColumn get totalPaisa => integer().withDefault(const Constant(0))();
  TextColumn get remarks => text().nullable()();
  BoolColumn get isReturned => boolean().withDefault(const Constant(false))();
}
