import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../api/saisa_api_client.dart';
import '../database/app_database.dart';

/// Handles pushing queued operations to SAISA backend.
/// Retries with exponential backoff; marks dead after 5 failures.
class SyncQueueService {
  final SaisaApiClient _api;
  final AppDatabase _db;

  /// Path routing — opType -> HTTP method + endpoint
  static const _opPaths = <String, ({String method, String path})>{
    'SALES_INVOICE': (method: 'POST', path: '/sales-invoices'),
    'PURCHASE_INVOICE': (method: 'POST', path: '/purchase-invoices'),
    'CUSTOMER': (method: 'POST', path: '/customers'),
    'ITEM': (method: 'POST', path: '/items'),
  };

  SyncQueueService({required SaisaApiClient api, required AppDatabase db})
      : _api = api,
        _db = db;

  /// Enqueue a new operation.
  /// Returns the local row ID.
  Future<int> enqueue({
    required String opType,
    required Map<String, dynamic> payload,
    required String idempotencyKey,
  }) async {
    final id = await _db.into(_db.syncQueueItems).insert(
          SyncQueueItemsCompanion.insert(
            opType: opType,
            payloadJson: jsonEncode(payload),
            idempotencyKey: idempotencyKey,
            status: const Value('PENDING'),
          ),
        );
    return id;
  }

  /// Process all pending items. Call periodically or on network up.
  Future<SyncSummary> processPending() async {
    final pending = await (_db.select(_db.syncQueueItems)
          ..where((t) =>
              t.status.equals('PENDING') |
              (t.status.equals('FAILED') & t.attempts.isSmallerThanValue(5)))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();

    int synced = 0;
    int failed = 0;

    for (final item in pending) {
      // Mark in-flight to avoid double-processing
      await (_db.update(_db.syncQueueItems)..where((t) => t.id.equals(item.id)))
          .write(const SyncQueueItemsCompanion(
        status: Value('IN_FLIGHT'),
      ));

      try {
        final resp = await _pushToBackend(item);
        await (_db.update(_db.syncQueueItems)..where((t) => t.id.equals(item.id)))
            .write(SyncQueueItemsCompanion(
          status: const Value('SYNCED'),
          syncedAt: Value(DateTime.now()),
          serverResponseJson: Value(jsonEncode(resp)),
          lastError: const Value(null),
        ));
        synced++;
      } catch (e) {
        final newAttempts = item.attempts + 1;
        final isDead = newAttempts >= 5;
        await (_db.update(_db.syncQueueItems)..where((t) => t.id.equals(item.id)))
            .write(SyncQueueItemsCompanion(
          status: Value(isDead ? 'DEAD' : 'FAILED'),
          attempts: Value(newAttempts),
          lastError: Value(e.toString()),
        ));
        failed++;
        if (kDebugMode) {
          debugPrint('Sync failed (${item.idempotencyKey}): $e');
        }
      }
    }

    return SyncSummary(synced: synced, failed: failed);
  }

  Future<Map<String, dynamic>> _pushToBackend(SyncQueueItem item) async {
    final route = _opPaths[item.opType];
    if (route == null) {
      throw Exception('Unknown opType: ${item.opType}');
    }

    final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;
    // Inject idempotency key so backend dedupes if retried
    payload['idempotencyKey'] = item.idempotencyKey;

    if (route.method == 'POST') {
      final resp = await _api.post<Map<String, dynamic>>(route.path, data: payload);
      return resp;
    } else {
      throw Exception('Unsupported method: ${route.method}');
    }
  }

  /// Count of pending + failed (for UI badge).
  Future<int> pendingCount() async {
    final countExp = _db.syncQueueItems.id.count();
    final row = await (_db.selectOnly(_db.syncQueueItems)
          ..addColumns([countExp])
          ..where(_db.syncQueueItems.status.equals('PENDING') |
              _db.syncQueueItems.status.equals('FAILED')))
        .getSingle();
    return row.read(countExp) ?? 0;
  }
}

class SyncSummary {
  final int synced;
  final int failed;
  const SyncSummary({required this.synced, required this.failed});
}

