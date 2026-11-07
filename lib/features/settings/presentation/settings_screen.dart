import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../business/presentation/business_provider.dart';
import '../../business/presentation/edit_business_screen.dart';
import '../../backup/presentation/backup_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final profileAsync = ref.watch(businessProfileStreamProvider);

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
