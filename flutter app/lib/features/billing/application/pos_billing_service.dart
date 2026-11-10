import 'package:uuid/uuid.dart';
import '../../../core/sync/sync_queue_service.dart';
import '../data/pos_invoice_repository.dart';
import 'pos_cart_calculator.dart';

/// Result of a POS bill submission.
class PosBillResult {
  final String localNumber; // Temporary bill number for receipt
  final String? serverInvoiceNumber; // Null if offline/queued
  final int? serverInvoiceId;
  final bool syncQueued; // True if queued for background sync
  final bool syncSucceeded; // True if pushed immediately
  final String? error;
  final PosCartTotals totals;

  const PosBillResult({
    required this.localNumber,
    this.serverInvoiceNumber,
    this.serverInvoiceId,
    required this.syncQueued,
    required this.syncSucceeded,
    this.error,
    required this.totals,
  });
}

class PosBillingService {
  final PosInvoiceRepository _invoiceRepo;
  final SyncQueueService _syncQueue;

  PosBillingService({
    required PosInvoiceRepository invoiceRepo,
    required SyncQueueService syncQueue,
  })  : _invoiceRepo = invoiceRepo,
        _syncQueue = syncQueue;

  /// Submit a POS bill. Flow:
  /// 1. Generate idempotency key + local temp invoice number
  /// 2. Try immediate backend push (5s timeout)
  ///    - Success → return with server invoice number
  /// 3. On failure (network/server) → enqueue to sync queue, return with local number
  /// 4. Caller prints receipt with local or server number
  Future<PosBillResult> submitBill({
    required List<PosCartLine> lines,
    required int customerId,
    required int warehouseId,
    String? notes,
  }) async {
    if (lines.isEmpty) {
      throw ArgumentError('Cannot submit empty bill');
    }

    final totals = PosCartCalculator.computeCart(lines);
    final now = DateTime.now();
    final isoDate = now.toIso8601String().substring(0, 10);
    final idemKey = const Uuid().v4();
    final localNumber = 'INV-${now.millisecondsSinceEpoch}';

    final payload = {
      'invoiceNumber': localNumber,
      'invoiceDate': isoDate,
      'customerId': customerId,
      'warehouseId': warehouseId,
      'notes': notes,
      'idempotencyKey': idemKey,
      'lines': lines
          .map((l) => {
                'itemId': int.parse(l.itemId),
                'description': l.name,
                'quantity': l.quantity.toStringAsFixed(4),
                'unitPrice': l.unitPrice.toStringAsFixed(4),
                'taxRate': l.taxRate.toStringAsFixed(4),
              })
          .toList(),
    };

    // Attempt immediate push
    try {
      final serverResp = await _invoiceRepo
          .createInvoice(
            invoiceNumber: localNumber,
            invoiceDate: isoDate,
            customerId: customerId,
            warehouseId: warehouseId,
            lines: lines,
            idempotencyKey: idemKey,
            notes: notes,
          )
          .timeout(const Duration(seconds: 5));

      return PosBillResult(
        localNumber: localNumber,
        serverInvoiceNumber: serverResp['invoiceNumber'] as String?,
        serverInvoiceId: (serverResp['id'] as num?)?.toInt(),
        syncQueued: false,
        syncSucceeded: true,
        totals: totals,
      );
    } catch (e) {
      // Offline or error → enqueue for background sync
      await _syncQueue.enqueue(
        opType: 'SALES_INVOICE',
        payload: payload,
        idempotencyKey: idemKey,
      );

      return PosBillResult(
        localNumber: localNumber,
        syncQueued: true,
        syncSucceeded: false,
        error: e.toString(),
        totals: totals,
      );
    }
  }
}
