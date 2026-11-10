import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import 'widgets/bank_account_form_dialog.dart';

class BankAccountsScreen extends ConsumerWidget {
  const BankAccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banksAsync = ref.watch(bankAccountsListProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance, color: Color(0xFF1E3A8A), size: 28),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bank Accounts / बैंक खाताहरू',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Manage company bank accounts for payments, receipts and bank transfers',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => ref.invalidate(bankAccountsListProvider),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh'),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => const BankAccountFormDialog(),
                  );
                  if (ok == true) {
                    ref.invalidate(bankAccountsListProvider);
                  }
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('NEW BANK ACCOUNT / नयाँ बैंक खाता'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: banksAsync.when(
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
                        onPressed: () => ref.invalidate(bankAccountsListProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (banks) => banks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.account_balance_outlined, size: 48, color: Color(0xFF94A3B8)),
                            const SizedBox(height: 12),
                            const Text(
                              'No bank accounts configured yet',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Add your business bank account to record bank receipts and cheques.',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async {
                                final ok = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => const BankAccountFormDialog(),
                                );
                                if (ok == true) {
                                  ref.invalidate(bankAccountsListProvider);
                                }
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white),
                              child: const Text('+ Add First Bank Account'),
                            ),
                          ],
                        ),
                      )
                    : _BankTable(banks: banks),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BankTable extends ConsumerWidget {
  final List<Map<String, dynamic>> banks;
  const _BankTable({required this.banks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFC)),
        dataRowMinHeight: 52,
        dataRowMaxHeight: 60,
        columns: const [
          DataColumn(label: Text('CODE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          DataColumn(label: Text('ACCOUNT NAME', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          DataColumn(label: Text('BANK NAME', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          DataColumn(label: Text('ACCOUNT NO.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          DataColumn(label: Text('BRANCH / SWIFT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          DataColumn(label: Text('DEFAULT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        ],
        rows: banks.map((m) {
          final id = (m['id'] as num).toInt();
          final isDef = (m['defaultAccount'] ?? m['isDefault']) as bool? ?? false;
          return DataRow(cells: [
            DataCell(Text(
              m['accountCode'] as String? ?? '',
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold),
            )),
            DataCell(Text(
              m['accountName'] as String? ?? '',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            )),
            DataCell(Text(m['bankName'] as String? ?? '—', style: const TextStyle(fontSize: 12))),
            DataCell(Text(
              m['accountNumber'] as String? ?? '—',
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            )),
            DataCell(Text(
              m['ifscCode'] as String? ?? '—',
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            )),
            DataCell(isDef
                ? const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18)
                : const SizedBox.shrink()),
            DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 18, color: Color(0xFF1E3A8A)),
                  tooltip: 'Edit (सम्पादन)',
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => BankAccountFormDialog(existing: m),
                    );
                    if (ok == true) ref.invalidate(bankAccountsListProvider);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.block, size: 18, color: Color(0xFFDC2626)),
                  tooltip: 'Deactivate (निष्क्रिय गर्नुहोस्)',
                  onPressed: () => _confirmDeactivate(
                    context,
                    ref,
                    id,
                    m['accountName'] as String? ?? '',
                  ),
                ),
              ],
            )),
          ]);
        }).toList(),
      ),
    );
  }

  Future<void> _confirmDeactivate(BuildContext context, WidgetRef ref, int id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Deactivate Bank Account?'),
        content: Text(
          'The bank account "$name" will be marked inactive. '
          'Historical journal entries and payments remain intact.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
            child: const Text('DEACTIVATE'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final api = ref.read(apiClientProvider);
        await api.delete<dynamic>('/bank-accounts/$id');
        ref.invalidate(bankAccountsListProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bank account deactivated'),
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
}

