import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';

final allAccountsListProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final api = ref.read(apiClientProvider);
  final list = await api.get<List<dynamic>>('/accounts');
  return list.cast<Map<String, dynamic>>().toList();
});

class ChartOfAccountsScreen extends ConsumerStatefulWidget {
  const ChartOfAccountsScreen({super.key});

  @override
  ConsumerState<ChartOfAccountsScreen> createState() => _ChartOfAccountsScreenState();
}

class _ChartOfAccountsScreenState extends ConsumerState<ChartOfAccountsScreen> {
  String _selectedCategory = 'ALL';

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(allAccountsListProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.account_tree, color: Color(0xFF1E3A8A), size: 28),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chart of Accounts / खाता सूची',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'General ledger master accounts for double-entry bookkeeping (Assets, Liabilities, Equity, Revenue, Expense)',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => ref.invalidate(allAccountsListProvider),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh'),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => const _NewAccountDialog(),
                  );
                  if (ok == true) {
                    ref.invalidate(allAccountsListProvider);
                  }
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('NEW ACCOUNT / नयाँ खाता'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Category filter pills
          Row(
            children: [
              _filterChip('ALL', 'All Accounts (सबै)'),
              const SizedBox(width: 8),
              _filterChip('ASSET', 'Assets (सम्पत्ति)'),
              const SizedBox(width: 8),
              _filterChip('LIABILITY', 'Liabilities (दायित्व)'),
              const SizedBox(width: 8),
              _filterChip('EQUITY', 'Equity (पूँजी)'),
              const SizedBox(width: 8),
              _filterChip('REVENUE', 'Revenue (आम्दानी)'),
              const SizedBox(width: 8),
              _filterChip('EXPENSE', 'Expense (खर्च)'),
            ],
          ),
          const SizedBox(height: 16),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: accountsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text('Error loading accounts: $e', style: const TextStyle(color: Colors.red)),
                ),
                data: (accounts) {
                  final filtered = _selectedCategory == 'ALL'
                      ? accounts
                      : accounts.where((a) => a['accountType'] == _selectedCategory).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text('No accounts in this category', style: TextStyle(color: Color(0xFF94A3B8))),
                    );
                  }

                  return SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFC)),
                      columns: const [
                        DataColumn(label: Text('CODE', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('ACCOUNT NAME / खाताको नाम', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('TYPE / प्रकृति', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: filtered.map((a) {
                        final type = a['accountType'] as String? ?? '';
                        final active = a['active'] as bool? ?? true;
                        return DataRow(cells: [
                          DataCell(Text(
                            a['accountCode'] as String? ?? '',
                            style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
                          )),
                          DataCell(Text(a['accountName'] as String? ?? '')),
                          DataCell(_typeBadge(type)),
                          DataCell(Text(
                            active ? 'ACTIVE' : 'INACTIVE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: active ? const Color(0xFF10B981) : Colors.grey,
                            ),
                          )),
                        ]);
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String category, String label) {
    final selected = _selectedCategory == category;
    return ChoiceChip(
      selected: selected,
      label: Text(label, style: TextStyle(fontSize: 12, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
      selectedColor: const Color(0xFF1E3A8A).withOpacity(0.12),
      onSelected: (_) => setState(() => _selectedCategory = category),
    );
  }

  Widget _typeBadge(String type) {
    Color color;
    switch (type) {
      case 'ASSET':
        color = const Color(0xFF2563EB);
        break;
      case 'LIABILITY':
        color = const Color(0xFFD97706);
        break;
      case 'EQUITY':
        color = const Color(0xFF7C3AED);
        break;
      case 'REVENUE':
        color = const Color(0xFF059669);
        break;
      case 'EXPENSE':
      default:
        color = const Color(0xFFDC2626);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}

class _NewAccountDialog extends ConsumerStatefulWidget {
  const _NewAccountDialog();

  @override
  ConsumerState<_NewAccountDialog> createState() => _NewAccountDialogState();
}

class _NewAccountDialogState extends ConsumerState<_NewAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _name = TextEditingController();
  String _type = 'ASSET';
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final api = ref.read(apiClientProvider);
      await api.post<Map<String, dynamic>>('/accounts', data: {
        'accountCode': _code.text.trim().toUpperCase(),
        'accountName': _name.text.trim(),
        'accountType': _type,
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text('Add Account / नयाँ खाता थप्नुहोस्', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                ),
              TextFormField(
                controller: _code,
                decoration: const InputDecoration(
                  labelText: 'Account Code *',
                  hintText: 'e.g. 1010 or PETTY_CASH',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Account Name *',
                  hintText: 'e.g. Petty Cash Vault',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(
                  labelText: 'Account Category *',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: const [
                  DropdownMenuItem(value: 'ASSET', child: Text('ASSET (सम्पत्ति)')),
                  DropdownMenuItem(value: 'LIABILITY', child: Text('LIABILITY (दायित्व)')),
                  DropdownMenuItem(value: 'EQUITY', child: Text('EQUITY (पूँजी)')),
                  DropdownMenuItem(value: 'REVENUE', child: Text('REVENUE (आम्दानी)')),
                  DropdownMenuItem(value: 'EXPENSE', child: Text('EXPENSE (खर्च)')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'ASSET'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
        ElevatedButton(
          onPressed: _saving ? null : _submit,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white),
          child: _saving ? const Text('SAVING…') : const Text('CREATE'),
        ),
      ],
    );
  }
}
