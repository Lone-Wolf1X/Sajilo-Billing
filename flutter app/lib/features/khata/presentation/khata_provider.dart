import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/khata_repository.dart';
import '../domain/khata_models.dart';

/// Provider for the Khata repository instance.
final khataRepositoryProvider = Provider<KhataRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return KhataRepository(db);
});

/// Overall receivables and payables metrics for the store.
final khataOverallMetricsProvider = StreamProvider.autoDispose<OverallKhataMetrics>((ref) {
  final repo = ref.watch(khataRepositoryProvider);
  return repo.watchOverallMetrics();
});

/// Search query state for customer khata.
final customerKhataSearchProvider = StateProvider<String>((ref) => '');

/// Filter state: only show customers with pending credit dues.
final customerKhataOnlyDuesProvider = StateProvider<bool>((ref) => false);

/// Real-time stream of customer khata entries.
final customerKhataStreamProvider = StreamProvider.autoDispose<List<PartySummary>>((ref) {
  final repo = ref.watch(khataRepositoryProvider);
  final search = ref.watch(customerKhataSearchProvider);
  final onlyDues = ref.watch(customerKhataOnlyDuesProvider);

  return repo.watchCustomerSummaries(
    searchQuery: search,
    onlyWithDues: onlyDues,
  );
});

/// Search query state for supplier khata.
final supplierKhataSearchProvider = StateProvider<String>((ref) => '');

/// Filter state: only show suppliers with pending payable dues.
final supplierKhataOnlyDuesProvider = StateProvider<bool>((ref) => false);

/// Real-time stream of supplier khata entries.
final supplierKhataStreamProvider = StreamProvider.autoDispose<List<PartySummary>>((ref) {
  final repo = ref.watch(khataRepositoryProvider);
  final search = ref.watch(supplierKhataSearchProvider);
  final onlyDues = ref.watch(supplierKhataOnlyDuesProvider);

  return repo.watchSupplierSummaries(
    searchQuery: search,
    onlyWithDues: onlyDues,
  );
});

/// Stream of detailed ledger transactions for a specific party.
final partyLedgerStreamProvider =
    StreamProvider.autoDispose.family<List<PartyLedgerData>, String>((ref, partyId) {
  final repo = ref.watch(khataRepositoryProvider);
  return repo.watchPartyLedger(partyId);
});

