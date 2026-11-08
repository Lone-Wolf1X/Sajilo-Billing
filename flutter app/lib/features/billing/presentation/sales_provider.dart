import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/sales_repository.dart';

final salesRepositoryProvider = Provider<SalesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SalesRepository(db);
});

class SalesFilter {
  final String query;
  final DateTime? startDate;
  final DateTime? endDate;

  const SalesFilter({
    this.query = '',
    this.startDate,
    this.endDate,
  });

  SalesFilter copyWith({
    String? query,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return SalesFilter(
      query: query ?? this.query,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

final salesFilterProvider = StateProvider<SalesFilter>((ref) {
  return const SalesFilter();
});

final salesStreamProvider = StreamProvider<List<Sale>>((ref) {
  final repo = ref.watch(salesRepositoryProvider);
  final filter = ref.watch(salesFilterProvider);
  return repo.watchSales(
    query: filter.query,
    startDate: filter.startDate,
    endDate: filter.endDate,
  );
});

final customersStreamProvider = StreamProvider<List<Customer>>((ref) {
  final repo = ref.watch(salesRepositoryProvider);
  return repo.watchCustomers();
});

final todaySalesSummaryProvider = FutureProvider<DailySalesSummary>((ref) {
  final repo = ref.watch(salesRepositoryProvider);
  return repo.getTodaySalesSummary();
});

