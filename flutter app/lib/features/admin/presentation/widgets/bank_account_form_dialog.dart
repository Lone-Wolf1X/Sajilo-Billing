import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/providers.dart';

class BankAccountFormDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic>? existing; // null for create, non-null for edit
  const BankAccountFormDialog({super.key, this.existing});

  @override
  ConsumerState<BankAccountFormDialog> createState() => _BankAccountFormDialogState();
}

class _BankAccountFormDialogState extends ConsumerState<BankAccountFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _accountCode = TextEditingController();
  final _accountName = TextEditingController();
  final _bankName = TextEditingController();
  final _accountNumber = TextEditingController();
  final _ifscCode = TextEditingController();
  int? _glAccountId;
  bool _isDefault = false;
  bool _submitting = false;
  String? _error;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final e = widget.existing!;
      _accountCode.text = e['accountCode'] as String? ?? '';
      _accountName.text = e['accountName'] as String? ?? '';
      _bankName.text = e['bankName'] as String? ?? '';
      _accountNumber.text = e['accountNumber'] as String? ?? '';
      _ifscCode.text = e['ifscCode'] as String? ?? '';
      _glAccountId = (e['glAccountId'] as num?)?.toInt();
      _isDefault = (e['defaultAccount'] ?? e['isDefault']) as bool? ?? false;
    }
  }

  @override
  void dispose() {
    for (final c in [_accountCode, _accountName, _bankName, _accountNumber, _ifscCode]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_glAccountId == null) {
      setState(() => _error = 'Please select a linked GL asset account');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final api = ref.read(apiClientProvider);
      if (_isEdit) {
        await api.put<Map<String, dynamic>>(
          '/bank-accounts/${widget.existing!['id']}',
          data: {
            'accountName': _accountName.text.trim(),
            'bankName': _bankName.text.trim(),
            'accountNumber': _accountNumber.text.trim(),
            'ifscCode': _ifscCode.text.trim(),
            'glAccountId': _glAccountId,
            'defaultAccount': _isDefault,
          },
        );
      } else {
        await api.post<Map<String, dynamic>>('/bank-accounts', data: {
          'accountCode': _accountCode.text.trim(),
          'accountName': _accountName.text.trim(),
          'bankName': _bankName.text.trim(),
          'accountNumber': _accountNumber.text.trim(),
          'ifscCode': _ifscCode.text.trim(),
          'glAccountId': _glAccountId,
          'defaultAccount': _isDefault,
        });
      }
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(bankGlAccountsProvider);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          Icon(
            _isEdit ? Icons.edit_note : Icons.account_balance,
            color: const Color(0xFF1E3A8A),
          ),
          const SizedBox(width: 8),
          Text(
            _isEdit ? 'Edit Bank Account / बैंक सम्पादन' : 'New Bank Account / नयाँ बैंक खाता',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_error != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9E8E8),
                      border: Border.all(color: const Color(0xFFA83232)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Color(0xFFA83232), fontSize: 12),
                    ),
                  ),
                TextFormField(
                  controller: _accountCode,
                  enabled: !_isEdit,
                  decoration: const InputDecoration(
                    labelText: 'Account Code (कोड) *',
                    hintText: 'e.g. NBL-001',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => !_isEdit && (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _accountName,
                  decoration: const InputDecoration(
                    labelText: 'Account Name (खाताको नाम) *',
                    hintText: 'e.g. Nepal Bank Current A/c',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _bankName,
                        decoration: const InputDecoration(
                          labelText: 'Bank Name (बैंकको नाम)',
                          hintText: 'e.g. Nepal Bank Limited',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _accountNumber,
                        decoration: const InputDecoration(
                          labelText: 'Account Number (खाता नं)',
                          hintText: 'e.g. 0010010012345',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _ifscCode,
                  decoration: const InputDecoration(
                    labelText: 'Branch Code / Swift Code',
                    hintText: 'e.g. NEBLNPKT',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                accountsAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text(
                    'Error loading accounts: $e',
                    style: const TextStyle(color: Colors.red, fontSize: 11),
                  ),
                  data: (accounts) {
                    if (accounts.isNotEmpty && _glAccountId == null && !_isEdit) {
                      _glAccountId = (accounts.first['id'] as num).toInt();
                    }
                    return DropdownButtonFormField<int>(
                      value: _glAccountId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Linked GL Account (लेखा खाता) *',
                        helperText: 'Asset account in double-entry ledger for this bank',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: accounts
                          .map((a) => DropdownMenuItem<int>(
                                value: (a['id'] as num).toInt(),
                                child: Text(
                                  '${a['accountCode']} — ${a['accountName']}',
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _glAccountId = v),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: _isDefault,
                      onChanged: (v) => setState(() => _isDefault = v ?? false),
                    ),
                    const Text('Set as default bank account (मुख्य खाता)', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.pop(context),
          child: const Text('CANCEL / रद्द गर्नुहोस्'),
        ),
        ElevatedButton(
          onPressed: _submitting ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
          ),
          child: _submitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(_isEdit ? 'SAVE CHANGES / सम्पादन गर्नुहोस्' : 'CREATE / थप्नुहोस्'),
        ),
      ],
    );
  }
}

