import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Retail sales and invoice record header.
class Sales extends Table with SyncTableMixin {
  TextColumn get invoiceNumber => text().unique()();
  TextColumn get customerName => text().nullable()();
  TextColumn get customerPan => text().nullable()();
  TextColumn get customerPhone => text().nullable()();
  DateTimeColumn get invoiceDate => dateTime().withDefault(currentDateAndTime)();
  RealColumn get subtotal => real()();
  RealColumn get discountAmount => real().withDefault(const Constant(0.0))();
  RealColumn get taxableAmount => real()();
  RealColumn get vatAmount => real().withDefault(const Constant(0.0))();
  RealColumn get totalAmount => real()();
  TextColumn get paymentMode => text().withDefault(const Constant('CASH'))(); // CASH, FONEPAY, CREDIT
  TextColumn get notes => text().nullable()();
}

