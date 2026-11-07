import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import 'backup_provider.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _isProcessing = false;

  Future<void> _backupNow() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isProcessing = true);
    try {
      final service = ref.read(backupServiceProvider);
      final path = await service.backupNow();
      ref.invalidate(lastBackupTimeProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.backupSuccess} $path'),
            backgroundColor: AppTheme.accentTeal,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted && !e.toString().contains('cancelled')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.backupFailed(e.toString())),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _restoreBackup() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.restoreBackup),
        content: const Text(
          'Restoring will overwrite current database records with the selected backup file. Make sure you have backed up your current data if needed.\n\nDo you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.restoreBackup),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);
    try {
      final service = ref.read(backupServiceProvider);
      final restored = await service.restoreLatest();
      if (restored) {
        ref.invalidate(lastBackupTimeProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.restoreSuccess),
              backgroundColor: AppTheme.accentTeal,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.restoreFailed(e.toString())),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lastBackupAsync = ref.watch(lastBackupTimeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.backupAndRestore),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.archive_outlined, color: AppTheme.primaryBlue, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.backupAndRestore,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.backupSubtitle,
                                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: AppTheme.borderSubtle),
                        const SizedBox(height: 16),

                        // Last Backup Info
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.borderSubtle),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.history, color: AppTheme.textMuted, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                '${l10n.lastBackup}: ',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                              lastBackupAsync.when(
                                loading: () => const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                error: (_, __) => Text(
                                  l10n.noBackupYet,
                                  style: const TextStyle(color: AppTheme.textMuted),
                                ),
                                data: (time) => Text(
                                  time != null
                                      ? DateFormat('yyyy-MM-dd HH:mm:ss').format(time)
                                      : l10n.noBackupYet,
                                  style: TextStyle(
                                    color: time != null ? AppTheme.accentTeal : AppTheme.textMuted,
                                    fontWeight: time != null ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _isProcessing ? null : _backupNow,
                                icon: const Icon(Icons.download_rounded),
                                label: Text(l10n.backupNow),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _isProcessing ? null : _restoreBackup,
                                icon: const Icon(Icons.restore_page_outlined),
                                label: Text(l10n.restoreBackup),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Offline Notice Card
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 22),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Sajilo Billing stores all records (business profile, inventory, sales, bills) in a local SQLite database. Performing regular exports ensures your shop ledger remains protected even during hardware migrations.',
                            style: TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.4),
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
}
