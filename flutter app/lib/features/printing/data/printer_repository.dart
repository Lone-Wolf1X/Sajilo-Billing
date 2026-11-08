import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../domain/printer_config.dart';

final printerRepositoryProvider = Provider<PrinterRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return PrinterRepository(db);
});

final printerConfigProvider = FutureProvider<PrinterConfig>((ref) async {
  final repo = ref.watch(printerRepositoryProvider);
  return repo.getConfig();
});

class PrinterRepository {
  final AppDatabase _db;

  PrinterRepository(this._db);

  /// Retrieves the saved printer configuration, seeding default if empty.
  Future<PrinterConfig> getConfig() async {
    final query = _db.select(_db.printerSettings)
      ..where((tbl) => tbl.isDeleted.equals(false))
      ..limit(1);

    final row = await query.getSingleOrNull();
    if (row != null) {
      return PrinterConfig.fromRow(row);
    }

    // Seed default
    const defaultConfig = PrinterConfig();
    await _db.into(_db.printerSettings).insert(defaultConfig.toCompanion());
    return defaultConfig;
  }

  /// Saves or updates the printer configuration.
  Future<void> saveConfig(PrinterConfig config) async {
    await _db.into(_db.printerSettings).insertOnConflictUpdate(config.toCompanion());
  }
}

