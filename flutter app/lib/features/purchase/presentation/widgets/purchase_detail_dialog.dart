import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/sync_status.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/paisa_helper.dart';
import '../../data/purchase_repository.dart';
import '../purchase_provider.dart';

class PurchaseDetailDialog extends ConsumerStatefulWidget {
  final String purchaseId;

  const PurchaseDetailDialog({super.key, required this.purchaseId});

  @override
  ConsumerState<PurchaseDetailDialog> createState() => _PurchaseDetailDialogState();
}

class _PurchaseDetailDialogState extends ConsumerState<PurchaseDetailDialog> {
  bool _isProcessing = false;

  Future<void> _returnPurchase() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Return Purchase / खरिद फिर्ता'),
        content: const Text(
          'This will record negative entries in the stock ledger and reduce current inventory stock accordingly.\n\nAre you sure you want to mark this purchase as returned?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirm Return'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);
    final repo = ref.read(purchaseRepositoryProvider);

    try {
      await repo.returnPurchase(widget.purchaseId, reason: 'Returned to Supplier');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase return logged and stock deducted!'), backgroundColor: AppTheme.accentTeal),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(purchaseRepositoryProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 650),
        child: FutureBuilder<PurchaseWithItems?>(
          future: repo.getPurchaseDetails(widget.purchaseId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 250,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final data = snapshot.data;
            if (data == null) {
              return const Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(child: Text('Purchase record not found')),
              );
            }

            final p = data.purchase;
            final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
            final localDate = p.purchaseDate.toLocal();

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shopping_bag_outlined, color: AppTheme.primaryBlue),
                          const SizedBox(width: 10),
                          Text(
                            'Purchase Details (खरिद विवरण) - ${p.billNumber ?? p.id.substring(0, 8)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(color: AppTheme.borderSubtle),
                  const SizedBox(height: 10),

                  // Metadata Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.borderSubtle),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Supplier: ${p.supplierName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              if (p.supplierPan != null)
                                Text('PAN: ${p.supplierPan}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                              Text('Date: ${dateFormat.format(localDate)}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: p.isReturned ? Colors.red.withOpacity(0.1) : AppTheme.accentTeal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: p.isReturned ? Colors.redAccent : AppTheme.accentTeal,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              p.isReturned ? 'RETURNED' : 'CONFIRMED',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: p.isReturned ? Colors.redAccent : AppTheme.accentTeal,
                              ),
                            ),
                            Text(
                              'Sync: ${p.syncStatus.name.toUpperCase()}',
                              style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Items Table
                  Expanded(
                    child: Card(
                      child: SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: 18,
                          headingRowColor: MaterialStateProperty.all(AppTheme.backgroundLight),
                          columns: const [
                            DataColumn(label: Text('Item Name', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                            DataColumn(label: Text('Rate', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                            DataColumn(label: Text('Discount', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                            DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                          ],
                          rows: data.items.map((i) {
                            return DataRow(
                              cells: [
                                DataCell(Text(i.itemName, style: const TextStyle(fontWeight: FontWeight.w600))),
                                DataCell(Text('${i.quantity} ${i.unit}')),
                                DataCell(Text(PaisaHelper.formatPaisa(i.ratePaisa))),
                                DataCell(Text(PaisaHelper.formatPaisa(i.discountPaisa))),
                                DataCell(Text(PaisaHelper.formatPaisa(i.lineTotalPaisa), style: const TextStyle(fontWeight: FontWeight.bold))),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Bottom Totals and Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!p.isReturned && p.syncStatus == SyncStatus.pending)
                        OutlinedButton.icon(
                          onPressed: _isProcessing ? null : _returnPurchase,
                          icon: const Icon(Icons.assignment_return, color: Colors.redAccent, size: 16),
                          label: const Text('Return Purchase', style: TextStyle(color: Colors.redAccent)),
                        )
                      else
                        const SizedBox(),
                      Text(
                        'Grand Total: ${PaisaHelper.formatPaisa(p.totalPaisa)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryBlue),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
