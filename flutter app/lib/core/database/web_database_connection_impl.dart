import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

QueryExecutor openWebDatabase({
  String databaseName = 'sajilo_billing_web',
  Uri? sqlite3Uri,
  Uri? driftWorkerUri,
}) {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: databaseName,
      sqlite3Uri: sqlite3Uri ?? Uri.parse('sqlite3.wasm'),
      driftWorkerUri: driftWorkerUri ?? Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}

