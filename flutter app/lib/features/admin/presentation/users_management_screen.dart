import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/admin_users_controller.dart';
import '../data/admin_user.dart';
import 'widgets/create_user_dialog.dart';
import 'widgets/user_role_badge.dart';

class UsersManagementScreen extends ConsumerWidget {
  const UsersManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(adminUsersListProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Row(
            children: [
              const Icon(Icons.manage_accounts, color: Color(0xFF1E3A8A), size: 30),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Users & Roles Management / प्रयोगकर्ता व्यवस्थापन',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Manage Cashiers, Accountants, and Administrators for this company',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => ref.invalidate(adminUsersListProvider),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh'),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => const CreateUserDialog(),
                  );
                  if (ok == true && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('New user created successfully! / नयाँ प्रयोगकर्ता थपियो!'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.person_add, size: 18),
                label: const Text('ADD USER / प्रयोगकर्ता थप्नुहोस्'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Main Table Area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: usersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 40),
                      const SizedBox(height: 8),
                      Text('Error: $e', style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(adminUsersListProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (users) => users.isEmpty
                    ? const Center(
                        child: Text(
                          'No users found',
                          style: TextStyle(color: Color(0xFF94A3B8)),
                        ),
                      )
                    : _UsersTable(users: users),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersTable extends ConsumerWidget {
  final List<AdminUser> users;
  const _UsersTable({required this.users});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(adminUsersControllerProvider);

    return SingleChildScrollView(
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFC)),
        dataRowMinHeight: 56,
        dataRowMaxHeight: 64,
        columns: const [
          DataColumn(label: Text('USER / नाम', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          DataColumn(label: Text('ROLES / पद', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          DataColumn(label: Text('STATUS / अवस्था', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          DataColumn(label: Text('LAST LOGIN / पछिल्लो लगइन', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          DataColumn(label: Text('ACTIONS / कार्यहरू', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        ],
        rows: users.map((u) {
          return DataRow(cells: [
            DataCell(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  u.displayName,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                ),
                Text(
                  '@${u.username}  ·  ${u.email}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            )),
            DataCell(Row(
              children: u.roles
                  .map((r) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: UserRoleBadge(role: r),
                      ))
                  .toList(),
            )),
            DataCell(_statusBadge(u)),
            DataCell(Text(
              u.lastLoginAt != null ? _fmtDate(u.lastLoginAt!) : 'Never / कहिल्यै होइन',
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            )),
            DataCell(Row(
              children: [
                IconButton(
                  icon: Icon(
                    u.isActive ? Icons.block : Icons.check_circle_outline,
                    size: 18,
                    color: u.isActive ? const Color(0xFFD97706) : const Color(0xFF10B981),
                  ),
                  tooltip: u.isActive ? 'Disable User (निष्क्रिय गर्नुहोस्)' : 'Enable User (सक्रिय गर्नुहोस्)',
                  onPressed: () async {
                    try {
                      await ctrl.toggleStatus(u);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.lock_reset, size: 18, color: Color(0xFF1E3A8A)),
                  tooltip: 'Reset Password (पासवर्ड रिसेट)',
                  onPressed: () => _showResetPasswordDialog(context, ref, u),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFDC2626)),
                  tooltip: 'Delete User (हटाउनुहोस्)',
                  onPressed: () => _confirmDelete(context, ref, u),
                ),
              ],
            )),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _statusBadge(AdminUser u) {
    final active = u.isActive;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFDEF7EC) : const Color(0xFFF3F4F6),
        border: Border.all(color: active ? const Color(0xFF31C48D) : const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        u.status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: active ? const Color(0xFF03543F) : const Color(0xFF4B5563),
        ),
      ),
    );
  }

  Future<void> _showResetPasswordDialog(
      BuildContext context, WidgetRef ref, AdminUser u) async {
    final ctrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Reset Password: @${u.username}'),
        content: SizedBox(
          width: 320,
          child: TextField(
            controller: ctrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New Password',
              helperText: 'Minimum 8 characters',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.length < 8) return;
              Navigator.pop(context, true);
            },
            child: const Text('RESET'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(adminUsersControllerProvider).resetPassword(u.id, ctrl.text);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset successfully!'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, AdminUser u) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete user?'),
        content: Text(
          'This will disable user "@${u.username}" and free up their username. '
          'Historical journal entries and audit trails remain intact.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(adminUsersControllerProvider).deleteUser(u.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  String _fmtDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}

