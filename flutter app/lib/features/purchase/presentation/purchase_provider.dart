import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/purchase_repository.dart';

final purchaseRepositoryProvider = Provider<PurchaseRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return PurchaseRepository(db);
});

class PurchaseFilter {
  final String query;
  final String? supplierId;
  final DateTime? startDate;
  final DateTime? endDate;

  const PurchaseFilter({
    this.query = '',
    this.supplierId,
    this.startDate,
    this.endDate,
  });

  PurchaseFilter copyWith({
    String? query,
    String? supplierId,
    DateTime? startDate,
    DateTime? endDate,
    bool clearSupplier = false,
  }) {
    return PurchaseFilter(
      query: query ?? this.query,
      supplierId: clearSupplier ? null : (supplierId ?? this.supplierId),
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

final purchaseFilterProvider = StateProvider<PurchaseFilter>((ref) {
  return const PurchaseFilter();
});

final purchasesStreamProvider = StreamProvider<List<Purchase>>((ref) {
  final repo = ref.watch(purchaseRepositoryProvider);
  final filter = ref.watch(purchaseFilterProvider);
  return repo.watchPurchases(
    query: filter.query,
    supplierId: filter.supplierId,
    startDate: filter.startDate,
    endDate: filter.endDate,
  );
});

final suppliersStreamProvider = StreamProvider<List<Supplier>>((ref) {
  final repo = ref.watch(purchaseRepositoryProvider);
  return repo.watchSuppliers();
});

