import 'package:drift/drift.dart';
import 'web_database_connection_stub.dart'
    if (dart.library.html) 'web_database_connection_impl.dart' as impl;

/// Factory for creating web-compatible Drift database connections using WebAssembly.
class WebDatabase {
  /// Opens a WASM-backed database connection on Web.
  static QueryExecutor open({
    String databaseName = 'sajilo_billing_web',
    Uri? sqlite3Uri,
    Uri? driftWorkerUri,
  }) {
    return impl.openWebDatabase(
      databaseName: databaseName,
      sqlite3Uri: sqlite3Uri,
      driftWorkerUri: driftWorkerUri,
    );
  }
}
