import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'sync_status.dart';
import 'tables/business_profiles_table.dart';
import 'tables/inventories_table.dart';
import 'tables/sales_table.dart';
import 'tables/sale_items_table.dart';
import 'tables/purchases_table.dart';
import 'tables/bill_metadata_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  BusinessProfiles,
  Inventories,
  Sales,
  SaleItems,
  Purchases,
  BillMetadata,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Schema migrations for future versions will be handled here
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await customStatement('PRAGMA journal_mode = WAL');
        },
      );

  /// Resolves the canonical file location for the SQLite database.
  /// Uses path_provider exclusively without hardcoding OS directories.
  static Future<File> getDatabaseFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'SajiloBilling', 'sajilo_billing.sqlite'));
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    return file;
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final file = await getDatabaseFile();
      return NativeDatabase.createInBackground(file);
    });
  }
}

