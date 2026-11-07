import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/inventory_repository.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return InventoryRepository(db);
});

final inventoriesStreamProvider = StreamProvider<List<Inventory>>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return repo.watchActiveInventories();
});

