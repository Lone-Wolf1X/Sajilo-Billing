import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/sync_status.dart';

class PurchaseLineInput {
  final String itemId;
  final String itemName;
  final String unit;
  final double quantity;
  final int ratePaisa;
  final int discountPaisa;
  final bool isVatApplicable;

  const PurchaseLineInput({
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

class PurchaseWithItems {
  final Purchase purchase;
  final List<PurchaseItem> items;
  final Supplier? supplier;

  PurchaseWithItems({
    required this.purchase,
    required this.items,
    this.supplier,
  });
}

class PurchaseRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  PurchaseRepository(this._db);

  /// Streams purchases with optional date filter and search query.
  Stream<List<Purchase>> watchPurchases({
    DateTime? startDate,
    DateTime? endDate,
    String? supplierId,
    String? query,
  }) {
    final q = _db.select(_db.purchases)
      ..where((tbl) => tbl.isDeleted.equals(false));

    if (supplierId != null && supplierId.isNotEmpty) {
      q.where((tbl) => tbl.supplierId.equals(supplierId));
    }

    if (startDate != null) {
      q.where((tbl) => tbl.purchaseDate.isBiggerOrEqualValue(startDate.toUtc()));
    }

    if (endDate != null) {
      q.where((tbl) => tbl.purchaseDate.isSmallerOrEqualValue(endDate.toUtc()));
    }

    if (query != null && query.trim().isNotEmpty) {
      final clean = '%${query.trim().toLowerCase()}%';
      q.where((tbl) =>
          tbl.supplierName.lower().like(clean) |
          tbl.billNumber.lower().like(clean));
    }

    q.orderBy([(tbl) => OrderingTerm(expression: tbl.purchaseDate, mode: OrderingMode.desc)]);
    return q.watch();
  }

  /// Gets purchase details with all line items and supplier.
  Future<PurchaseWithItems?> getPurchaseDetails(String purchaseId) async {
    final purchase = await (_db.select(_db.purchases)
          ..where((tbl) => tbl.id.equals(purchaseId)))
        .getSingleOrNull();

    if (purchase == null) return null;

    final items = await (_db.select(_db.purchaseItems)
          ..where((tbl) => tbl.purchaseId.equals(purchaseId) & tbl.isDeleted.equals(false)))
        .get();

    Supplier? supplier;
    if (purchase.supplierId != null) {
      supplier = await (_db.select(_db.suppliers)
            ..where((tbl) => tbl.id.equals(purchase.supplierId!)))
          .getSingleOrNull();
    }

    return PurchaseWithItems(purchase: purchase, items: items, supplier: supplier);
  }

  /// Creates a complete purchase record in ONE single atomic Drift transaction:
  /// 1. Inserts into purchases table
  /// 2. Inserts all line items into purchase_items table
  /// 3. Appends (+qty) entries into stock_ledger table
  /// 4. Updates cached stockQty on items table
  Future<Purchase> createPurchase({
    String? supplierId,
    required String supplierName,
    String? supplierPan,
    String? billNumber,
    DateTime? purchaseDate,
    required List<PurchaseLineInput> lines,
    String? remarks,
  }) async {
    if (lines.isEmpty) {
      throw Exception('Purchase must contain at least one line item');
    }

    final now = DateTime.now().toUtc();
    final pDate = (purchaseDate ?? DateTime.now()).toUtc();
    final purchaseId = _uuid.v4();

    var subtotalPaisa = 0;
    var discountPaisa = 0;
    var taxablePaisa = 0;
    var vatPaisa = 0;
    var totalPaisa = 0;

    for (final line in lines) {
      subtotalPaisa += line.grossPaisa;
      discountPaisa += line.discountPaisa;
      taxablePaisa += line.taxablePaisa;
      vatPaisa += line.vatPaisa;
      totalPaisa += line.lineTotalPaisa;
    }

    return await _db.transaction(() async {
      // 1. Insert header
      final purchaseCompanion = PurchasesCompanion.insert(
        id: purchaseId,
        supplierId: Value(supplierId),
        supplierName: supplierName.trim(),
        supplierPan: Value(supplierPan?.trim()),
        billNumber: Value(billNumber?.trim()),
        purchaseDate: Value(pDate),
        subtotalPaisa: Value(subtotalPaisa),
        discountPaisa: Value(discountPaisa),
        taxablePaisa: Value(taxablePaisa),
        vatPaisa: Value(vatPaisa),
        totalPaisa: Value(totalPaisa),
        remarks: Value(remarks?.trim()),
        isReturned: const Value(false),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pending),
        isDeleted: const Value(false),
      );

      await _db.into(_db.purchases).insert(purchaseCompanion);

      // 2. Insert line items & stock ledger & update item stock cache
      for (final line in lines) {
        final lineItemId = _uuid.v4();

        await _db.into(_db.purchaseItems).insert(
              PurchaseItemsCompanion.insert(
                id: lineItemId,
                purchaseId: purchaseId,
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

        // Append to stock ledger (+qty)
        await _db.into(_db.stockLedger).insert(
              StockLedgerCompanion.insert(
                id: _uuid.v4(),
                itemId: line.itemId,
                qtyChange: line.quantity,
                reason: 'PURCHASE',
                refType: 'PURCHASE',
                refId: purchaseId,
                notes: Value('Purchase Bill: ${billNumber ?? purchaseId}'),
                createdAt: Value(now),
                updatedAt: Value(now),
                syncStatus: const Value(SyncStatus.pending),
                isDeleted: const Value(false),
              ),
            );

        // Update cached item stock and purchase price
        final currentItem = await (_db.select(_db.items)
              ..where((tbl) => tbl.id.equals(line.itemId)))
            .getSingleOrNull();

        if (currentItem != null) {
          final updatedStock = currentItem.stockQty + line.quantity;
          await _db.update(_db.items).replace(
                currentItem.copyWith(
                  stockQty: updatedStock,
                  purchasePricePaisa: line.ratePaisa, // update latest cost
                  updatedAt: now,
                  syncStatus: SyncStatus.pending,
                ),
              );
        }
      }

      return (await (_db.select(_db.purchases)
            ..where((tbl) => tbl.id.equals(purchaseId)))
          .getSingle());
    });
  }

  /// Purchase return: records negative ledger entries and marks purchase as returned.
  Future<void> returnPurchase(String purchaseId, {String? reason}) async {
    final now = DateTime.now().toUtc();

    await _db.transaction(() async {
      final details = await getPurchaseDetails(purchaseId);
      if (details == null) throw Exception('Purchase not found');
      if (details.purchase.isReturned) throw Exception('Purchase is already marked returned');

      for (final item in details.items) {
        // 1. Negative stock ledger entry
        await _db.into(_db.stockLedger).insert(
              StockLedgerCompanion.insert(
                id: _uuid.v4(),
                itemId: item.itemId,
                qtyChange: -item.quantity,
                reason: 'PURCHASE_RETURN',
                refType: 'PURCHASE',
                refId: purchaseId,
                notes: Value(reason ?? 'Purchase Return / Vendor Return'),
                createdAt: Value(now),
                updatedAt: Value(now),
                syncStatus: const Value(SyncStatus.pending),
                isDeleted: const Value(false),
              ),
            );

        // 2. Decrement cached stock
        final currentItem = await (_db.select(_db.items)
              ..where((tbl) => tbl.id.equals(item.itemId)))
            .getSingleOrNull();

        if (currentItem != null) {
          final updatedStock = (currentItem.stockQty - item.quantity).clamp(0.0, 9999999.0);
          await _db.update(_db.items).replace(
                currentItem.copyWith(
                  stockQty: updatedStock,
                  updatedAt: now,
                  syncStatus: SyncStatus.pending,
                ),
              );
        }
      }

      // Mark purchase returned
      await _db.update(_db.purchases).replace(
            details.purchase.copyWith(
              isReturned: true,
              updatedAt: now,
              syncStatus: SyncStatus.pending,
            ),
          );
    });
  }

  /// Suppliers CRUD
  Stream<List<Supplier>> watchSuppliers() {
    return (_db.select(_db.suppliers)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.name)]))
        .watch();
  }

  Future<Supplier> addSupplier({
    required String name,
    String? phone,
    String? panVat,
    String? address,
    String? contactPerson,
  }) async {
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    final companion = SuppliersCompanion.insert(
      id: id,
      name: name.trim(),
      phone: Value(phone?.trim()),
      panVat: Value(panVat?.trim()),
      address: Value(address?.trim()),
      contactPerson: Value(contactPerson?.trim()),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: const Value(SyncStatus.pending),
      isDeleted: const Value(false),
    );
    await _db.into(_db.suppliers).insert(companion);
    return (_db.select(_db.suppliers)..where((tbl) => tbl.id.equals(id))).getSingle();
  }
}

