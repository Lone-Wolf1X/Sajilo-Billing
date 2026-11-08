import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/backup_metadata_summary.dart';

/// Modal dialog confirming database restoration with safety disclosure
/// and explicit confirmation checkbox.
class RestoreDialog extends StatefulWidget {
  final BackupMetadataSummary summary;
  final bool isDrive;

  const RestoreDialog({
    super.key,
    required this.summary,
    this.isDrive = false,
  });

  @override
  State<RestoreDialog> createState() => _RestoreDialogState();
}

class _RestoreDialogState extends State<RestoreDialog> {
  bool _confirmed = false;

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.summary.createdAt.toLocal());

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.confirmRestoreTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.confirmRestoreMessage,
                style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Column(
                  children: [
                    _buildRow(l10n.backupTimestamp, dateStr),
                    const Divider(height: 16),
                    _buildRow(l10n.backupSize, _formatBytes(widget.summary.sizeBytes)),
                    if (widget.summary.businessName.isNotEmpty) ...[
                      const Divider(height: 16),
                      _buildRow(l10n.businessNameLabel, widget.summary.businessName),
                    ],
                    if (widget.summary.panNumber.isNotEmpty) ...[
                      const Divider(height: 16),
                      _buildRow(l10n.panVatLabel, widget.summary.panNumber),
                    ],
                    const Divider(height: 16),
                    _buildRow('Schema Version', 'v${widget.summary.schemaVersion}'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: AppTheme.primaryBlue, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'A safety copy of your active database (restored-overwrite-<timestamp>.sqlite) will be created automatically before overwriting.',
                        style: TextStyle(fontSize: 12, color: AppTheme.textDark),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _confirmed,
                onChanged: (val) => setState(() => _confirmed = val ?? false),
                title: Text(
                  l10n.confirmRestoreCheckbox,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          ),
          onPressed: _confirmed ? () => Navigator.of(context).pop(true) : null,
          child: Text(widget.isDrive ? l10n.restoreFromDrive : l10n.restoreFromLocal),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark),
        ),
      ],
    );
  }
}
