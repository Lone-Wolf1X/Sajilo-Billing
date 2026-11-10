import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/admin_users_controller.dart';

class CreateUserDialog extends ConsumerStatefulWidget {
  const CreateUserDialog({super.key});

  @override
  ConsumerState<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends ConsumerState<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _fullName = TextEditingController();
  String _role = 'CASHIER';
  bool _submitting = false;
  String? _error;

  static const _roles = [
    ('CASHIER', 'Cashier — POS & Sales Billing only'),
    ('ACCOUNTANT', 'Accountant — Billing, purchases, ledger & reports'),
    ('ADMIN', 'Administrator — Full company & user access'),
    ('VIEWER', 'Viewer — Read-only observation'),
  ];

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _fullName.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref.read(adminUsersControllerProvider).createUser(
            username: _username.text.trim(),
            email: _email.text.trim(),
            password: _password.text,
            fullName: _fullName.text.trim(),
            roleCode: _role,
          );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Row(
        children: [
          Icon(Icons.person_add, color: Color(0xFF1E3A8A)),
          SizedBox(width: 8),
          Text('Add New User / नयाँ प्रयोगकर्ता', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                controller: _username,
                decoration: const InputDecoration(
                  labelText: 'Username *',
                  hintText: 'e.g. cashier1',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (v) => (v == null || v.trim().length < 3)
                    ? 'Min 3 characters required'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fullName,
                decoration: const InputDecoration(
                  labelText: 'Full Name / पूरा नाम',
                  hintText: 'e.g. Sunita Sharma',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Email Address *',
                  hintText: 'e.g. cashier1@nepalretail.com',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'Valid email required'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password *',
                  helperText: 'Minimum 8 characters',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (v) => (v == null || v.length < 8)
                    ? 'Min 8 characters required'
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _role,
                decoration: const InputDecoration(
                  labelText: 'Role / पद *',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: _roles
                    .map((r) => DropdownMenuItem(
                          value: r.$1,
                          child: Text(r.$2, style: const TextStyle(fontSize: 13)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _role = v ?? 'CASHIER'),
              ),
            ],
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
              : const Text('CREATE USER / थप्नुहोस्'),
        ),
      ],
    );
  }
}

