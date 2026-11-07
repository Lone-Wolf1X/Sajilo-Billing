import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/paisa_helper.dart';
import 'purchase_entry_screen.dart';
import 'purchase_provider.dart';
import 'widgets/purchase_detail_dialog.dart';

class PurchaseScreen extends ConsumerStatefulWidget {
  const PurchaseScreen({super.key});

  @override
  ConsumerState<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends ConsumerState<PurchaseScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(String purchaseId) {
    showDialog(
      context: context,
      builder: (ctx) => PurchaseDetailDialog(purchaseId: purchaseId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final purchasesAsync = ref.watch(purchasesStreamProvider);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Header
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Purchases / खरिद व्यवस्थापन',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Manage supplier stock purchases, bills, and inventory intake',
                        style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PurchaseEntryScreen()),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text('New Purchase / नयाँ खरिद'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentTeal,
                    minimumSize: const Size(160, 42),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Search Bar
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by supplier name or bill number...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          isDense: true,
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    ref
                                        .read(purchaseFilterProvider.notifier)
                                        .update((s) => s.copyWith(query: ''));
                                  },
                                )
                              : null,
                        ),
                        onChanged: (val) {
                          ref
                              .read(purchaseFilterProvider.notifier)
                              .update((s) => s.copyWith(query: val));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Purchases Table
            Expanded(
              child: purchasesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error loading purchases: $e')),
                data: (purchases) {
                  if (purchases.isEmpty) {
                    return Card(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_shipping_outlined, size: 54, color: AppTheme.textMuted),
                            const SizedBox(height: 12),
                            const Text(
                              'No purchase records found',
                              style: TextStyle(fontSize: 15, color: AppTheme.textMuted),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const PurchaseEntryScreen()),
                                );
                              },
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Record First Purchase'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowColor: MaterialStateProperty.all(AppTheme.backgroundLight),
                          columns: const [
                            DataColumn(label: Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Supplier', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Bill #', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Sync', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: purchases.map((p) {
                            final localDate = p.purchaseDate.toLocal();

                            return DataRow(
                              cells: [
                                DataCell(Text(dateFormat.format(localDate), style: const TextStyle(fontSize: 12))),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(p.supplierName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      if (p.supplierPan != null)
                                        Text('PAN: ${p.supplierPan}', style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                                    ],
                                  ),
                                ),
                                DataCell(Text(p.billNumber ?? '-', style: const TextStyle(fontSize: 12))),
                                DataCell(
                                  Text(
                                    PaisaHelper.formatPaisa(p.totalPaisa),
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: p.isReturned ? Colors.red.withOpacity(0.12) : AppTheme.accentTeal.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      p.isReturned ? 'RETURNED' : 'ACTIVE',
                                      style: TextStyle(
                                        color: p.isReturned ? Colors.redAccent : AppTheme.accentTeal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    p.syncStatus.name.toUpperCase(),
                                    style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.visibility_outlined, size: 18),
                                    tooltip: 'View Details',
                                    color: AppTheme.primaryBlue,
                                    onPressed: () => _openDetail(p.id),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
