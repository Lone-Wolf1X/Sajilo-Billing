import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/sync_status.dart';
import '../domain/khata_models.dart';

/// Repository managing Party Ledger (Customer & Supplier Khata), credit transactions,
/// and payment settlements with atomic double-entry balance tracking.
class KhataRepository {
  final AppDatabase _db;
  final Uuid _uuid;

  KhataRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  /// Gets the current running balance for a given party by summing audited ledger entries.
  Future<int> getCurrentBalance(String partyId) async {
    final entries = await (_db.select(_db.partyLedger)
          ..where((tbl) => tbl.partyId.equals(partyId) & tbl.isDeleted.equals(false)))
        .get();

    int balance = 0;
    for (final e in entries) {
      if (e.entryType == 'sale_credit' || e.entryType == 'purchase_credit') {
        balance += e.amountPaisa;
      } else if (e.entryType == 'payment_received' || e.entryType == 'payment_made') {
        balance -= e.amountPaisa;
      }
    }
    return balance;
  }

  /// Records a credit sale to customer in the party ledger.
  /// Customer owes money (+Receivable).
  Future<String> recordCustomerCreditSale({
    required String customerId,
    required int amountPaisa,
    required String saleId,
    required String billNumber,
    String? notes,
    DateTime? entryDate,
  }) async {
    return _db.transaction(() async {
      final currentBalance = await getCurrentBalance(customerId);
      final newBalance = currentBalance + amountPaisa;
      final id = _uuid.v4();
      final now = entryDate ?? DateTime.now().toUtc();

      await _db.into(_db.partyLedger).insert(
            PartyLedgerCompanion(
              id: Value(id),
              partyType: const Value('customer'),
              partyId: Value(customerId),
              entryType: const Value('sale_credit'),
              amountPaisa: Value(amountPaisa),
              balanceAfterPaisa: Value(newBalance),
              refId: Value(saleId),
              refNumber: Value(billNumber),
              notes: Value(notes ?? 'Credit Sale (उधारो बिक्री)'),
              entryDate: Value(now),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatus.pending),
            ),
          );

      return id;
    });
  }

  /// Records a credit purchase from supplier in the party ledger.
  /// Shopkeeper owes money (+Payable).
  Future<String> recordSupplierCreditPurchase({
    required String supplierId,
    required int amountPaisa,
    required String purchaseId,
    required String billNumber,
    String? notes,
    DateTime? entryDate,
  }) async {
    return _db.transaction(() async {
      final currentBalance = await getCurrentBalance(supplierId);
      final newBalance = currentBalance + amountPaisa;
      final id = _uuid.v4();
      final now = entryDate ?? DateTime.now().toUtc();

      await _db.into(_db.partyLedger).insert(
            PartyLedgerCompanion(
              id: Value(id),
              partyType: const Value('supplier'),
              partyId: Value(supplierId),
              entryType: const Value('purchase_credit'),
              amountPaisa: Value(amountPaisa),
              balanceAfterPaisa: Value(newBalance),
              refId: Value(purchaseId),
              refNumber: Value(billNumber),
              notes: Value(notes ?? 'Credit Purchase (उधारो खरिद)'),
              entryDate: Value(now),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatus.pending),
            ),
          );

      return id;
    });
  }

  /// Records cash / fonepay payment received from a customer to clear outstanding credit.
  /// Decrements customer receivable (-Receivable).
  Future<String> recordCustomerPayment({
    required String customerId,
    required int amountPaisa,
    required String paymentMode,
    String? notes,
    DateTime? paymentDate,
  }) async {
    return _db.transaction(() async {
      final currentBalance = await getCurrentBalance(customerId);
      final newBalance = currentBalance - amountPaisa;
      final paymentId = _uuid.v4();
      final ledgerId = _uuid.v4();
      final now = paymentDate ?? DateTime.now().toUtc();

      // Generate receipt number (e.g. REC-2082-XXXX)
      final count = await _db.partyPayments.count().getSingle();
      final receiptNumber = 'REC-${now.year}-${(count + 1).toString().padLeft(4, '0')}';

      // 1. Insert payment record
      await _db.into(_db.partyPayments).insert(
            PartyPaymentsCompanion(
              id: Value(paymentId),
              partyType: const Value('customer'),
              partyId: Value(customerId),
              amountPaisa: Value(amountPaisa),
              paymentMode: Value(paymentMode),
              receiptNumber: Value(receiptNumber),
              paymentDate: Value(now),
              notes: Value(notes),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatus.pending),
            ),
          );

      // 2. Append ledger entry
      await _db.into(_db.partyLedger).insert(
            PartyLedgerCompanion(
              id: Value(ledgerId),
              partyType: const Value('customer'),
              partyId: Value(customerId),
              entryType: const Value('payment_received'),
              amountPaisa: Value(amountPaisa),
              balanceAfterPaisa: Value(newBalance),
              refId: Value(paymentId),
              refNumber: Value(receiptNumber),
              notes: Value(notes ?? 'Payment received (रकम असुली) - $paymentMode'),
              entryDate: Value(now),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatus.pending),
            ),
          );

      return receiptNumber;
    });
  }

  /// Records payment payout made to a supplier.
  /// Decrements supplier payable (-Payable).
  Future<String> recordSupplierPayment({
    required String supplierId,
    required int amountPaisa,
    required String paymentMode,
    String? notes,
    DateTime? paymentDate,
  }) async {
    return _db.transaction(() async {
      final currentBalance = await getCurrentBalance(supplierId);
      final newBalance = currentBalance - amountPaisa;
      final paymentId = _uuid.v4();
      final ledgerId = _uuid.v4();
      final now = paymentDate ?? DateTime.now().toUtc();

      final count = await _db.partyPayments.count().getSingle();
      final receiptNumber = 'PAY-${now.year}-${(count + 1).toString().padLeft(4, '0')}';

      // 1. Insert payment record
      await _db.into(_db.partyPayments).insert(
            PartyPaymentsCompanion(
              id: Value(paymentId),
              partyType: const Value('supplier'),
              partyId: Value(supplierId),
              amountPaisa: Value(amountPaisa),
              paymentMode: Value(paymentMode),
              receiptNumber: Value(receiptNumber),
              paymentDate: Value(now),
              notes: Value(notes),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatus.pending),
            ),
          );

      // 2. Append ledger entry
      await _db.into(_db.partyLedger).insert(
            PartyLedgerCompanion(
              id: Value(ledgerId),
              partyType: const Value('supplier'),
              partyId: Value(supplierId),
              entryType: const Value('payment_made'),
              amountPaisa: Value(amountPaisa),
              balanceAfterPaisa: Value(newBalance),
              refId: Value(paymentId),
              refNumber: Value(receiptNumber),
              notes: Value(notes ?? 'Payment payout to supplier (भुक्तानी) - $paymentMode'),
              entryDate: Value(now),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatus.pending),
            ),
          );

      return receiptNumber;
    });
  }

  /// Stream of customer khata summaries with real-time balance computation.
  Stream<List<PartySummary>> watchCustomerSummaries({String? searchQuery, bool onlyWithDues = false}) {
    return (_db.select(_db.customers)..where((tbl) => tbl.isDeleted.equals(false))).watch().asyncMap((customers) async {
      final summaries = <PartySummary>[];

      for (final c in customers) {
        if (searchQuery != null && searchQuery.trim().isNotEmpty) {
          final query = searchQuery.toLowerCase();
          final matchesName = c.name.toLowerCase().contains(query);
          final matchesPhone = c.phone?.toLowerCase().contains(query) ?? false;
          if (!matchesName && !matchesPhone) continue;
        }

        final entries = await (_db.select(_db.partyLedger)
              ..where((tbl) => tbl.partyId.equals(c.id) & tbl.isDeleted.equals(false))
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.entryDate), (tbl) => OrderingTerm.asc(tbl.createdAt)]))
            .get();

        int totalCredit = 0;
        int totalSettled = 0;
        int balance = 0;
        DateTime? lastDate;

        for (final e in entries) {
          lastDate = e.entryDate;
          if (e.entryType == 'sale_credit') {
            totalCredit += e.amountPaisa;
          } else if (e.entryType == 'payment_received') {
            totalSettled += e.amountPaisa;
          }
          balance = e.balanceAfterPaisa;
        }

        if (onlyWithDues && balance <= 0) continue;

        summaries.add(PartySummary(
          id: c.id,
          partyType: PartyType.customer,
          name: c.name,
          phone: c.phone,
          panVat: c.panVat,
          address: c.address,
          currentBalancePaisa: balance,
          totalCreditPaisa: totalCredit,
          totalSettledPaisa: totalSettled,
          lastTransactionDate: lastDate,
        ));
      }

      // Sort with highest pending balance on top
      summaries.sort((a, b) => b.currentBalancePaisa.compareTo(a.currentBalancePaisa));
      return summaries;
    });
  }

  /// Stream of supplier khata summaries with real-time payable balance computation.
  Stream<List<PartySummary>> watchSupplierSummaries({String? searchQuery, bool onlyWithDues = false}) {
    return (_db.select(_db.suppliers)..where((tbl) => tbl.isDeleted.equals(false))).watch().asyncMap((suppliers) async {
      final summaries = <PartySummary>[];

      for (final s in suppliers) {
        if (searchQuery != null && searchQuery.trim().isNotEmpty) {
          final query = searchQuery.toLowerCase();
          final matchesName = s.name.toLowerCase().contains(query);
          final matchesPhone = s.phone?.toLowerCase().contains(query) ?? false;
          if (!matchesName && !matchesPhone) continue;
        }

        final entries = await (_db.select(_db.partyLedger)
              ..where((tbl) => tbl.partyId.equals(s.id) & tbl.isDeleted.equals(false))
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.entryDate), (tbl) => OrderingTerm.asc(tbl.createdAt)]))
            .get();

        int totalCredit = 0;
        int totalSettled = 0;
        int balance = 0;
        DateTime? lastDate;

        for (final e in entries) {
          lastDate = e.entryDate;
          if (e.entryType == 'purchase_credit') {
            totalCredit += e.amountPaisa;
          } else if (e.entryType == 'payment_made') {
            totalSettled += e.amountPaisa;
          }
          balance = e.balanceAfterPaisa;
        }

        if (onlyWithDues && balance <= 0) continue;

        summaries.add(PartySummary(
          id: s.id,
          partyType: PartyType.supplier,
          name: s.name,
          phone: s.phone,
          panVat: s.panVat,
          address: s.address,
          currentBalancePaisa: balance,
          totalCreditPaisa: totalCredit,
          totalSettledPaisa: totalSettled,
          lastTransactionDate: lastDate,
        ));
      }

      summaries.sort((a, b) => b.currentBalancePaisa.compareTo(a.currentBalancePaisa));
      return summaries;
    });
  }

  /// Stream of full chronological audit ledger entries for a party.
  Stream<List<PartyLedgerData>> watchPartyLedger(String partyId) {
    return (_db.select(_db.partyLedger)
          ..where((tbl) => tbl.partyId.equals(partyId) & tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.entryDate), (tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .watch();
  }

  /// Stream of overall store Khata metrics (Total Receivable vs Total Payable).
  Stream<OverallKhataMetrics> watchOverallMetrics() {
    return _db.partyLedger.all().watch().asyncMap((_) async {
      final customers = await watchCustomerSummaries().first;
      final suppliers = await watchSupplierSummaries().first;

      int totalReceivable = 0;
      int customersWithDues = 0;
      for (final c in customers) {
        if (c.currentBalancePaisa > 0) {
          totalReceivable += c.currentBalancePaisa;
          customersWithDues++;
        }
      }

      int totalPayable = 0;
      int suppliersWithDues = 0;
      for (final s in suppliers) {
        if (s.currentBalancePaisa > 0) {
          totalPayable += s.currentBalancePaisa;
          suppliersWithDues++;
        }
      }

      return OverallKhataMetrics(
        totalCustomerReceivablePaisa: totalReceivable,
        totalSupplierPayablePaisa: totalPayable,
        customersWithDuesCount: customersWithDues,
        suppliersWithDuesCount: suppliersWithDues,
      );
    });
  }

  /// Creates a new customer or returns existing if found by phone/name.
  Future<Customer> getOrCreateCustomer({
    required String name,
    String? phone,
    String? panVat,
    String? address,
  }) async {
    if (phone != null && phone.trim().isNotEmpty) {
      final existing = await (_db.select(_db.customers)
            ..where((tbl) => tbl.phone.equals(phone.trim()) & tbl.isDeleted.equals(false))
            ..limit(1))
          .getSingleOrNull();
      if (existing != null) return existing;
    }

    final id = _uuid.v4();
    final now = DateTime.now().toUtc();
    await _db.into(_db.customers).insert(
          CustomersCompanion(
            id: Value(id),
            name: Value(name.trim()),
            phone: Value(phone?.trim()),
            panVat: Value(panVat?.trim()),
            address: Value(address?.trim()),
            createdAt: Value(now),
            updatedAt: Value(now),
            syncStatus: const Value(SyncStatus.pending),
          ),
        );

    return await (_db.select(_db.customers)..where((tbl) => tbl.id.equals(id))).getSingle();
  }
}

