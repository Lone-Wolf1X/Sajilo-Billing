import 'package:drift/drift.dart';
import 'app_database_connection.dart' as db_conn;

import 'sync_status.dart';
import 'tables/business_profiles_table.dart';
import 'tables/categories_table.dart';
import 'tables/units_table.dart';
import 'tables/items_table.dart';
import 'tables/inventories_table.dart';
import 'tables/suppliers_table.dart';
import 'tables/customers_table.dart';
import 'tables/stock_ledger_table.dart';
import 'tables/stock_adjustments_table.dart';
import 'tables/purchases_table.dart';
import 'tables/purchase_items_table.dart';
import 'tables/sales_table.dart';
import 'tables/sale_items_table.dart';
import 'tables/bill_metadata_table.dart';
import 'tables/bill_sequence_table.dart';
import 'tables/backup_logs_table.dart';
import 'tables/party_ledger_table.dart';
import 'tables/party_payments_table.dart';
import 'tables/local_auth_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  BusinessProfiles,
  Categories,
  Units,
  Items,
  Inventories,
  Suppliers,
  Customers,
  StockLedger,
  StockAdjustments,
  Purchases,
  PurchaseItems,
  Sales,
  SaleItems,
  BillMetadata,
  BillSequence,
  BackupLogs,
  PartyLedger,
  PartyPayments,
  LocalAuth,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? db_conn.openAppConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(categories);
            await m.createTable(units);
            await m.createTable(items);
            await m.createTable(suppliers);
            await m.createTable(customers);
            await m.createTable(stockLedger);
            await m.createTable(stockAdjustments);
            await m.createTable(purchaseItems);
            await m.createTable(billSequence);

            try {
              await m.addColumn(businessProfiles, businessProfiles.isDeleted);
            } catch (_) {}

            try {
              await m.addColumn(billMetadata, billMetadata.isDeleted);
            } catch (_) {}
          }
          if (from < 3) {
            await m.createTable(backupLogs);
          }
          if (from < 4) {
            await m.createTable(partyLedger);
            await m.createTable(partyPayments);
          }
          if (from < 5) {
            await m.createTable(localAuth);
            try {
              await m.addColumn(businessProfiles, businessProfiles.businessNameNepali);
            } catch (_) {}
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          try {
            await customStatement('PRAGMA journal_mode = WAL');
          } catch (_) {}
        },
      );

  /// Resolves the canonical file location for the SQLite database.
  /// On desktop, returns File. On Web, throws UnsupportedError.
  static Future<dynamic> getDatabaseFile() => db_conn.getDatabaseFile();
}
