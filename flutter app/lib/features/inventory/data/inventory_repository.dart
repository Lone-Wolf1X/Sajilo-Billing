import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/sync_status.dart';
import 'default_products_data.dart';

class InventoryRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  InventoryRepository(this._db);

  /// Streams active (non-deleted) items with optional filtering by query, category, or low stock.
  Stream<List<Item>> watchItems({
    String? searchQuery,
    String? categoryId,
    bool lowStockOnly = false,
  }) {
    final query = _db.select(_db.items)
      ..where((tbl) => tbl.isDeleted.equals(false) & tbl.isActive.equals(true));

    if (categoryId != null && categoryId.isNotEmpty) {
      query.where((tbl) => tbl.categoryId.equals(categoryId));
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final clean = '%${searchQuery.trim().toLowerCase()}%';
      query.where((tbl) =>
          tbl.name.lower().like(clean) |
          tbl.nepaliName.lower().like(clean) |
          tbl.sku.lower().like(clean));
    }

    if (lowStockOnly) {
      query.where((tbl) => tbl.stockQty.isSmallerOrEqual(tbl.lowStockThreshold));
    }

    query.orderBy([(tbl) => OrderingTerm(expression: tbl.name)]);
    return query.watch();
  }

  /// Gets a single item by ID.
  Future<Item?> getItem(String id) {
    return (_db.select(_db.items)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// Gets a single item by SKU/barcode.
  Future<Item?> getItemBySku(String sku) {
    return (_db.select(_db.items)
          ..where((tbl) => tbl.sku.equals(sku) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  /// Adds a new product item.
  Future<Item> addItem({
    required String name,
    String? nepaliName,
    required String sku,
    String? categoryId,
    String unit = 'pcs',
    required int purchasePricePaisa,
    required int sellingPricePaisa,
    double initialStock = 0.0,
    double lowStockThreshold = 5.0,
  }) async {
    final now = DateTime.now().toUtc();
    final itemId = _uuid.v4();

    return await _db.transaction(() async {
      final companion = ItemsCompanion.insert(
        id: itemId,
        name: name.trim(),
        nepaliName: Value(nepaliName?.trim().isEmpty == true ? null : nepaliName?.trim()),
        sku: sku.trim(),
        categoryId: Value(categoryId),
        unit: Value(unit),
        purchasePricePaisa: Value(purchasePricePaisa),
        sellingPricePaisa: Value(sellingPricePaisa),
        stockQty: Value(initialStock),
        lowStockThreshold: Value(lowStockThreshold),
        isActive: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pending),
        isDeleted: const Value(false),
      );

      await _db.into(_db.items).insert(companion);

      // If initial stock was provided, write initial stock ledger entry
      if (initialStock > 0) {
        await _db.into(_db.stockLedger).insert(
              StockLedgerCompanion.insert(
                id: _uuid.v4(),
                itemId: itemId,
                qtyChange: initialStock,
                reason: 'INITIAL_STOCK',
                refType: 'INITIAL_STOCK',
                refId: itemId,
                notes: const Value('Opening Stock on creation'),
                createdAt: Value(now),
                updatedAt: Value(now),
                syncStatus: const Value(SyncStatus.pending),
                isDeleted: const Value(false),
              ),
            );
      }

      return (await getItem(itemId))!;
    });
  }

  /// Updates item details (prices, names, category, threshold).
  /// Note: stock quantity is NOT editable here — stock changes only via ledger!
  Future<void> updateItem({
    required String id,
    required String name,
    String? nepaliName,
    required String sku,
    String? categoryId,
    required String unit,
    required int purchasePricePaisa,
    required int sellingPricePaisa,
    required double lowStockThreshold,
    bool isActive = true,
  }) async {
    final existing = await getItem(id);
    if (existing == null) throw Exception('Item not found: $id');

    final updated = existing.copyWith(
      name: name.trim(),
      nepaliName: Value(nepaliName?.trim().isEmpty == true ? null : nepaliName?.trim()),
      sku: sku.trim(),
      categoryId: Value(categoryId),
      unit: unit,
      purchasePricePaisa: purchasePricePaisa,
      sellingPricePaisa: sellingPricePaisa,
      lowStockThreshold: lowStockThreshold,
      isActive: isActive,
      updatedAt: DateTime.now().toUtc(),
      syncStatus: SyncStatus.pending,
    );

    await _db.update(_db.items).replace(updated);
  }

  /// Soft deletes an item. Sets isDeleted = true and syncStatus = pending.
  Future<void> deleteItem(String id) async {
    final existing = await getItem(id);
    if (existing == null) return;

    final updated = existing.copyWith(
      isDeleted: true,
      updatedAt: DateTime.now().toUtc(),
      syncStatus: SyncStatus.pending,
    );

    await _db.update(_db.items).replace(updated);
  }

  /// Audited stock adjustment in a single Drift transaction.
  /// Updates stock_qty cache and appends to stock_adjustments and stock_ledger.
  Future<void> adjustStock({
    required String itemId,
    required double newQty,
    required String reason,
    String? notes,
  }) async {
    final now = DateTime.now().toUtc();
    final adjustmentId = _uuid.v4();

    await _db.transaction(() async {
      final existing = await getItem(itemId);
      if (existing == null) throw Exception('Item not found: $itemId');

      final previousQty = existing.stockQty;
      final qtyChange = newQty - previousQty;

      // 1. Insert into stock_adjustments
      await _db.into(_db.stockAdjustments).insert(
            StockAdjustmentsCompanion.insert(
              id: adjustmentId,
              itemId: itemId,
              previousQty: previousQty,
              adjustmentQty: qtyChange,
              newQty: newQty,
              reason: reason.trim(),
              notes: Value(notes?.trim()),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatus.pending),
              isDeleted: const Value(false),
            ),
          );

      // 2. Insert into stock_ledger (source of truth)
      await _db.into(_db.stockLedger).insert(
            StockLedgerCompanion.insert(
              id: _uuid.v4(),
              itemId: itemId,
              qtyChange: qtyChange,
              reason: 'ADJUSTMENT',
              refType: 'STOCK_ADJUSTMENT',
              refId: adjustmentId,
              notes: Value(notes != null ? '$reason: $notes' : reason),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatus.pending),
              isDeleted: const Value(false),
            ),
          );

      // 3. Update cached stockQty on Items table
      final updatedItem = existing.copyWith(
        stockQty: newQty,
        updatedAt: now,
        syncStatus: SyncStatus.pending,
      );
      await _db.update(_db.items).replace(updatedItem);
    });
  }

  /// Streams categories.
  Stream<List<Category>> watchCategories() {
    return (_db.select(_db.categories)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.name)]))
        .watch();
  }

  /// Adds a category.
  Future<Category> addCategory({
    required String name,
    String? nepaliName,
    String? description,
  }) async {
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    final comp = CategoriesCompanion.insert(
      id: id,
      name: name.trim(),
      nepaliName: Value(nepaliName?.trim()),
      description: Value(description?.trim()),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: const Value(SyncStatus.pending),
      isDeleted: const Value(false),
    );
    await _db.into(_db.categories).insert(comp);
    return (_db.select(_db.categories)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  /// Streams units.
  Stream<List<Unit>> watchUnits() {
    return (_db.select(_db.units)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.name)]))
        .watch();
  }

  /// Adds a unit.
  Future<Unit> addUnit({
    required String name,
    required String symbol,
    String? nepaliSymbol,
    bool isFractional = false,
  }) async {
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    final comp = UnitsCompanion.insert(
      id: id,
      name: name.trim(),
      symbol: symbol.trim(),
      nepaliSymbol: Value(nepaliSymbol?.trim()),
      isFractional: Value(isFractional),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: const Value(SyncStatus.pending),
      isDeleted: const Value(false),
    );
    await _db.into(_db.units).insert(comp);
    return (_db.select(_db.units)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  /// Imports products catalog from JSON string (supports products.json structure).
  /// Returns the number of items successfully processed.
  Future<int> importProductsFromJson(String jsonContent) async {
    final Map<String, dynamic> parsed = json.decode(jsonContent) as Map<String, dynamic>;
    final shopName = parsed['shopName'] as String? ?? 'Electronics & Watch Center';
    final productList = parsed['products'] as List<dynamic>? ?? [];

    final now = DateTime.now().toUtc();

    return await _db.transaction(() async {
      // 1. Ensure business profile exists if none configured
      final profileCount = await (_db.selectOnly(_db.businessProfiles)
            ..addColumns([_db.businessProfiles.id.count()]))
          .getSingle();
      final hasProfile = (profileCount.read(_db.businessProfiles.id.count()) ?? 0) > 0;
      if (!hasProfile) {
        await _db.into(_db.businessProfiles).insert(
              BusinessProfilesCompanion.insert(
                id: _uuid.v4(),
                businessName: shopName,
                businessNameNepali: const Value('इलेक्ट्रोनिक्स एण्ड वाच सेन्टर'),
                panVatNumber: '601234567',
                contactNumber: '9841234567',
                shopAddress: const Value('New Road, Kathmandu'),
                isCurrent: const Value(true),
                createdAt: Value(now),
                updatedAt: Value(now),
                syncStatus: const Value(SyncStatus.pending),
              ),
            );
      }

      // 2. Ensure default units exist
      final existingUnits = await _db.select(_db.units).get();
      final unitMap = {for (final u in existingUnits) u.symbol.toLowerCase(): u.id};

      final standardUnits = [
        {'name': 'Piece', 'symbol': 'pcs', 'nepali': 'थान', 'fractional': false},
        {'name': 'Service', 'symbol': 'service', 'nepali': 'सेवा', 'fractional': false},
        {'name': 'Kilogram', 'symbol': 'kg', 'nepali': 'केजी', 'fractional': true},
        {'name': 'Liter', 'symbol': 'ltr', 'nepali': 'लिटर', 'fractional': true},
        {'name': 'Packet', 'symbol': 'pkt', 'nepali': 'प्याकेट', 'fractional': false},
        {'name': 'Box', 'symbol': 'box', 'nepali': 'बाकस', 'fractional': false},
      ];

      for (final u in standardUnits) {
        final sym = (u['symbol'] as String).toLowerCase();
        if (!unitMap.containsKey(sym)) {
          final id = _uuid.v4();
          await _db.into(_db.units).insert(
                UnitsCompanion.insert(
                  id: id,
                  name: u['name'] as String,
                  symbol: u['symbol'] as String,
                  nepaliSymbol: Value(u['nepali'] as String),
                  isFractional: Value(u['fractional'] as bool),
                  createdAt: Value(now),
                  updatedAt: Value(now),
                  syncStatus: const Value(SyncStatus.pending),
                  isDeleted: const Value(false),
                ),
              );
          unitMap[sym] = id;
        }
      }

      // 3. Ensure categories from JSON exist
      final existingCats = await _db.select(_db.categories).get();
      final catMap = {for (final c in existingCats) c.name.toLowerCase(): c.id};

      const categoryNepaliTranslations = {
        'watches': 'घडीहरू',
        'electronics': 'इलेक्ट्रोनिक्स',
        'mobile phones': 'मोबाइल फोन',
        'mobile accessories': 'मोबाइल सामानहरू',
        'mobile parts': 'मोबाइल पार्टपुर्जा',
        'storage accessories': 'मेमोरी तथा स्टोरेज',
        'radios': 'रेडियो',
        'radio parts': 'रेडियो पार्टपुर्जा',
        'watch parts': 'घडी पार्टपुर्जा',
        'watch repair': 'घडी मर्मत',
        'torches': 'टर्च / बत्ती',
      };

      for (final raw in productList) {
        final catName = (raw['category'] as String? ?? 'General').trim();
        final catKey = catName.toLowerCase();
        if (!catMap.containsKey(catKey)) {
          final catId = _uuid.v4();
          final nepali = categoryNepaliTranslations[catKey] ?? catName;
          await _db.into(_db.categories).insert(
                CategoriesCompanion.insert(
                  id: catId,
                  name: catName,
                  nepaliName: Value(nepali),
                  createdAt: Value(now),
                  updatedAt: Value(now),
                  syncStatus: const Value(SyncStatus.pending),
                  isDeleted: const Value(false),
                ),
              );
          catMap[catKey] = catId;
        }
      }

      // 4. Insert items and stock ledger
      int count = 0;
      for (final raw in productList) {
        final id = raw['id'];
        final name = (raw['productName'] as String).trim();
        final catName = (raw['category'] as String? ?? 'General').trim();
        final catId = catMap[catName.toLowerCase()];
        final priceNum = (raw['price'] as num?) ?? 0;
        final qtyNum = (raw['quantity'] as num?) ?? 0;
        final rawUnit = (raw['unit'] as String? ?? 'piece').toLowerCase().trim();
        final unitSymbol = (rawUnit == 'piece') ? 'pcs' : rawUnit;

        final sku = 'SKU-${id.toString().padLeft(4, '0')}';
        final sellingPaisa = (priceNum * 100).round();
        final purchasePaisa = (priceNum * 0.75 * 100).round();
        final initialStock = qtyNum.toDouble();

        final existing = await (_db.select(_db.items)
              ..where((tbl) => tbl.sku.equals(sku) & tbl.isDeleted.equals(false)))
            .getSingleOrNull();

        if (existing == null) {
          final itemId = _uuid.v4();
          await _db.into(_db.items).insert(
                ItemsCompanion.insert(
                  id: itemId,
                  name: name,
                  sku: sku,
                  categoryId: Value(catId),
                  unit: Value(unitSymbol),
                  purchasePricePaisa: Value(purchasePaisa),
                  sellingPricePaisa: Value(sellingPaisa),
                  stockQty: Value(initialStock),
                  lowStockThreshold: const Value(3.0),
                  isActive: const Value(true),
                  createdAt: Value(now),
                  updatedAt: Value(now),
                  syncStatus: const Value(SyncStatus.pending),
                  isDeleted: const Value(false),
                ),
              );

          if (initialStock > 0) {
            await _db.into(_db.stockLedger).insert(
                  StockLedgerCompanion.insert(
                    id: _uuid.v4(),
                    itemId: itemId,
                    qtyChange: initialStock,
                    reason: 'INITIAL_STOCK',
                    refType: 'INITIAL_STOCK',
                    refId: itemId,
                    notes: const Value('Opening stock from products.json'),
                    createdAt: Value(now),
                    updatedAt: Value(now),
                    syncStatus: const Value(SyncStatus.pending),
                    isDeleted: const Value(false),
                  ),
                );
          }
        }
        count++;
      }

      return count;
    });
  }

  /// Seeds demo data using products.json catalog if items table is empty.
  Future<void> seedDevData({String? jsonOverride}) async {
    final existingItems = await (_db.select(_db.items)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..limit(1))
        .get();
    if (existingItems.isNotEmpty) return;

    final content = jsonOverride ?? bundledProductsJson;
    await importProductsFromJson(content);
  }
}
