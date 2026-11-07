import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Stock purchases from suppliers (stub for Phase 1).
class Purchases extends Table with SyncTableMixin {
  TextColumn get supplierName => text()();
  TextColumn get supplierPan => text().nullable()();
  TextColumn get invoiceNumber => text().nullable()();
  DateTimeColumn get purchaseDate => dateTime().withDefault(currentDateAndTime)();
  RealColumn get totalAmount => real()();
  TextColumn get remarks => text().nullable()();
}

