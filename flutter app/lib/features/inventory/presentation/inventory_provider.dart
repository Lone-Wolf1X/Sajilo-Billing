import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/inventory_repository.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return InventoryRepository(db);
});

/// Filter state for inventory list
class InventoryFilter {
  final String searchQuery;
  final String? categoryId;
  final bool lowStockOnly;

  const InventoryFilter({
    this.searchQuery = '',
    this.categoryId,
    this.lowStockOnly = false,
  });

  InventoryFilter copyWith({
    String? searchQuery,
    String? categoryId,
    bool? lowStockOnly,
    bool clearCategory = false,
  }) {
    return InventoryFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      lowStockOnly: lowStockOnly ?? this.lowStockOnly,
    );
  }
}

final inventoryFilterProvider = StateProvider<InventoryFilter>((ref) {
  return const InventoryFilter();
});

final itemsStreamProvider = StreamProvider<List<Item>>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  final filter = ref.watch(inventoryFilterProvider);
  return repo.watchItems(
    searchQuery: filter.searchQuery,
    categoryId: filter.categoryId,
    lowStockOnly: filter.lowStockOnly,
  );
});

final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return repo.watchCategories();
});

final unitsStreamProvider = StreamProvider<List<Unit>>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return repo.watchUnits();
});
