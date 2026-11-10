import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api/saisa_api_client.dart';
import 'database/app_database.dart';
import 'database/database_provider.dart';
import 'errors/api_exception.dart';
import 'storage/token_storage.dart';
import 'sync/sync_queue_service.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/domain/auth_models.dart';
import '../features/customers/data/customers_repository.dart';
import '../features/customers/data/saisa_customer.dart';
import '../features/inventory/data/items_repository.dart';
import '../features/inventory/data/saisa_item.dart';
import '../features/inventory/data/saisa_warehouse.dart';
import '../features/inventory/data/warehouses_repository.dart';
import '../features/purchase/data/saisa_vendor.dart';
import '../features/purchase/data/vendors_repository.dart';
import '../features/billing/data/pos_invoice_repository.dart';
import '../features/billing/application/pos_billing_service.dart';

/// Token storage — singleton
final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

/// API client — singleton, wired to expire session on refresh failure
final apiClientProvider = Provider<SaisaApiClient>((ref) {
  final storage = ref.read(tokenStorageProvider);
  final client = SaisaApiClient(tokenStorage: storage);
  // When refresh fails, invalidate auth state
  client.onSessionExpired = () {
    ref.read(authStateProvider.notifier).markLoggedOut();
  };
  return client;
});

/// Auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    api: ref.read(apiClientProvider),
    storage: ref.read(tokenStorageProvider),
  );
});

/// Auth state — async because of restore-on-start
final authStateProvider = AsyncNotifierProvider<AuthNotifier, AuthUser?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<AuthUser?> {
  @override
  Future<AuthUser?> build() async {
    return ref.read(authRepositoryProvider).restoreSession();
  }

  Future<void> login({
    required String tenantCode,
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).login(
            tenantCode: tenantCode,
            username: username,
            password: password,
          );
      state = AsyncData(user);
    } on ApiException catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }

  void markLoggedOut() {
    state = const AsyncData(null);
  }
}

// ================= Phase 2A Providers =================

/// Items repository
final itemsRepositoryProvider = Provider<ItemsRepository>((ref) {
  return ItemsRepository(ref.read(apiClientProvider));
});

/// Items list — auto-fetched after login
final itemsListProvider = FutureProvider.autoDispose<List<SaisaItem>>((ref) async {
  final auth = ref.watch(authStateProvider);
  if (auth.valueOrNull == null) return <SaisaItem>[];
  return ref.read(itemsRepositoryProvider).listItems();
});

/// Customers repository
final customersRepositoryProvider = Provider<CustomersRepository>((ref) {
  return CustomersRepository(ref.read(apiClientProvider));
});

/// Customers list
final customersListProvider = FutureProvider.autoDispose<List<SaisaCustomer>>((ref) async {
  final auth = ref.watch(authStateProvider);
  if (auth.valueOrNull == null) return <SaisaCustomer>[];
  return ref.read(customersRepositoryProvider).listCustomers();
});

/// Warehouses repository
final warehousesRepositoryProvider = Provider<WarehousesRepository>((ref) {
  return WarehousesRepository(ref.read(apiClientProvider));
});

/// Warehouses list
final warehousesListProvider = FutureProvider.autoDispose<List<SaisaWarehouse>>((ref) async {
  final auth = ref.watch(authStateProvider);
  if (auth.valueOrNull == null) return <SaisaWarehouse>[];
  return ref.read(warehousesRepositoryProvider).listWarehouses();
});

/// Sync queue service — using Drift AppDatabase from databaseProvider
final syncQueueServiceProvider = Provider<SyncQueueService>((ref) {
  return SyncQueueService(
    api: ref.read(apiClientProvider),
    db: ref.read(databaseProvider),
  );
});

/// Sync queue pending count — for header badge
final pendingSyncCountProvider = FutureProvider.autoDispose<int>((ref) async {
  return ref.read(syncQueueServiceProvider).pendingCount();
});

/// POS Invoice repository
final posInvoiceRepositoryProvider = Provider<PosInvoiceRepository>((ref) {
  return PosInvoiceRepository(ref.read(apiClientProvider));
});

/// POS Billing service
final posBillingServiceProvider = Provider<PosBillingService>((ref) {
  return PosBillingService(
    invoiceRepo: ref.read(posInvoiceRepositoryProvider),
    syncQueue: ref.read(syncQueueServiceProvider),
  );
});

/// Vendors repository
final vendorsRepositoryProvider = Provider<VendorsRepository>((ref) {
  return VendorsRepository(api: ref.read(apiClientProvider));
});

/// Vendors list
final vendorsListProvider = FutureProvider.autoDispose<List<SaisaVendor>>((ref) async {
  final auth = ref.watch(authStateProvider);
  if (auth.valueOrNull == null) return <SaisaVendor>[];
  return ref.read(vendorsRepositoryProvider).listVendors();
});

/// Sync queue items list — for queue viewer
final syncQueueItemsProvider = FutureProvider.autoDispose<List<SyncQueueItem>>((ref) async {
  return ref.read(syncQueueServiceProvider).getRecentItems();
});
