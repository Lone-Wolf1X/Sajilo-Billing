import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../application/pos_billing_service.dart';
import '../application/pos_cart_controller.dart';
import 'widgets/cart_table.dart';
import 'widgets/customer_selector.dart';
import 'widgets/item_picker.dart';
import 'widgets/totals_card.dart';

class PosBillingScreen extends ConsumerStatefulWidget {
  const PosBillingScreen({super.key});

  @override
  ConsumerState<PosBillingScreen> createState() => _PosBillingScreenState();
}

class _PosBillingScreenState extends ConsumerState<PosBillingScreen> {
  bool _submitting = false;

  Future<void> _submitBill() async {
    final cart = ref.read(posCartProvider);
    if (cart.isEmpty) {
      _toast('Cart is empty / कार्ट खाली छ', error: true);
      return;
    }
    if (cart.customerId == null) {
      _toast('Please select a customer / कृपया ग्राहक छान्नुहोस्', error: true);
      return;
    }
    if (cart.warehouseId == null) {
      _toast('No warehouse configured / गोदाम छानिएको छैन', error: true);
      return;
    }

    setState(() => _submitting = true);
    try {
      final service = ref.read(posBillingServiceProvider);
      final result = await service.submitBill(
        lines: cart.lines,
        customerId: cart.customerId!,
        warehouseId: cart.warehouseId!,
        notes: cart.notes,
      );

      // Invalidate sync badge count
      ref.invalidate(pendingSyncCountProvider);

      if (!mounted) return;

      // Show success dialog
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _SuccessDialog(result: result),
      );

      // Clear cart
      ref.read(posCartProvider.notifier).clear();
    } catch (e) {
      _toast('Bill failed: $e', error: true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _toast(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? const Color(0xFFDC2626) : const Color(0xFF1E3A8A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(posCartProvider);
    final controller = ref.read(posCartProvider.notifier);
    final warehousesAsync = ref.watch(warehousesListProvider);

    // Auto-set default warehouse when loaded
    if (cart.warehouseId == null) {
      warehousesAsync.whenData((list) {
        if (list.isNotEmpty) {
          final def = list.firstWhere(
            (w) => w.defaultWarehouse,
            orElse: () => list.first,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && cart.warehouseId == null) {
              controller.setWarehouse(def.id);
            }
          });
        }
      });
    }

    // Auto-select walk-in customer if customerId is null
    final customersAsync = ref.watch(customersListProvider);
    if (cart.customerId == null) {
      customersAsync.whenData((list) {
        final walkIn = list.where((c) => c.customerCode == 'WALK-IN').firstOrNull;
        if (walkIn != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && cart.customerId == null) {
              controller.setCustomer(walkIn.id);
            }
          });
        }
      });
    }

    final totals = cart.totals;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // LEFT: Item picker + Cart table
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // POS Header Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.point_of_sale, color: Colors.white, size: 22),
                        SizedBox(width: 10),
                        Text(
                          'POS Billing / बिक्री काउन्टर',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'SAISA Realtime Double-Entry Ready',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Item Picker Box
                  const SizedBox(
                    height: 190,
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: ItemPicker(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cart Lines Table
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const CartTable(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // RIGHT: Customer, Warehouse, Totals, Actions
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Customer & Warehouse Box
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomerSelector(
                            value: cart.customerId,
                            onChange: (id) => controller.setCustomer(id),
                          ),
                          const SizedBox(height: 10),
                          _WarehouseSelector(
                            value: cart.warehouseId,
                            onChange: (id) => controller.setWarehouse(id),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const TotalsCard(),
                  const SizedBox(height: 12),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: cart.isEmpty ? null : () => controller.clear(),
                          icon: const Icon(Icons.delete_sweep, size: 18),
                          label: const Text('CLEAR / खाली'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _submitting ? null : _submitBill,
                          icon: _submitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.receipt_long, size: 18),
                          label: Text(_submitting ? 'POSTING…' : 'ISSUE BILL (बिल जारी)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D9488),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Prominent Total Amount Display
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL PAYABLE:',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Rs. ${totals.totalAmount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}

class _WarehouseSelector extends ConsumerWidget {
  final int? value;
  final ValueChanged<int?> onChange;
  const _WarehouseSelector({this.value, required this.onChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warehousesAsync = ref.watch(warehousesListProvider);
    return warehousesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text(
        'Warehouse error: $e',
        style: const TextStyle(color: Colors.red, fontSize: 11),
      ),
      data: (list) => DropdownButtonFormField<int>(
        value: value,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: 'Warehouse / गोदाम',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: list
            .map((w) => DropdownMenuItem(
                  value: w.id,
                  child: Text('${w.name} (${w.code})'),
                ))
            .toList(),
        onChanged: onChange,
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  final PosBillResult result;
  const _SuccessDialog({required this.result});

  @override
  Widget build(BuildContext context) {
    final synced = result.syncSucceeded;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          Icon(
            synced ? Icons.check_circle : Icons.cloud_queue,
            color: synced ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
            size: 28,
          ),
          const SizedBox(width: 10),
          Text(
            synced ? 'Invoice Posted (बीजक जारी)' : 'Bill Queued (सिन्क बाँकी)',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _kv('Invoice #:', synced ? (result.serverInvoiceNumber ?? '—') : result.localNumber),
          const SizedBox(height: 6),
          _kv('Grand Total:', 'Rs. ${result.totals.totalAmount}'),
          const SizedBox(height: 6),
          _kv('Status:', synced ? 'Double-Entry Posted to Ledger' : 'Stored Locally in Drift Queue'),
          if (!synced)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Offline Mode: Bill has been saved locally and will auto-sync to SAISA backend once connection is available.',
                style: TextStyle(fontSize: 12, color: Color(0xFFB45309)),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK / जारी राख्नुहोस्'),
        ),
      ],
    );
  }

  Widget _kv(String k, String v) => Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              k,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ),
          Expanded(
            child: Text(
              v,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                color: Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      );
}
