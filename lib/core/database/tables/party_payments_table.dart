import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Payment settlements / receipts for customer credit clearance and supplier payouts.
class PartyPayments extends Table with SyncTableMixin {
  /// 'customer' (received from customer) or 'supplier' (paid to supplier)
  TextColumn get partyType => text().withLength(min: 1, max: 20)();

  /// Reference to Customers.id or Suppliers.id
  TextColumn get partyId => text().withLength(min: 1, max: 64)();

  /// Amount settled in integer paisa
  IntColumn get amountPaisa => integer()();

  /// Payment mode: 'cash', 'fonepay', 'bank_transfer', 'cheque'
  TextColumn get paymentMode => text().withLength(min: 1, max: 32)();

  /// Unique serial receipt number (e.g. 'REC-2082-0001')
  TextColumn get receiptNumber => text().withLength(min: 1, max: 64)();

  /// Transaction timestamp (stored in UTC)
  DateTimeColumn get paymentDate => dateTime()();

  /// Optional remarks or notes
  TextColumn get notes => text().nullable()();
}

