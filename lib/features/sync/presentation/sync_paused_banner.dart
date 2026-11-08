import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import 'sync_provider.dart';

/// Non-blocking alert banner shown on Web when backend sync is unreachable or paused.
/// Informs the user that changes reside in browser storage only and provides a Retry button.
class SyncPausedBanner extends ConsumerWidget {
  const SyncPausedBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Show only on Web platform, or if testing web behavior
    if (!kIsWeb) return const SizedBox.shrink();

    final syncState = ref.watch(syncStateProvider).valueOrNull;
    if (syncState == null || !syncState.isPaused) {
      return const SizedBox.shrink();
    }

    final timeStr = syncState.lastSyncedAt != null
        ? DateFormat('HH:mm').format(syncState.lastSyncedAt!.toLocal())
        : '--:--';

    return Container(
      width: double.infinity,
      color: Colors.amber.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.cloud_off, size: 20, color: Colors.amber.shade900),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Sync paused — last synced at $timeStr. Your changes are stored in this browser only.',
              style: TextStyle(
                color: Colors.amber.shade900,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            onPressed: () {
              ref.read(syncEngineProvider).sync();
            },
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
