import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api/saisa_api_client.dart';
import 'errors/api_exception.dart';
import 'storage/token_storage.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/domain/auth_models.dart';

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
