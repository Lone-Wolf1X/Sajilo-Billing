import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/backup_service_locator.dart';

/// Renders the last 20 backup operations with location, size, and status badges.
class BackupHistoryList extends ConsumerWidget {
  const BackupHistoryList({super.key});

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final logsAsync = ref.watch(recentBackupLogsProvider);

    return logsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, _) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Error loading backup logs: $err',
          style: const TextStyle(color: Colors.redAccent),
        ),
      ),
      data: (logs) {
        if (logs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderSubtle),
            ),
            child: Column(
              children: [
                const Icon(Icons.history, color: AppTheme.textMuted, size: 36),
                const SizedBox(height: 8),
                Text(
                  l10n.noBackupLogs,
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderSubtle),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final log = logs[index];
              return _buildLogItem(context, log, l10n);
            },
          ),
        );
      },
    );
  }

  Widget _buildLogItem(BuildContext context, BackupLog log, AppLocalizations l10n) {
    final isDrive = log.location == 'drive';
    final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(log.startedAt.toLocal());

    Widget statusBadge;
    if (log.status == 'success') {
      statusBadge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          l10n.statusSuccess,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    } else if (log.status == 'failed') {
      statusBadge = Tooltip(
        message: log.errorMessage ?? 'Unknown error',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 14, color: Colors.red),
              const SizedBox(width: 4),
              Text(
                l10n.statusFailed,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      statusBadge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          l10n.statusInProgress,
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isDrive ? Colors.blue.withOpacity(0.12) : Colors.teal.withOpacity(0.12),
        child: Icon(
          isDrive ? Icons.cloud_done_outlined : Icons.folder_zip_outlined,
          color: isDrive ? AppTheme.primaryBlue : AppTheme.accentTeal,
        ),
      ),
      title: Text(
        log.fileName,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      subtitle: Row(
        children: [
          Text(
            dateStr,
            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
          ),
          const SizedBox(width: 8),
          const Text('•', style: TextStyle(color: AppTheme.textMuted)),
          const SizedBox(width: 8),
          Text(
            _formatBytes(log.sizeBytes),
            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
          ),
          if (log.googleAccountEmail != null) ...[
            const SizedBox(width: 8),
            const Text('•', style: TextStyle(color: AppTheme.textMuted)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                log.googleAccountEmail!,
                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
      trailing: statusBadge,
    );
  }
}
