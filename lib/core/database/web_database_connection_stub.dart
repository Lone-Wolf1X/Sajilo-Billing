import 'package:drift/drift.dart';

QueryExecutor openWebDatabase({
  String databaseName = 'sajilo_billing_web',
  Uri? sqlite3Uri,
  Uri? driftWorkerUri,
}) {
  return LazyDatabase(() async {
    throw UnsupportedError('WebDatabase is only supported on Web platform.');
  });
}

