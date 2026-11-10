import '../../../core/api/saisa_api_client.dart';
import 'admin_user.dart';

class AdminUsersRepository {
  final SaisaApiClient _api;
  AdminUsersRepository(this._api);

  Future<List<AdminUser>> listUsers() async {
    final list = await _api.get<List<dynamic>>('/admin/users');
    return list
        .map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AdminUser> createUser({
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String roleCode,
  }) async {
    final data = await _api.post<Map<String, dynamic>>('/admin/users', data: {
      'username': username,
      'email': email,
      'password': password,
      'fullName': fullName,
      'roleCode': roleCode,
    });
    return AdminUser.fromJson(data);
  }

  Future<AdminUser> updateStatus(int userId, String status) async {
    final data = await _api.put<Map<String, dynamic>>(
      '/admin/users/$userId/status',
      data: {'status': status},
    );
    return AdminUser.fromJson(data);
  }

  Future<void> resetPassword(int userId, String newPassword) async {
    await _api.post<dynamic>(
      '/admin/users/$userId/reset-password',
      data: {'newPassword': newPassword},
    );
  }

  Future<void> deleteUser(int userId) async {
    await _api.delete<dynamic>('/admin/users/$userId');
  }
}

