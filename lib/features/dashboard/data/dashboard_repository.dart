import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../backup/domain/backup_service.dart';

class DashboardMetrics {
  final int todaySalesCount;
  final int todaySalesRevenuePaisa;
  final int todayPurchaseCount;
  final int todayPurchaseAmountPaisa;
  final int lowStockCount;
  final int totalItemsCount;
  final DateTime? lastBackupTime;

  const DashboardMetrics({
    required this.todaySalesCount,
    required this.todaySalesRevenuePaisa,
    required this.todayPurchaseCount,
    required this.todayPurchaseAmountPaisa,
    required this.lowStockCount,
    required this.totalItemsCount,
    this.lastBackupTime,
  });
}

class DashboardRepository {
  final AppDatabase _db;
  final BackupService _backupService;

  DashboardRepository(this._db, this._backupService);

  Future<DashboardMetrics> getDashboardMetrics() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toUtc();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).toUtc();

    // 1. Today's sales
    final todaySales = await (_db.select(_db.sales)
          ..where((tbl) =>
              tbl.isVoided.equals(false) &
              tbl.isDeleted.equals(false) &
              tbl.invoiceDate.isBiggerOrEqualValue(startOfDay) &
              tbl.invoiceDate.isSmallerOrEqualValue(endOfDay)))
        .get();

    final salesCount = todaySales.length;
    final salesRevenue = todaySales.fold<int>(0, (sum, s) => sum + s.totalPaisa);

    // 2. Today's purchases
    final todayPurchases = await (_db.select(_db.purchases)
          ..where((tbl) =>
              tbl.isReturned.equals(false) &
              tbl.isDeleted.equals(false) &
              tbl.purchaseDate.isBiggerOrEqualValue(startOfDay) &
              tbl.purchaseDate.isSmallerOrEqualValue(endOfDay)))
        .get();

    final purchaseCount = todayPurchases.length;
    final purchaseAmount = todayPurchases.fold<int>(0, (sum, p) => sum + p.totalPaisa);

    // 3. Low stock and total items
    final activeItems = await (_db.select(_db.items)
          ..where((tbl) => tbl.isDeleted.equals(false) & tbl.isActive.equals(true)))
        .get();

    final totalItems = activeItems.length;
    final lowStock = activeItems.where((i) => i.stockQty <= i.lowStockThreshold).length;

    // 4. Last backup time
    final lastBackup = await _backupService.getLastBackupTime();

    return DashboardMetrics(
      todaySalesCount: salesCount,
      todaySalesRevenuePaisa: salesRevenue,
      todayPurchaseCount: purchaseCount,
      todayPurchaseAmountPaisa: purchaseAmount,
      lowStockCount: lowStock,
      totalItemsCount: totalItems,
      lastBackupTime: lastBackup,
    );
  }
}
