import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';

class SyncQueueViewerDialog extends ConsumerStatefulWidget {
  const SyncQueueViewerDialog({super.key});

  @override
  ConsumerState<SyncQueueViewerDialog> createState() => _SyncQueueViewerDialogState();
}

class _SyncQueueViewerDialogState extends ConsumerState<SyncQueueViewerDialog> {
  bool _syncing = false;

  Future<void> _triggerManualSync() async {
    setState(() => _syncing = true);
    try {
      final summary = await ref.read(syncQueueServiceProvider).processPending();
      ref.invalidate(pendingSyncCountProvider);
      ref.invalidate(syncQueueItemsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sync finished: ${summary.synced} succeeded, ${summary.failed} failed',
            ),
            backgroundColor: summary.failed == 0
                ? const Color(0xFF10B981)
                : const Color(0xFFF59E0B),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(syncQueueItemsProvider);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.cloud_sync, color: Color(0xFF1E3A8A)),
              SizedBox(width: 8),
              Text(
                'Sync Queue / सिङ्क लाम',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh list',
            onPressed: () => ref.invalidate(syncQueueItemsProvider),
          ),
        ],
      ),
      content: SizedBox(
        width: 600,
        height: 400,
        child: itemsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              'Failed to load queue: $e',
              style: const TextStyle(color: Colors.red),
            ),
          ),
          data: (items) {
            if (items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 48),
                    SizedBox(height: 12),
                    Text(
                      'No pending items in queue',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'All local bills and purchases are in sync with SAISA cloud.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final item = items[i];
                final isSynced = item.status == 'SYNCED';
                final isFailed = item.status == 'FAILED' || item.status == 'DEAD';

                final color = isSynced
                    ? const Color(0xFF10B981)
                    : isFailed
                        ? const Color(0xFFDC2626)
                        : const Color(0xFFF59E0B);

                final icon = isSynced
                    ? Icons.check_circle
                    : isFailed
                        ? Icons.error
                        : Icons.pending;

                return ListTile(
                  leading: Icon(icon, color: color),
                  title: Row(
                    children: [
                      Text(
                        item.opType,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.status,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Key: ${item.idempotencyKey} | Attempts: ${item.attempts}/5',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      if (item.lastError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            'Error: ${item.lastError}',
                            style: const TextStyle(fontSize: 11, color: Colors.redAccent),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  trailing: Text(
                    item.createdAt.toString().split('.').first,
                    style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: _syncing ? null : _triggerManualSync,
          icon: _syncing
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.sync, size: 16),
          label: Text(_syncing ? 'SYNCING…' : 'SYNC NOW (अहिले सिङ्क गर्नुहोस्)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D9488),
            foregroundColor: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CLOSE / बन्द गर्नुहोस्'),
        ),
      ],
    );
  }
}

