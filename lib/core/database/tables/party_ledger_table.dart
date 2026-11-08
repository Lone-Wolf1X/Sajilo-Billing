import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Single source of truth for party ledger movements (Customer & Supplier Khata).
/// Every credit sale, credit purchase, and cash/fonepay settlement appends an immutable audit entry here.
class PartyLedger extends Table with SyncTableMixin {
  /// 'customer' or 'supplier'
  TextColumn get partyType => text().withLength(min: 1, max: 20)();

  /// Reference to Customers.id or Suppliers.id
  TextColumn get partyId => text().withLength(min: 1, max: 64)();

  /// Transaction type: 'sale_credit', 'purchase_credit', 'payment_received', 'payment_made', 'opening_balance', 'adjustment'
  TextColumn get entryType => text().withLength(min: 1, max: 32)();

  /// Transaction amount in integer paisa (always positive)
  IntColumn get amountPaisa => integer()();

  /// Running balance in integer paisa immediately after this transaction.
  /// For customers: positive means customer owes shopkeeper (Receivable / लिन बाँकी).
  /// For suppliers: positive means shopkeeper owes supplier (Payable / तिर्न बाँकी).
  IntColumn get balanceAfterPaisa => integer()();

  /// Reference to Sales.id, Purchases.id, or PartyPayments.id
  TextColumn get refId => text().nullable()();

  /// Reference bill number or receipt number (e.g. 'SB-2082-0001', 'REC-001')
  TextColumn get refNumber => text().nullable()();

  /// Optional remarks or notes (कैफियत)
  TextColumn get notes => text().nullable()();

  /// Date and time of the transaction (stored in UTC)
  DateTimeColumn get entryDate => dateTime()();
}

