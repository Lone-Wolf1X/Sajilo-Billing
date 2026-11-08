import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/sync_status.dart';
import '../../../core/utils/paisa_helper.dart';

class ProductImportRow {
  final String name;
  final String? nepaliName;
  final String sku;
  final String? category;
  final String unit;
  final double purchasePrice;
  final double sellingPrice;
  final double stockQty;
  final double lowStockThreshold;

  ProductImportRow({
    required this.name,
    this.nepaliName,
    required this.sku,
    this.category,
    this.unit = 'pcs',
    this.purchasePrice = 0.0,
    required this.sellingPrice,
    this.stockQty = 0.0,
    this.lowStockThreshold = 5.0,
  });
}

class ImportResult {
  final int totalRows;
  final int insertedCount;
  final int updatedCount;
  final int failedCount;
  final List<String> errors;

  ImportResult({
    required this.totalRows,
    required this.insertedCount,
    required this.updatedCount,
    required this.failedCount,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;
}

class InventoryImportExportService {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  InventoryImportExportService(this._db);

  /// Standard column headers for import templates
  static const List<String> templateHeaders = [
    'Item Name*',
    'Nepali Name',
    'SKU / Barcode*',
    'Category',
    'Unit',
    'Cost Price (Rs)*',
    'Selling Price (Rs)*',
    'Opening Stock',
    'Low Stock Alert',
  ];

  /// Sample demo rows included in the downloadable template
  static const List<List<dynamic>> sampleRows = [
    ['Casio Watch Standard', 'क्यासियो घडी', 'SKU-5001', 'Watches', 'pcs', 1500.0, 2200.0, 10.0, 3.0],
    ['Wireless Bluetooth Mouse', 'वायरलेस माउस', 'SKU-5002', 'Electronics', 'pcs', 450.0, 750.0, 15.0, 5.0],
    ['Basmati Rice (25kg Bag)', 'बासमती चामल', 'SKU-5003', 'Groceries', 'bag', 2200.0, 2650.0, 20.0, 5.0],
    ['Ballpoint Pen Box (20pcs)', 'डटपेन बक्स', 'SKU-5004', 'Stationery', 'box', 180.0, 280.0, 30.0, 10.0],
  ];

  /// Generates CSV template as UTF-8 string with BOM for Excel compatibility.
  String generateCsvTemplate() {
    final rows = [
      templateHeaders,
      ...sampleRows,
    ];
    return const ListToCsvConverter().convert(rows);
  }

  /// Generates Excel (.xlsx) binary bytes with formatted sheet.
  Uint8List generateExcelTemplate() {
    final excel = Excel.createExcel();
    final sheet = excel['Products Template'];
    excel.setDefaultSheet('Products Template');

    // Header row
    sheet.appendRow(templateHeaders.map((h) => TextCellValue(h)).toList());

    // Sample data rows
    for (final row in sampleRows) {
      sheet.appendRow([
        TextCellValue(row[0].toString()),
        TextCellValue(row[1]?.toString() ?? ''),
        TextCellValue(row[2].toString()),
        TextCellValue(row[3]?.toString() ?? ''),
        TextCellValue(row[4].toString()),
        DoubleCellValue((row[5] as num).toDouble()),
        DoubleCellValue((row[6] as num).toDouble()),
        DoubleCellValue((row[7] as num).toDouble()),
        DoubleCellValue((row[8] as num).toDouble()),
      ]);
    }

    // Auto-fit column widths
    for (int i = 0; i < templateHeaders.length; i++) {
      sheet.setColumnWidth(i, 22.0);
    }

    final bytes = excel.save();
    return Uint8List.fromList(bytes ?? []);
  }

  /// Downloads/exports template file to local drive or browser.
  Future<String?> downloadTemplate({required bool isExcel}) async {
    final fileName = isExcel ? 'sajilo_products_template.xlsx' : 'sajilo_products_template.csv';
    final Uint8List bytes = isExcel
        ? generateExcelTemplate()
        : Uint8List.fromList(utf8.encode('\uFEFF${generateCsvTemplate()}')); // UTF-8 BOM for Excel

    final location = await getSaveLocation(
      suggestedName: fileName,
      acceptedTypeGroups: [
        if (isExcel)
          const XTypeGroup(label: 'Excel Document', extensions: ['xlsx'])
        else
          const XTypeGroup(label: 'CSV Document', extensions: ['csv']),
      ],
    );

    if (location == null) return null;

    final xfile = XFile.fromData(bytes, name: fileName);
    await xfile.saveTo(location.path);
    return location.path;
  }

  /// Parses CSV file bytes into structured import rows.
  List<ProductImportRow> parseCsv(Uint8List bytes) {
    String content;
    try {
      content = utf8.decode(bytes);
    } catch (_) {
      content = latin1.decode(bytes);
    }

    // Strip BOM if present
    if (content.startsWith('\uFEFF')) {
      content = content.substring(1);
    }

    // Normalize all line endings (CRLF, CR, LF) to standard LF
    content = content.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    final rawRows = const CsvToListConverter(eol: '\n', shouldParseNumbers: false).convert(content);
    if (rawRows.isEmpty) return [];

    final headers = rawRows.first.map((e) => e.toString().trim().toLowerCase()).toList();
    final dataRows = rawRows.skip(1);

    return _mapRowsToObjects(headers, dataRows);
  }

  /// Parses Excel (.xlsx) binary bytes into structured import rows.
  List<ProductImportRow> parseExcel(Uint8List bytes) {
    final excel = Excel.decodeBytes(bytes);
    if (excel.tables.isEmpty) return [];

    final sheetName = excel.tables.keys.first;
    final sheet = excel.tables[sheetName];
    if (sheet == null || sheet.rows.isEmpty) return [];

    final headerRow = sheet.rows.first;
    final headers = headerRow.map((cell) => cell?.value?.toString().trim().toLowerCase() ?? '').toList();

    final dataRows = sheet.rows.skip(1).map((row) {
      return row.map((cell) => cell?.value?.toString().trim() ?? '').toList();
    });

    return _mapRowsToObjects(headers, dataRows);
  }

  List<ProductImportRow> _mapRowsToObjects(List<String> headers, Iterable<List<dynamic>> rows) {
    int findIndex(List<String> candidates) {
      for (final c in candidates) {
        final idx = headers.indexWhere((h) => h.contains(c));
        if (idx != -1) return idx;
      }
      return -1;
    }

    final nameIdx = findIndex(['item name', 'product name', 'name', 'सामान', 'नाम']);
    final nepaliIdx = findIndex(['nepali', 'नेपाली']);
    final skuIdx = findIndex(['sku', 'code', 'barcode', 'कोड']);
    final catIdx = findIndex(['category', 'वर्ग', 'समूह']);
    final unitIdx = findIndex(['unit', 'इकाई']);
    final costIdx = findIndex(['cost', 'purchase', 'खरिद']);
    final priceIdx = findIndex(['selling', 'sale', 'mrp', 'price', 'दर', 'बिक्री']);
    final stockIdx = findIndex(['stock', 'opening', 'qty', 'quantity', 'मौज्दात']);
    final alertIdx = findIndex(['low', 'alert', 'threshold', 'न्यून']);

    final items = <ProductImportRow>[];
    int autoSkuIndex = 1;

    for (final row in rows) {
      if (row.isEmpty) continue;

      String getVal(int idx) {
        if (idx == -1 || idx >= row.length) return '';
        return row[idx]?.toString().trim() ?? '';
      }

      final name = getVal(nameIdx != -1 ? nameIdx : 0);
      if (name.isEmpty) continue; // Skip empty row

      final nepaliName = nepaliIdx != -1 ? getVal(nepaliIdx) : null;
      var sku = skuIdx != -1 ? getVal(skuIdx) : '';
      if (sku.isEmpty) {
        sku = 'AUTO-${DateTime.now().millisecondsSinceEpoch % 100000}-$autoSkuIndex';
        autoSkuIndex++;
      }

      final category = catIdx != -1 ? getVal(catIdx) : null;
      final unit = unitIdx != -1 && getVal(unitIdx).isNotEmpty ? getVal(unitIdx).toLowerCase() : 'pcs';

      final cost = double.tryParse(getVal(costIdx).replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      final price = double.tryParse(getVal(priceIdx).replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      final stock = double.tryParse(getVal(stockIdx).replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      final alert = double.tryParse(getVal(alertIdx).replaceAll(RegExp(r'[^0-9.]'), '')) ?? 5.0;

      items.add(ProductImportRow(
        name: name,
        nepaliName: nepaliName?.isEmpty == true ? null : nepaliName,
        sku: sku,
        category: category?.isEmpty == true ? null : category,
        unit: unit,
        purchasePrice: cost,
        sellingPrice: price > 0 ? price : cost,
        stockQty: stock,
        lowStockThreshold: alert,
      ));
    }

    return items;
  }

  /// Inserts or updates parsed products into Drift database.
  Future<ImportResult> importRows(List<ProductImportRow> rows) async {
    final now = DateTime.now().toUtc();
    int inserted = 0;
    int updated = 0;
    int failed = 0;
    final errors = <String>[];

    await _db.transaction(() async {
      // 1. Fetch or create Categories
      final existingCategories = await _db.select(_db.categories).get();
      final categoryMap = {for (final c in existingCategories) c.name.toLowerCase(): c.id};

      for (final r in rows) {
        try {
          String? categoryId;
          if (r.category != null && r.category!.isNotEmpty) {
            final catLower = r.category!.toLowerCase();
            if (categoryMap.containsKey(catLower)) {
              categoryId = categoryMap[catLower];
            } else {
              final newCatId = _uuid.v4();
              await _db.into(_db.categories).insert(
                    CategoriesCompanion.insert(
                      id: newCatId,
                      name: r.category!,
                      createdAt: Value(now),
                      updatedAt: Value(now),
                      syncStatus: const Value(SyncStatus.pending),
                      isDeleted: const Value(false),
                    ),
                  );
              categoryMap[catLower] = newCatId;
              categoryId = newCatId;
            }
          }

          // 2. Check if product with this SKU already exists
          final existing = await (_db.select(_db.items)
                ..where((tbl) => tbl.sku.equals(r.sku) & tbl.isDeleted.equals(false)))
              .getSingleOrNull();

          final purchasePaisa = PaisaHelper.toPaisa(r.purchasePrice);
          final sellingPaisa = PaisaHelper.toPaisa(r.sellingPrice);

          if (existing != null) {
            // Update existing product
            await (_db.update(_db.items)..where((tbl) => tbl.id.equals(existing.id))).write(
              ItemsCompanion(
                name: Value(r.name),
                nepaliName: Value(r.nepaliName),
                categoryId: Value(categoryId ?? existing.categoryId),
                unit: Value(r.unit),
                purchasePricePaisa: Value(purchasePaisa),
                sellingPricePaisa: Value(sellingPaisa),
                lowStockThreshold: Value(r.lowStockThreshold),
                updatedAt: Value(now),
                syncStatus: const Value(SyncStatus.pending),
              ),
            );
            updated++;
          } else {
            // Insert new product
            final itemId = _uuid.v4();
            await _db.into(_db.items).insert(
                  ItemsCompanion.insert(
                    id: itemId,
                    name: r.name,
                    nepaliName: Value(r.nepaliName),
                    sku: r.sku,
                    categoryId: Value(categoryId),
                    unit: Value(r.unit),
                    purchasePricePaisa: Value(purchasePaisa),
                    sellingPricePaisa: Value(sellingPaisa),
                    stockQty: Value(r.stockQty),
                    lowStockThreshold: Value(r.lowStockThreshold),
                    isActive: const Value(true),
                    createdAt: Value(now),
                    updatedAt: Value(now),
                    syncStatus: const Value(SyncStatus.pending),
                    isDeleted: const Value(false),
                  ),
                );

            // Record initial stock in ledger
            if (r.stockQty > 0) {
              await _db.into(_db.stockLedger).insert(
                    StockLedgerCompanion.insert(
                      id: _uuid.v4(),
                      itemId: itemId,
                      qtyChange: r.stockQty,
                      reason: 'INITIAL_STOCK',
                      refType: 'CSV_IMPORT',
                      refId: itemId,
                      notes: const Value('Opening stock from CSV/Excel import'),
                      createdAt: Value(now),
                      updatedAt: Value(now),
                      syncStatus: const Value(SyncStatus.pending),
                      isDeleted: const Value(false),
                    ),
                  );
            }
            inserted++;
          }
        } catch (e) {
          failed++;
          errors.add('${r.name} (${r.sku}): $e');
        }
      }
    });

    return ImportResult(
      totalRows: rows.length,
      insertedCount: inserted,
      updatedCount: updated,
      failedCount: failed,
      errors: errors,
    );
  }
}
