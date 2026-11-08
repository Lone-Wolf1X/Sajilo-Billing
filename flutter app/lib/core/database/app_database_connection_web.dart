import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Opens the WASM-backed SQLite database on Flutter Web using IndexedDB or OPFS.
QueryExecutor openAppConnection() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'sajilo_billing_web',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}

/// Throws UnsupportedError because filesystems are sandboxed in the browser.
Future<dynamic> getDatabaseFile() async {
  throw UnsupportedError('Database file is not accessible as a filesystem File on Flutter Web.');
}
