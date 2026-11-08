import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Retail sales and tax invoice header.
/// All monetary values stored as integer paisa (1 Rs = 100 Paisa).
class Sales extends Table with SyncTableMixin {
  TextColumn get invoiceNumber => text().unique()();
  TextColumn get customerId => text().nullable()();
  TextColumn get customerName => text().withDefault(const Constant('Cash Customer / नगद ग्राहक'))();
  TextColumn get customerPan => text().nullable()();
  TextColumn get customerPhone => text().nullable()();
  DateTimeColumn get invoiceDate => dateTime().withDefault(currentDateAndTime)();
  IntColumn get subtotalPaisa => integer()();
  IntColumn get discountPaisa => integer().withDefault(const Constant(0))();
  IntColumn get taxablePaisa => integer()();
  IntColumn get vatPaisa => integer().withDefault(const Constant(0))();
  IntColumn get totalPaisa => integer()();
  IntColumn get tenderedPaisa => integer().withDefault(const Constant(0))();
  IntColumn get changePaisa => integer().withDefault(const Constant(0))();
  TextColumn get paymentMode => text().withDefault(const Constant('CASH'))(); // CASH, FONEPAY, CREDIT
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('VERIFIED'))(); // 'DRAFT', 'VERIFIED'
  BoolColumn get isVoided => boolean().withDefault(const Constant(false))();
}
