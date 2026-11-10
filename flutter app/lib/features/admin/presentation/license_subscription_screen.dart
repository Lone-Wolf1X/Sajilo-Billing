import 'dart:convert';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/license/license_model.dart';
import '../../../core/providers.dart';

class LicenseSubscriptionScreen extends ConsumerStatefulWidget {
  const LicenseSubscriptionScreen({super.key});

  @override
  ConsumerState<LicenseSubscriptionScreen> createState() =>
      _LicenseSubscriptionScreenState();
}

class _LicenseSubscriptionScreenState
    extends ConsumerState<LicenseSubscriptionScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final licenseAsync = ref.watch(licenseStatusProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: licenseAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text('इजाजतपत्र विवरण लोड गर्न सकिएन: $err'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(licenseStatusProvider),
                child: const Text('पुन: प्रयास गर्नुहोस्'),
              ),
            ],
          ),
        ),
        data: (lic) => _buildContent(lic),
      ),
    );
  }

  Widget _buildContent(LicenseStatus lic) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'License & Subscription',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'कम्पनी इजाजतपत्र, योजना स्थिति तथा व्यावसायिक सदस्यता व्यवस्थापन',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.key, size: 18),
                    label: const Text('Generate License (जारी गर्नुहोस्)'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    onPressed: () => _openGenerateLicenseDialog(),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.upload_file, size: 18),
                    label: const Text('Upload License ZIP (अपलोड)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                    ),
                    onPressed: _isProcessing ? null : () => _uploadLicenseZip(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Main License Hero Banner
          _buildHeroBanner(lic),
          const SizedBox(height: 24),

          // Details & Entitlements Grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column 1: Plan Details
              Expanded(
                flex: 3,
                child: _buildDetailsCard(lic),
              ),
              const SizedBox(width: 24),
              // Column 2: Included Features & Security
              Expanded(
                flex: 4,
                child: _buildFeaturesCard(lic),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(LicenseStatus lic) {
    final isEnterprise = lic.plan.toUpperCase() == 'ENTERPRISE';
    final isGrowth = lic.plan.toUpperCase() == 'GROWTH';
    final isTrial = lic.isTrial;

    final gradientColors = isEnterprise
        ? [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)]
        : isGrowth
            ? [const Color(0xFF0F766E), const Color(0xFF14B8A6)]
            : [const Color(0xFF475569), const Color(0xFF64748B)];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  '${lic.plan.toUpperCase()} PLAN • ${isTrial ? "30-DAY TRIAL EVALUATION" : "COMMERCIAL EDITION"}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: lic.expired
                      ? Colors.red.shade600
                      : const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      lic.expired ? Icons.cancel : Icons.check_circle,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      lic.expired ? 'EXPIRED (म्याद सकियो)' : 'ACTIVE (सक्रिय)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lic.companyName.isNotEmpty
                        ? lic.companyName
                        : 'Nepal Retail Counter',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'License ID: ${lic.licenseId}  •  Max Users: ${lic.maxUsers}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${lic.daysRemaining}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  Text(
                    'Days Remaining (बाँकी दिन)',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(LicenseStatus lic) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subscription Overview (सदस्यता विवरण)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const Divider(height: 28),
          _infoRow('Plan Tier', lic.plan),
          _infoRow('License ID', lic.licenseId),
          _infoRow('Company Name', lic.companyName),
          _infoRow('PAN / VAT Number',
              lic.panNumber.isNotEmpty ? lic.panNumber : 'N/A'),
          _infoRow(
              'Issued Date', lic.issuedAt.toLocal().toString().split(' ')[0]),
          _infoRow(
              'Expiry Date', lic.expiresAt.toLocal().toString().split(' ')[0]),
          _infoRow('Authorized Cashiers', '${lic.maxUsers} Users'),
          _infoRow('Tamper Proofing', 'RSA-2048 Digital Signature'),
          _infoRow('Encryption Format', 'AES-256 Encrypted ZIP'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard(LicenseStatus lic) {
    final features = [
      (
        'POS Counter & Thermal Receipts (बिक्री तथा बिलिङ)',
        '80mm, 58mm, A4 format printing',
        lic.isFeatureAllowed('POS')
      ),
      (
        'Double-entry General Ledger (दोहोरो लेखा प्रणाली)',
        'Automated real-time journal postings & COGS',
        lic.isFeatureAllowed('DOUBLE_ENTRY')
      ),
      (
        'Realtime Financial Statements (वित्तीय विवरण)',
        'Trial Balance, Profit & Loss, Balance Sheet',
        lic.isFeatureAllowed('REPORTS')
      ),
      (
        'Nepal IRD Tax Registers (आन्तरिक राजस्व कर विवरण)',
        'Annex 13 D-01 Sales & D-02 Purchase Tax Registers',
        lic.isFeatureAllowed('IRD_TAX')
      ),
      (
        'Automated SMTP Email Delivery (इमेल अलर्ट)',
        'Daily end-of-day reports & test emails',
        lic.isFeatureAllowed('SMTP_EMAIL')
      ),
      (
        'Multi-User Cashier RBAC (प्रयोगकर्ता नियन्त्रण)',
        'Role-based permissions & audit logging',
        lic.isFeatureAllowed('MULTI_USER')
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Authorized Features (अधिकार तथा सुविधाहरू)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const Divider(height: 28),
          for (final f in features)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    f.$3 ? Icons.check_circle : Icons.lock_outline,
                    color: f.$3 ? const Color(0xFF10B981) : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f.$1,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: f.$3
                                ? const Color(0xFF0F172A)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                        Text(
                          f.$2,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _uploadLicenseZip() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'License Package (.zip)',
      extensions: <String>['zip'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    if (file == null) return;

    final zipBytes = await file.readAsBytes();

    if (!mounted) return;

    final password = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('Enter License Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'फाइल: ${file.name}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please enter the unpack password provided with your license:',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password (गोप्य कोड)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('रद्द गर्नुहोस्'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: const Text('अनप्याक गरी सुचारु गर्नुहोस्'),
            ),
          ],
        );
      },
    );

    if (password == null || password.trim().isEmpty) return;
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isProcessing = true);
    try {
      final updated = await ref.read(licenseServiceProvider).activateLicense(
            zipBytes: zipBytes,
            password: password.trim(),
          );
      ref.invalidate(licenseStatusProvider);

      messenger.showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF10B981),
          content: Text(
              '✓ बधाई छ! इजाजतपत्र सफलतापूर्वक सुचारु गरियो (${updated.plan} - ${updated.daysRemaining} दिन बाँकी)'),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: Text('इजाजतपत्र प्रमाणीकरण असफल भयो: $e'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _openGenerateLicenseDialog() async {
    final tenantCtrl = TextEditingController(text: 'nepalretail');
    final companyCtrl = TextEditingController(text: 'Nepal Retail Mart Pvt. Ltd.');
    final panCtrl = TextEditingController(text: '304958291');
    final passwordCtrl = TextEditingController(text: 'Sajilo#2026');
    final emailCtrl =
        TextEditingController(text: 'nextgeninnovationsprivatelimit@gmail.com');
    String selectedPlan = 'ENTERPRISE';
    int durationDays = 365;
    int maxUsers = 10;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            return AlertDialog(
              title: const Text('Commercial License Generator (कम्पनी इजाजतपत्र जारी)'),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: companyCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Company Name (कम्पनीको नाम)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: tenantCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Tenant Code',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: panCtrl,
                              decoration: const InputDecoration(
                                labelText: 'PAN / VAT',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedPlan,
                              decoration: const InputDecoration(
                                labelText: 'Plan Tier',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'STARTER', child: Text('STARTER')),
                                DropdownMenuItem(value: 'GROWTH', child: Text('GROWTH')),
                                DropdownMenuItem(value: 'ENTERPRISE', child: Text('ENTERPRISE')),
                              ],
                              onChanged: (v) {
                                if (v != null) setDlgState(() => selectedPlan = v);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: durationDays,
                              decoration: const InputDecoration(
                                labelText: 'Validity Duration',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 30, child: Text('30 Days')),
                                DropdownMenuItem(value: 90, child: Text('90 Days')),
                                DropdownMenuItem(value: 365, child: Text('1 Year (365 Days)')),
                                DropdownMenuItem(value: 730, child: Text('2 Years')),
                              ],
                              onChanged: (v) {
                                if (v != null) setDlgState(() => durationDays = v);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: passwordCtrl,
                        decoration: const InputDecoration(
                          labelText: 'ZIP Password (AES-256 सुरक्षित पासवर्ड)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Delivery Email (इमेलमा पठाउनुहोस्)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('रद्द गर्नुहोस्'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.verified),
                  label: const Text('जारी गरी प्याकेज बनाउनुहोस्'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    Navigator.pop(ctx);
                    setState(() => _isProcessing = true);
                    try {
                      final res = await ref.read(licenseServiceProvider).generateLicense(
                            tenantCode: tenantCtrl.text.trim(),
                            companyName: companyCtrl.text.trim(),
                            panNumber: panCtrl.text.trim(),
                            plan: selectedPlan,
                            durationDays: durationDays,
                            maxUsers: maxUsers,
                            allowedFeatures: const [
                              'POS',
                              'PURCHASE',
                              'INVENTORY',
                              'REPORTS',
                              'IRD_TAX',
                              'SMTP_EMAIL',
                              'MULTI_USER'
                            ],
                            zipPassword: passwordCtrl.text.trim(),
                            deliveryEmail: emailCtrl.text.trim(),
                          );

                      // Also activate it immediately for local tenant testing
                      final zipBase64 = res['zipBase64'] as String;
                      final zipBytes = base64Decode(zipBase64);
                      await ref.read(licenseServiceProvider).activateLicense(
                            zipBytes: zipBytes,
                            password: passwordCtrl.text.trim(),
                          );

                      ref.invalidate(licenseStatusProvider);

                      messenger.showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF10B981),
                          content: Text(
                            '✓ इजाजतपत्र सफलतापूर्वक जारी तथा सक्रिय गरियो! ${res['emailed'] == true ? "(इमेल पनि पठाइयो)" : ""}',
                          ),
                        ),
                      );
                    } catch (e) {
                      messenger.showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red.shade700,
                          content: Text('इजाजतपत्र जारी गर्न त्रुटि: $e'),
                        ),
                      );
                    } finally {
                      if (mounted) setState(() => _isProcessing = false);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
