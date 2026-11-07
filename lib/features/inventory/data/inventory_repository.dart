import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/sync_status.dart';

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

  /// Seeds default categories, units, and retail products for quick dev setup.
  Future<void> seedDevData() async {
    final now = DateTime.now().toUtc();

    // Check if items already exist
    final existingItems = await (_db.select(_db.items)..limit(1)).get();
    if (existingItems.isNotEmpty) return;

    await _db.transaction(() async {
      // 1. Seed Units
      final defaultUnits = [
        {'name': 'Piece', 'symbol': 'pcs', 'nepali': 'थान', 'fractional': false},
        {'name': 'Kilogram', 'symbol': 'kg', 'nepali': 'केजी', 'fractional': true},
        {'name': 'Liter', 'symbol': 'ltr', 'nepali': 'लिटर', 'fractional': true},
        {'name': 'Packet', 'symbol': 'pkt', 'nepali': 'प्याकेट', 'fractional': false},
        {'name': 'Box', 'symbol': 'box', 'nepali': 'बाकस', 'fractional': false},
        {'name': 'Bag / Bora', 'symbol': 'bag', 'nepali': 'बोरा', 'fractional': false},
      ];

      for (final u in defaultUnits) {
        await _db.into(_db.units).insert(
              UnitsCompanion.insert(
                id: _uuid.v4(),
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
      }

      // 2. Seed Categories
      final catGrainsId = _uuid.v4();
      final catOilsId = _uuid.v4();
      final catSnacksId = _uuid.v4();
      final catSpicesId = _uuid.v4();

      await _db.into(_db.categories).insert(
            CategoriesCompanion.insert(
              id: catGrainsId,
              name: 'Rice, Grains & Pulses',
              nepaliName: const Value('चामल, अन्न तथा दाल'),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatus.pending),
              isDeleted: const Value(false),
            ),
          );
      await _db.into(_db.categories).insert(
            CategoriesCompanion.insert(
              id: catOilsId,
              name: 'Cooking Oils & Ghee',
              nepaliName: const Value('खाने तेल तथा घ्यु'),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatus.pending),
              isDeleted: const Value(false),
            ),
          );
      await _db.into(_db.categories).insert(
            CategoriesCompanion.insert(
              id: catSnacksId,
              name: 'Snacks & Noodles',
              nepaliName: const Value('खाजा तथा चाउचाउ'),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatus.pending),
              isDeleted: const Value(false),
            ),
          );
      await _db.into(_db.categories).insert(
            CategoriesCompanion.insert(
              id: catSpicesId,
              name: 'Spices & Salt',
              nepaliName: const Value('मसला तथा नुन'),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatus.pending),
              isDeleted: const Value(false),
            ),
          );

      // 3. Seed Items
      final sampleItems = [
        {
          'name': 'Basmati Rice 25kg',
          'nepali': 'बासमती चामल २५ केजी',
          'sku': 'RICE-BAS-25',
          'catId': catGrainsId,
          'unit': 'bag',
          'cost': 235000, // Rs. 2,350.00
          'price': 255000, // Rs. 2,550.00
          'stock': 25.0,
          'threshold': 5.0,
        },
        {
          'name': 'Mustard Oil 1L (Toriko Tel)',
          'nepali': 'तोरीको तेल १ लिटर',
          'sku': 'OIL-MUS-1L',
          'catId': catOilsId,
          'unit': 'ltr',
          'cost': 21000, // Rs. 210.00
          'price': 24500, // Rs. 245.00
          'stock': 40.0,
          'threshold': 8.0,
        },
        {
          'name': 'Sunflower Cooking Oil 1L',
          'nepali': 'सूर्यमुखी तेल १ लिटर',
          'sku': 'OIL-SUN-1L',
          'catId': catOilsId,
          'unit': 'ltr',
          'cost': 19500, // Rs. 195.00
          'price': 22500, // Rs. 225.00
          'stock': 35.0,
          'threshold': 6.0,
        },
        {
          'name': 'Tata Iodized Salt 1kg',
          'nepali': 'टाटा आयोडिन नुन १ केजी',
          'sku': 'SALT-TATA-1',
          'catId': catSpicesId,
          'unit': 'pkt',
          'cost': 2300, // Rs. 23.00
          'price': 2800, // Rs. 28.00
          'stock': 120.0,
          'threshold': 20.0,
        },
        {
          'name': 'Wai Wai Noodles (Carton 30pcs)',
          'nepali': 'वाइ वाइ चाउचाउ कार्टुन',
          'sku': 'WW-NDL-CTN',
          'catId': catSnacksId,
          'unit': 'box',
          'cost': 56000, // Rs. 560.00
          'price': 63000, // Rs. 630.00
          'stock': 18.0,
          'threshold': 4.0,
        },
        {
          'name': 'Red Lentils / Musuro Daal 1kg',
          'nepali': 'मुसुरो दाल १ केजी',
          'sku': 'DAL-MUS-1KG',
          'catId': catGrainsId,
          'unit': 'kg',
          'cost': 14000, // Rs. 140.00
          'price': 16500, // Rs. 165.00
          'stock': 3.0, // Low stock trigger!
          'threshold': 10.0,
        },
      ];

      for (final item in sampleItems) {
        final itemId = _uuid.v4();
        final stock = item['stock'] as double;

        await _db.into(_db.items).insert(
              ItemsCompanion.insert(
                id: itemId,
                name: item['name'] as String,
                nepaliName: Value(item['nepali'] as String),
                sku: item['sku'] as String,
                categoryId: Value(item['catId'] as String),
                unit: Value(item['unit'] as String),
                purchasePricePaisa: Value(item['cost'] as int),
                sellingPricePaisa: Value(item['price'] as int),
                stockQty: Value(stock),
                lowStockThreshold: Value(item['threshold'] as double),
                isActive: const Value(true),
                createdAt: Value(now),
                updatedAt: Value(now),
                syncStatus: const Value(SyncStatus.pending),
                isDeleted: const Value(false),
              ),
            );

        // Opening ledger entry
        await _db.into(_db.stockLedger).insert(
              StockLedgerCompanion.insert(
                id: _uuid.v4(),
                itemId: itemId,
                qtyChange: stock,
                reason: 'INITIAL_STOCK',
                refType: 'INITIAL_STOCK',
                refId: itemId,
                notes: const Value('Opening Stock on seeding'),
                createdAt: Value(now),
                updatedAt: Value(now),
                syncStatus: const Value(SyncStatus.pending),
                isDeleted: const Value(false),
              ),
            );
      }
    });
  }
}
