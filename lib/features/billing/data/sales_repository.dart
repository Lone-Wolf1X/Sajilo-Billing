import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/sync_status.dart';

class SaleLineInput {
  final String itemId;
  final String itemName;
  final String unit;
  final double quantity;
  final int ratePaisa;
  final int discountPaisa;
  final bool isVatApplicable;

  const SaleLineInput({
    required this.itemId,
    required this.itemName,
    required this.unit,
    required this.quantity,
    required this.ratePaisa,
    this.discountPaisa = 0,
    this.isVatApplicable = false,
  });

  int get grossPaisa => (quantity * ratePaisa).round();
  int get taxablePaisa => (grossPaisa - discountPaisa).clamp(0, 999999999);
  int get vatPaisa => isVatApplicable ? (taxablePaisa * 0.13).round() : 0;
  int get lineTotalPaisa => taxablePaisa + vatPaisa;
}

class SaleWithItems {
  final Sale sale;
  final List<SaleItem> items;
  final Customer? customer;

  SaleWithItems({
    required this.sale,
    required this.items,
    this.customer,
  });
}

class DailySalesSummary {
  final int totalSalesCount;
  final int totalRevenuePaisa;
  final List<TopSoldItem> topItems;

  const DailySalesSummary({
    required this.totalSalesCount,
    required this.totalRevenuePaisa,
    required this.topItems,
  });
}

class TopSoldItem {
  final String itemName;
  final double totalQty;
  final int totalAmountPaisa;

  const TopSoldItem({
    required this.itemName,
    required this.totalQty,
    required this.totalAmountPaisa,
  });
}

class SalesRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  SalesRepository(this._db);

  /// Streams sales with optional date filter and search query.
  Stream<List<Sale>> watchSales({
    DateTime? startDate,
    DateTime? endDate,
    String? query,
    bool includeVoided = false,
  }) {
    final q = _db.select(_db.sales);

    if (!includeVoided) {
      q.where((tbl) => tbl.isVoided.equals(false) & tbl.isDeleted.equals(false));
    }

    if (startDate != null) {
      q.where((tbl) => tbl.invoiceDate.isBiggerOrEqualValue(startDate.toUtc()));
    }

    if (endDate != null) {
      q.where((tbl) => tbl.invoiceDate.isSmallerOrEqualValue(endDate.toUtc()));
    }

    if (query != null && query.trim().isNotEmpty) {
      final clean = '%${query.trim().toLowerCase()}%';
      q.where((tbl) =>
          tbl.invoiceNumber.lower().like(clean) |
          tbl.customerName.lower().like(clean) |
          tbl.customerPhone.lower().like(clean));
    }

    q.orderBy([(tbl) => OrderingTerm(expression: tbl.invoiceDate, mode: OrderingMode.desc)]);
    return q.watch();
  }

  /// Gets single sale with line items and customer info.
  Future<SaleWithItems?> getSaleDetails(String saleId) async {
    final sale = await (_db.select(_db.sales)..where((tbl) => tbl.id.equals(saleId)))
        .getSingleOrNull();

    if (sale == null) return null;

    final items = await (_db.select(_db.saleItems)
          ..where((tbl) => tbl.saleId.equals(saleId) & tbl.isDeleted.equals(false)))
        .get();

    Customer? customer;
    if (sale.customerId != null) {
      customer = await (_db.select(_db.customers)
            ..where((tbl) => tbl.id.equals(sale.customerId!)))
          .getSingleOrNull();
    }

    return SaleWithItems(sale: sale, items: items, customer: customer);
  }

  /// Atomically gets next bill number using bill_sequence table.
  /// Formats like "SB-2082-0001" or "SB-2081-0042".
  Future<String> _generateNextBillNumber(DateTime date) async {
    // Nepali Bikram Sambat year estimate or configuration
    // 2026 AD ~ 2082/2083 BS
    final fiscalYear = '${date.year + 57}';
    const seqType = 'SALES_INVOICE';

    final existing = await (_db.select(_db.billSequence)
          ..where((tbl) =>
              tbl.sequenceType.equals(seqType) & tbl.fiscalYear.equals(fiscalYear)))
        .getSingleOrNull();

    final nextNumber = (existing?.currentNumber ?? 0) + 1;

    if (existing == null) {
      await _db.into(_db.billSequence).insert(
            BillSequenceCompanion.insert(
              sequenceType: seqType,
              fiscalYear: fiscalYear,
              prefix: const Value('SB'),
              currentNumber: Value(nextNumber),
              updatedAt: Value(DateTime.now().toUtc()),
            ),
          );
    } else {
      await (_db.update(_db.billSequence)
            ..where((tbl) =>
                tbl.sequenceType.equals(seqType) & tbl.fiscalYear.equals(fiscalYear)))
          .write(
        BillSequenceCompanion(
          currentNumber: Value(nextNumber),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
    }

    final formattedNumber = nextNumber.toString().padLeft(4, '0');
    return 'SB-$fiscalYear-$formattedNumber';
  }

  /// Creates a sale and tax invoice in ONE single atomic transaction:
  /// 1. Validates stock availability for every line item.
  /// 2. Generates gapless sequential bill number.
  /// 3. Inserts into sales and sale_items.
  /// 4. Appends negative entries to stock_ledger.
  /// 5. Decrements items stockQty cache.
  Future<Sale> createSale({
    String? customerId,
    String customerName = 'Cash Customer / नगद ग्राहक',
    String? customerPhone,
    String? customerPan,
    DateTime? invoiceDate,
    required List<SaleLineInput> lines,
    int billDiscountPaisa = 0,
    int tenderedPaisa = 0,
    String paymentMode = 'CASH',
    String? notes,
  }) async {
    if (lines.isEmpty) {
      throw Exception('Invoice must contain at least one line item');
    }

    final now = DateTime.now().toUtc();
    final saleDate = (invoiceDate ?? DateTime.now()).toUtc();
    final saleId = _uuid.v4();

    return await _db.transaction(() async {
      // Step 1: Pre-validate stock availability for all items
      for (final line in lines) {
        final item = await (_db.select(_db.items)
              ..where((tbl) => tbl.id.equals(line.itemId) & tbl.isDeleted.equals(false)))
            .getSingleOrNull();

        if (item == null) {
          throw Exception('Item "${line.itemName}" no longer exists in inventory');
        }

        if (item.stockQty < line.quantity) {
          throw Exception(
            'Insufficient stock for "${item.name}". Required: ${line.quantity} ${item.unit}, Available: ${item.stockQty} ${item.unit}',
          );
        }
      }

      // Step 2: Generate unique bill number atomically
      final invoiceNumber = await _generateNextBillNumber(saleDate);

      // Step 3: Compute totals
      var subtotalPaisa = 0;
      var linesDiscountPaisa = 0;
      var taxablePaisa = 0;
      var vatPaisa = 0;
      var totalPaisa = 0;

      for (final line in lines) {
        subtotalPaisa += line.grossPaisa;
        linesDiscountPaisa += line.discountPaisa;
        taxablePaisa += line.taxablePaisa;
        vatPaisa += line.vatPaisa;
        totalPaisa += line.lineTotalPaisa;
      }

      // Apply overall bill discount if any
      final totalDiscountPaisa = linesDiscountPaisa + billDiscountPaisa;
      if (billDiscountPaisa > 0) {
        taxablePaisa = (taxablePaisa - billDiscountPaisa).clamp(0, 999999999);
        totalPaisa = (totalPaisa - billDiscountPaisa).clamp(0, 999999999);
      }

      final changePaisa = tenderedPaisa > totalPaisa ? (tenderedPaisa - totalPaisa) : 0;

      // Step 4: Insert sale record
      final saleCompanion = SalesCompanion.insert(
        id: saleId,
        invoiceNumber: invoiceNumber,
        customerId: Value(customerId),
        customerName: Value(customerName.trim().isEmpty ? 'Cash Customer / नगद ग्राहक' : customerName.trim()),
        customerPhone: Value(customerPhone?.trim()),
        customerPan: Value(customerPan?.trim()),
        invoiceDate: Value(saleDate),
        subtotalPaisa: subtotalPaisa,
        discountPaisa: Value(totalDiscountPaisa),
        taxablePaisa: taxablePaisa,
        vatPaisa: Value(vatPaisa),
        totalPaisa: totalPaisa,
        tenderedPaisa: Value(tenderedPaisa),
        changePaisa: Value(changePaisa),
        paymentMode: Value(paymentMode),
        notes: Value(notes?.trim()),
        isVoided: const Value(false),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pending),
        isDeleted: const Value(false),
      );

      await _db.into(_db.sales).insert(saleCompanion);

      // Step 5: Insert sale items & ledger entries & decrement stock
      for (final line in lines) {
        final lineItemId = _uuid.v4();

        await _db.into(_db.saleItems).insert(
              SaleItemsCompanion.insert(
                id: lineItemId,
                saleId: saleId,
                itemId: line.itemId,
                itemName: line.itemName,
                unit: Value(line.unit),
                quantity: line.quantity,
                ratePaisa: line.ratePaisa,
                discountPaisa: Value(line.discountPaisa),
                taxablePaisa: line.taxablePaisa,
                vatPaisa: Value(line.vatPaisa),
                lineTotalPaisa: line.lineTotalPaisa,
                createdAt: Value(now),
                updatedAt: Value(now),
                syncStatus: const Value(SyncStatus.pending),
                isDeleted: const Value(false),
              ),
            );

        // Append negative stock ledger entry
        await _db.into(_db.stockLedger).insert(
              StockLedgerCompanion.insert(
                id: _uuid.v4(),
                itemId: line.itemId,
                qtyChange: -line.quantity,
                reason: 'SALE',
                refType: 'SALE',
                refId: saleId,
                notes: Value('Invoice: $invoiceNumber'),
                createdAt: Value(now),
                updatedAt: Value(now),
                syncStatus: const Value(SyncStatus.pending),
                isDeleted: const Value(false),
              ),
            );

        // Update cached item stock
        final currentItem = await (_db.select(_db.items)
              ..where((tbl) => tbl.id.equals(line.itemId)))
            .getSingle();

        final updatedStock = (currentItem.stockQty - line.quantity).clamp(0.0, 9999999.0);
        await _db.update(_db.items).replace(
              currentItem.copyWith(
                stockQty: updatedStock,
                updatedAt: now,
                syncStatus: SyncStatus.pending,
              ),
            );
      }

      return (await (_db.select(_db.sales)..where((tbl) => tbl.id.equals(saleId))).getSingle());
    });
  }

  /// Voids a sale transaction: soft deletes and reverses stock ledger in one transaction.
  Future<void> voidSale(String saleId, {String? reason}) async {
    final now = DateTime.now().toUtc();

    await _db.transaction(() async {
      final details = await getSaleDetails(saleId);
      if (details == null) throw Exception('Sale record not found');
      if (details.sale.isVoided) throw Exception('Sale invoice is already voided');

      // 1. Restore inventory stock & write reversing stock_ledger entries (+qty)
      for (final item in details.items) {
        await _db.into(_db.stockLedger).insert(
              StockLedgerCompanion.insert(
                id: _uuid.v4(),
                itemId: item.itemId,
                qtyChange: item.quantity,
                reason: 'SALE_VOID',
                refType: 'SALE',
                refId: saleId,
                notes: Value('Void Invoice ${details.sale.invoiceNumber}: ${reason ?? "Cancelled"}'),
                createdAt: Value(now),
                updatedAt: Value(now),
                syncStatus: const Value(SyncStatus.pending),
                isDeleted: const Value(false),
              ),
            );

        final currentItem = await (_db.select(_db.items)
              ..where((tbl) => tbl.id.equals(item.itemId)))
            .getSingleOrNull();

        if (currentItem != null) {
          final updatedStock = currentItem.stockQty + item.quantity;
          await _db.update(_db.items).replace(
                currentItem.copyWith(
                  stockQty: updatedStock,
                  updatedAt: now,
                  syncStatus: SyncStatus.pending,
                ),
              );
        }
      }

      // 2. Mark sale as voided and soft deleted
      await _db.update(_db.sales).replace(
            details.sale.copyWith(
              isVoided: true,
              isDeleted: true,
              updatedAt: now,
              syncStatus: SyncStatus.pending,
            ),
          );
    });
  }

  /// Computes today's sales summary for the dashboard.
  Future<DailySalesSummary> getTodaySalesSummary() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toUtc();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).toUtc();

    final todaySales = await (_db.select(_db.sales)
          ..where((tbl) =>
              tbl.isVoided.equals(false) &
              tbl.isDeleted.equals(false) &
              tbl.invoiceDate.isBiggerOrEqualValue(startOfDay) &
              tbl.invoiceDate.isSmallerOrEqualValue(endOfDay)))
        .get();

    final count = todaySales.length;
    final totalRevenue = todaySales.fold<int>(0, (sum, s) => sum + s.totalPaisa);

    // Get sale items for today to compute top sold items
    final saleIds = todaySales.map((s) => s.id).toList();
    final itemsMap = <String, Map<String, dynamic>>{};

    if (saleIds.isNotEmpty) {
      final todayItems = await (_db.select(_db.saleItems)
            ..where((tbl) => tbl.saleId.isIn(saleIds) & tbl.isDeleted.equals(false)))
          .get();

      for (final item in todayItems) {
        if (!itemsMap.containsKey(item.itemId)) {
          itemsMap[item.itemId] = {
            'name': item.itemName,
            'qty': 0.0,
            'amount': 0,
          };
        }
        itemsMap[item.itemId]!['qty'] = (itemsMap[item.itemId]!['qty'] as double) + item.quantity;
        itemsMap[item.itemId]!['amount'] =
            (itemsMap[item.itemId]!['amount'] as int) + item.lineTotalPaisa;
      }
    }

    final topItemsList = itemsMap.values
        .map((m) => TopSoldItem(
              itemName: m['name'] as String,
              totalQty: m['qty'] as double,
              totalAmountPaisa: m['amount'] as int,
            ))
        .toList()
      ..sort((a, b) => b.totalAmountPaisa.compareTo(a.totalAmountPaisa));

    return DailySalesSummary(
      totalSalesCount: count,
      totalRevenuePaisa: totalRevenue,
      topItems: topItemsList.take(3).toList(),
    );
  }

  /// Customers CRUD
  Stream<List<Customer>> watchCustomers() {
    return (_db.select(_db.customers)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.name)]))
        .watch();
  }

  Future<Customer> addCustomer({
    required String name,
    String? phone,
    String? panVat,
    String? address,
  }) async {
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    final companion = CustomersCompanion.insert(
      id: id,
      name: name.trim(),
      phone: Value(phone?.trim()),
      panVat: Value(panVat?.trim()),
      address: Value(address?.trim()),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: const Value(SyncStatus.pending),
      isDeleted: const Value(false),
    );
    await _db.into(_db.customers).insert(companion);
    return (_db.select(_db.customers)..where((tbl) => tbl.id.equals(id))).getSingle();
  }
}

