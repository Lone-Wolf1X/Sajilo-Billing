import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Resolves the canonical file location for the SQLite database on desktop/native.
Future<File> getDatabaseFile() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'SajiloBilling', 'sajilo_billing.sqlite'));
  if (!await file.parent.exists()) {
    await file.parent.create(recursive: true);
  }
  return file;
}

/// Opens the background native SQLite database for desktop platforms.
QueryExecutor openAppConnection() {
  return LazyDatabase(() async {
    final file = await getDatabaseFile();
    return NativeDatabase.createInBackground(file);
  });
}
