import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../data/admin_user.dart';
import '../data/admin_users_repository.dart';

final adminUsersRepositoryProvider = Provider<AdminUsersRepository>((ref) {
  return AdminUsersRepository(ref.read(apiClientProvider));
});

final adminUsersListProvider =
    FutureProvider.autoDispose<List<AdminUser>>((ref) {
  final auth = ref.watch(authStateProvider);
  if (auth.valueOrNull == null || !auth.valueOrNull!.isAdmin) {
    return Future.value(<AdminUser>[]);
  }
  return ref.read(adminUsersRepositoryProvider).listUsers();
});

class AdminUsersController {
  final AdminUsersRepository _repo;
  final Ref _ref;
  AdminUsersController(this._repo, this._ref);

  Future<AdminUser> createUser({
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String roleCode,
  }) async {
    final u = await _repo.createUser(
      username: username,
      email: email,
      password: password,
      fullName: fullName,
      roleCode: roleCode,
    );
    _ref.invalidate(adminUsersListProvider);
    return u;
  }

  Future<void> toggleStatus(AdminUser user) async {
    final newStatus = user.isActive ? 'DISABLED' : 'ACTIVE';
    await _repo.updateStatus(user.id, newStatus);
    _ref.invalidate(adminUsersListProvider);
  }

  Future<void> resetPassword(int userId, String newPassword) async {
    await _repo.resetPassword(userId, newPassword);
  }

  Future<void> deleteUser(int userId) async {
    await _repo.deleteUser(userId);
    _ref.invalidate(adminUsersListProvider);
  }
}

final adminUsersControllerProvider = Provider<AdminUsersController>((ref) {
  return AdminUsersController(ref.read(adminUsersRepositoryProvider), ref);
});

