import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/api_exception.dart';
import '../../../core/providers.dart';

class EmailSettingsData {
  final int? id;
  final String smtpHost;
  final int smtpPort;
  final String smtpUsername;
  final String smtpPassword;
  final String fromEmail;
  final String fromName;
  final bool starttlsEnabled;
  final bool authEnabled;

  const EmailSettingsData({
    this.id,
    required this.smtpHost,
    required this.smtpPort,
    required this.smtpUsername,
    required this.smtpPassword,
    required this.fromEmail,
    required this.fromName,
    required this.starttlsEnabled,
    required this.authEnabled,
  });

  factory EmailSettingsData.fromJson(Map<String, dynamic> j) => EmailSettingsData(
        smtpHost: j['smtpHost'] as String? ?? 'smtp.gmail.com',
        smtpPort: (j['smtpPort'] as num?)?.toInt() ?? 587,
        smtpUsername: j['smtpUsername'] as String? ?? '',
        smtpPassword: j['smtpPassword'] as String? ?? '',
        fromEmail: j['fromEmail'] as String? ?? '',
        fromName: j['fromName'] as String? ?? 'SAISA Billing & Accounting',
        starttlsEnabled: j['starttlsEnabled'] as bool? ?? true,
        authEnabled: j['authEnabled'] as bool? ?? true,
      );
}

final emailSettingsProvider = FutureProvider.autoDispose<EmailSettingsData>((ref) async {
  final api = ref.read(apiClientProvider);
  final json = await api.get<Map<String, dynamic>>('/admin/email-settings');
  return EmailSettingsData.fromJson(json);
});

class EmailSettingsScreen extends ConsumerStatefulWidget {
  const EmailSettingsScreen({super.key});

  @override
  ConsumerState<EmailSettingsScreen> createState() => _EmailSettingsScreenState();
}

class _EmailSettingsScreenState extends ConsumerState<EmailSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _host = TextEditingController();
  final _port = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _fromEmail = TextEditingController();
  final _fromName = TextEditingController();
  bool _starttls = true;
  bool _auth = true;

  bool _initialized = false;
  bool _saving = false;
  bool _sendingTest = false;
  String? _error;

  @override
  void dispose() {
    _host.dispose();
    _port.dispose();
    _username.dispose();
    _password.dispose();
    _fromEmail.dispose();
    _fromName.dispose();
    super.dispose();
  }

  void _populate(EmailSettingsData d) {
    _host.text = d.smtpHost;
    _port.text = d.smtpPort.toString();
    _username.text = d.smtpUsername;
    _password.text = d.smtpPassword;
    _fromEmail.text = d.fromEmail;
    _fromName.text = d.fromName;
    _starttls = d.starttlsEnabled;
    _auth = d.authEnabled;
    _initialized = true;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final api = ref.read(apiClientProvider);
      await api.put<Map<String, dynamic>>('/admin/email-settings', data: {
        'smtpHost': _host.text.trim(),
        'smtpPort': int.tryParse(_port.text.trim()) ?? 587,
        'smtpUsername': _username.text.trim(),
        'smtpPassword': _password.text.trim(),
        'fromEmail': _fromEmail.text.trim(),
        'fromName': _fromName.text.trim(),
        'starttlsEnabled': _starttls,
        'authEnabled': _auth,
      });
      ref.invalidate(emailSettingsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email settings updated successfully! / इमेल सेटिङ सुरक्षित गरियो!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _sendTestEmail() async {
    setState(() => _sendingTest = true);
    try {
      final api = ref.read(apiClientProvider);
      final resp = await api.post<Map<String, dynamic>>(
        '/admin/email-settings/test?recipient=${Uri.encodeComponent(_fromEmail.text.trim())}',
      );
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF10B981)),
                SizedBox(width: 8),
                Text('Test Email Sent! / इमेल पठाइयो!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resp['message'] as String? ?? 'Test email was delivered successfully.',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text('Recipient: ${resp['recipient'] ?? _fromEmail.text}'),
                Text('Time: ${resp['timestamp'] ?? DateTime.now().toIso8601String()}'),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Test email failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _sendingTest = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(emailSettingsProvider);

    return settingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            Text('Error loading email settings: $e', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(emailSettingsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (data) {
        if (!_initialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _populate(data);
              setState(() {});
            }
          });
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.mark_email_read, color: Color(0xFF1E3A8A), size: 28),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email & SMTP Configuration / इमेल कन्फिगरेसन',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Configure outgoing email server for customer bill receipts, alerts, and verification codes',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _sendingTest ? null : _sendTestEmail,
                      icon: _sendingTest
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send, size: 16),
                      label: Text(_sendingTest ? 'SENDING…' : 'TEST EMAIL (परीक्षण इमेल)'),
                      style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF0D9488)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.save, size: 18),
                      label: Text(_saving ? 'SAVING…' : 'SAVE SETTINGS (सुरक्षित गर्नुहोस्)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if (_error != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9E8E8),
                      border: Border.all(color: const Color(0xFFA83232)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(_error!, style: const TextStyle(color: Color(0xFFA83232))),
                  ),

                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'SMTP Server Details / सर्भर विवरण',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _host,
                                decoration: const InputDecoration(
                                  labelText: 'SMTP Server Host *',
                                  hintText: 'smtp.gmail.com',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _port,
                                decoration: const InputDecoration(
                                  labelText: 'Port *',
                                  hintText: '587',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _username,
                                decoration: const InputDecoration(
                                  labelText: 'SMTP Username / Login Email *',
                                  hintText: 'e.g. nextgeninnovationsprivatelimit@gmail.com',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _password,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'SMTP App Password / पासवर्ड *',
                                  helperText: 'Google 16-character App Password',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _fromEmail,
                                decoration: const InputDecoration(
                                  labelText: 'Sender Email Address (प्रेषक इमेल) *',
                                  hintText: 'nextgeninnovationsprivatelimit@gmail.com',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                validator: (v) => (v == null || !v.contains('@')) ? 'Valid email required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _fromName,
                                decoration: const InputDecoration(
                                  labelText: 'Sender Display Name (प्रेषक नाम) *',
                                  hintText: 'SAISA Billing & Accounting',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Checkbox(
                              value: _starttls,
                              onChanged: (v) => setState(() => _starttls = v ?? true),
                            ),
                            const Text('Enable TLS / STARTTLS Encryption (सुरक्षित इन्क्रिप्सन)', style: TextStyle(fontSize: 13)),
                            const SizedBox(width: 24),
                            Checkbox(
                              value: _auth,
                              onChanged: (v) => setState(() => _auth = v ?? true),
                            ),
                            const Text('Enable SMTP Authentication (प्रमाणीकरण)', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
