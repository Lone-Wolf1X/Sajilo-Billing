import 'package:drift/drift.dart';

import 'app_database_connection_io.dart'
    if (dart.library.html) 'app_database_connection_web.dart' as impl;

/// Opens the platform-appropriate Drift QueryExecutor.
/// On desktop/native: Uses SQLite via NativeDatabase in background thread.
/// On web: Uses WasmDatabase with sqlite3.wasm and drift_worker.js.
QueryExecutor openAppConnection() => impl.openAppConnection();

/// Platform-agnostic accessor to database file (returns File on IO, throws UnsupportedError on Web).
Future<dynamic> getDatabaseFile() => impl.getDatabaseFile();
