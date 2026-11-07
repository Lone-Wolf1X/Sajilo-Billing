import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

/// Global provider for the Drift AppDatabase instance.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
