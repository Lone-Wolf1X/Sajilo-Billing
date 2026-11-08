import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_state_notifier.dart';
import '../../billing/presentation/sales_provider.dart';
import '../../business/presentation/business_provider.dart';
import '../../business/presentation/edit_business_screen.dart';
import '../../backup/presentation/backup_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _prefixController = TextEditingController(text: 'SB');
  bool _isSavingPrefix = false;

  @override
  void initState() {
    super.initState();
    _loadPrefix();
  }

  Future<void> _loadPrefix() async {
    final salesRepo = ref.read(salesRepositoryProvider);
    final prefix = await salesRepo.getBillPrefix();
    if (mounted) {
      setState(() {
        _prefixController.text = prefix;
      });
    }
  }

  @override
  void dispose() {
    _prefixController.dispose();
    super.dispose();
  }

  Future<void> _savePrefix() async {
    final clean = _prefixController.text.trim().toUpperCase();
    if (clean.isEmpty) return;
    setState(() => _isSavingPrefix = true);
    final salesRepo = ref.read(salesRepositoryProvider);
    await salesRepo.setBillPrefix(clean);
    if (mounted) {
      setState(() => _isSavingPrefix = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invoice prefix updated successfully!'),
          backgroundColor: AppTheme.accentTeal,
        ),
      );
    }
  }

  Future<void> _openAdminUrl() async {
    final uri = Uri.parse('https://nextgeninnovations.com.np/');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _confirmLogout(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(authStateProvider.notifier).logout();
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final profileAsync = ref.watch(businessProfileStreamProvider);
    final authState = ref.watch(authStateProvider);

    final currentYearBS = DateTime.now().year + 57;
    final livePreview = '${_prefixController.text.trim().toUpperCase()}-$currentYearBS-0001';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Business Profile Summary Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.store, color: AppTheme.primaryBlue, size: 28),
                                const SizedBox(width: 12),
                                Text(
                                  l10n.businessInfo,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppTheme.textDark,
                                  ),
                                ),
                              ],
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const EditBusinessScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              label: Text(l10n.edit),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: AppTheme.borderSubtle),
                        const SizedBox(height: 12),
                        profileAsync.when(
                          loading: () => const LinearProgressIndicator(),
                          error: (e, _) => Text('Error: $e'),
                          data: (profile) {
                            if (profile == null) {
                              return const Text('No business configured yet.');
                            }
                            return Column(
                              children: [
                                _buildDetailRow(l10n.businessNameLabel, profile.businessName),
                                if (profile.businessNameNepali != null && profile.businessNameNepali!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  _buildDetailRow(l10n.businessNameNepaliLabel, profile.businessNameNepali!),
                                ],
                                const SizedBox(height: 8),
                                _buildDetailRow(l10n.panVatLabel, profile.panVatNumber),
                                const SizedBox(height: 8),
                                _buildDetailRow(l10n.contactNumberLabel, profile.contactNumber),
                                if (profile.shopAddress != null) ...[
                                  const SizedBox(height: 8),
                                  _buildDetailRow(l10n.shopAddressLabel, profile.shopAddress!),
                                ],
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Bill Settings Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.receipt_long, color: AppTheme.primaryBlue, size: 26),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.billSettings,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textDark),
                                  ),
                                  Text(
                                    l10n.billSettingsSubtitle,
                                    style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: _prefixController,
                                textCapitalization: TextCapitalization.characters,
                                decoration: InputDecoration(
                                  labelText: l10n.billPrefix,
                                  hintText: l10n.billPrefixHint,
                                  isDense: true,
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _isSavingPrefix ? null : _savePrefix,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              ),
                              child: _isSavingPrefix
                                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : Text(l10n.saveChanges),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.borderSubtle),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.preview_outlined, size: 18, color: AppTheme.accentTeal),
                              const SizedBox(width: 8),
                              Text('${l10n.billPreview}: ', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                              Text(livePreview, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Language Selection Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.translate, color: AppTheme.primaryBlue, size: 26),
                            const SizedBox(width: 12),
                            Text(
                              l10n.language,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                label: Text(l10n.english),
                                selected: currentLocale.languageCode == 'en',
                                onSelected: (selected) {
                                  if (selected) {
                                    ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ChoiceChip(
                                label: Text(l10n.nepali),
                                selected: currentLocale.languageCode == 'ne',
                                onSelected: (selected) {
                                  if (selected) {
                                    ref.read(localeProvider.notifier).setLocale(const Locale('ne'));
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Backup and Restore Card
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(20),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.backup_outlined, color: AppTheme.primaryBlue),
                    ),
                    title: Text(
                      l10n.backupAndRestore,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Text(l10n.backupSubtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const BackupScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // About & Admin Card (NextGen Innovations)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.aboutAndAdmin,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textDark),
                                ),
                                Text(
                                  l10n.aboutSubtitle,
                                  style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: AppTheme.borderSubtle),
                        const SizedBox(height: 12),
                        _buildDetailRow(l10n.appVersion, '1.0.0+1 (Desktop & Web)'),
                        const SizedBox(height: 8),
                        _buildDetailRow(l10n.developedBy, l10n.nextGenInnovations),
                        const SizedBox(height: 8),
                        _buildDetailRow('Origin', l10n.madeInNepal),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _openAdminUrl,
                          icon: const Icon(Icons.open_in_new, size: 16, color: AppTheme.primaryBlue),
                          label: Text(l10n.visitAdminPanel, style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.primaryBlue),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // User Session & Logout Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                              child: Icon(
                                authState.isGoogleAuth ? Icons.account_circle : Icons.person,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authState.username ?? 'Local User',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                Text(
                                  authState.isGoogleAuth ? (authState.email ?? 'Google Connected') : 'Offline Local Account',
                                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _confirmLogout(context, l10n),
                          icon: const Icon(Icons.logout, size: 16, color: AppTheme.dangerRed),
                          label: Text(l10n.logout, style: const TextStyle(color: AppTheme.dangerRed)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.dangerRed),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 180,
          child: Text(
            label,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppTheme.textDark,
            ),
          ),
        ),
      ],
    );
  }
}
