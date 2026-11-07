import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/sync_status.dart';

class InventoryRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  InventoryRepository(this._db);

  /// Streams active inventory products ordered by name.
  Stream<List<Inventory>> watchActiveInventories() {
    return (_db.select(_db.inventories)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.name)]))
        .watch();
  }

  /// Searches products by name or SKU.
  Future<List<Inventory>> searchInventories(String query) async {
    final cleanQuery = '%${query.trim().toLowerCase()}%';
    return (_db.select(_db.inventories)
          ..where((tbl) =>
              tbl.isActive.equals(true) &
              (tbl.name.lower().like(cleanQuery) |
                  tbl.sku.lower().like(cleanQuery)))
          ..limit(25))
        .get();
  }

  /// Inserts a new product into inventory.
  Future<Inventory> addInventoryItem({
    required String name,
    String? sku,
    String unit = 'pcs',
    required double unitPrice,
    double costPrice = 0.0,
    double stockQuantity = 0.0,
  }) async {
    final now = DateTime.now();
    final companion = InventoriesCompanion.insert(
      id: _uuid.v4(),
      name: name.trim(),
      sku: Value(sku?.trim().isEmpty == true ? null : sku?.trim()),
      unit: Value(unit),
      unitPrice: Value(unitPrice),
      costPrice: Value(costPrice),
      stockQuantity: Value(stockQuantity),
      isActive: const Value(true),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: const Value(SyncStatus.pending),
    );

    final id = await _db.into(_db.inventories).insert(companion);
    return (_db.select(_db.inventories)..where((tbl) => tbl.rowId.equals(id))).getSingle();
  }

  /// Updates an existing product.
  Future<void> updateInventoryItem({
    required String id,
    required String name,
    String? sku,
    required String unit,
    required double unitPrice,
    required double costPrice,
    required double stockQuantity,
  }) async {
    final existing = await (_db.select(_db.inventories)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (existing == null) return;

    final updated = existing.copyWith(
      name: name.trim(),
      sku: Value(sku?.trim().isEmpty == true ? null : sku?.trim()),
      unit: unit,
      unitPrice: unitPrice,
      costPrice: costPrice,
      stockQuantity: stockQuantity,
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );

    await _db.update(_db.inventories).replace(updated);
  }

  /// Soft deletes an inventory item.
  Future<void> deleteInventoryItem(String id) async {
    final existing = await (_db.select(_db.inventories)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (existing == null) return;

    final updated = existing.copyWith(
      isActive: false,
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );

    await _db.update(_db.inventories).replace(updated);
  }

  /// Updates stock level by a delta (+ for purchase/return, - for sales).
  Future<void> adjustStock(String id, double quantityDelta) async {
    final existing = await (_db.select(_db.inventories)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (existing == null) return;

    final updatedStock = (existing.stockQuantity + quantityDelta).clamp(0.0, 9999999.0);
    final updated = existing.copyWith(
      stockQuantity: updatedStock,
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );

    await _db.update(_db.inventories).replace(updated);
  }

  /// Seeds sample Nepali grocery / retail products for quick testing.
  Future<void> seedDefaultNepaliProducts() async {
    final sampleItems = [
      {'name': 'Basmati Rice 25kg (बासमती चामल)', 'sku': 'RICE-BAS-25', 'unit': 'bag', 'price': 2550.0, 'cost': 2300.0, 'qty': 20.0},
      {'name': 'Mustard Cooking Oil (तोरीको तेल १ लि.)', 'sku': 'OIL-MUS-1L', 'unit': 'ltr', 'price': 240.0, 'cost': 210.0, 'qty': 50.0},
      {'name': 'Sunflower Oil 1L (सूर्यमुखी तेल)', 'sku': 'OIL-SUN-1L', 'unit': 'ltr', 'price': 225.0, 'cost': 195.0, 'qty': 45.0},
      {'name': 'Tata Salt 1kg (आयोडिनयुक्त नुन)', 'sku': 'SALT-TATA-1', 'unit': 'pkt', 'price': 28.0, 'cost': 23.0, 'qty': 100.0},
      {'name': 'Sugar 1kg (चिनी)', 'sku': 'SUGAR-1KG', 'unit': 'kg', 'price': 105.0, 'cost': 92.0, 'qty': 80.0},
      {'name': 'Wai Wai Noodles (चाउचाउ कार्टुन)', 'sku': 'WW-NDL-CTN', 'unit': 'box', 'price': 620.0, 'cost': 560.0, 'qty': 15.0},
      {'name': 'Tokla CTC Tea 500g (टोकला चियापत्ती)', 'sku': 'TEA-TOK-500', 'unit': 'pkt', 'price': 285.0, 'cost': 245.0, 'qty': 30.0},
      {'name': 'Red Lentils / Musuro Daal (मुसुरो दाल १ केजी)', 'sku': 'DAL-MUS-1KG', 'unit': 'kg', 'price': 165.0, 'cost': 140.0, 'qty': 40.0},
      {'name': 'Dettol Soap 75g (साबुन)', 'sku': 'DET-SOAP-75', 'unit': 'pcs', 'price': 55.0, 'cost': 45.0, 'qty': 60.0},
    ];

    for (final item in sampleItems) {
      await addInventoryItem(
        name: item['name'] as String,
        sku: item['sku'] as String,
        unit: item['unit'] as String,
        unitPrice: item['price'] as double,
        costPrice: item['cost'] as double,
        stockQuantity: item['qty'] as double,
      );
    }
  }
}

