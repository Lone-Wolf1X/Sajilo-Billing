import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/paisa_helper.dart';
import 'sales_provider.dart';
import 'widgets/sale_detail_dialog.dart';

class SalesHistoryScreen extends ConsumerStatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  ConsumerState<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends ConsumerState<SalesHistoryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(String saleId) {
    showDialog(
      context: context,
      builder: (ctx) => SaleDetailDialog(saleId: saleId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final salesAsync = ref.watch(salesStreamProvider);
    final summaryAsync = ref.watch(todaySalesSummaryProvider);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Summary Card
            summaryAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox(),
              data: (summary) {
                return Card(
                  color: AppTheme.primaryBlue.withOpacity(0.04),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Today's Revenue / आजको कुल बिक्री", style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(
                                PaisaHelper.formatPaisa(summary.totalRevenuePaisa),
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                              ),
                              Text('${summary.totalSalesCount} invoices issued today', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                            ],
                          ),
                        ),
                        const VerticalDivider(width: 30, color: AppTheme.borderSubtle),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Top Items Sold Today:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(height: 6),
                              if (summary.topItems.isEmpty)
                                const Text('No sales recorded today yet', style: TextStyle(fontSize: 12, color: AppTheme.textMuted))
                              else
                                ...summary.topItems.map((item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 2.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('• ${item.itemName}', style: const TextStyle(fontSize: 12)),
                                          Text('${item.totalQty} sold (${PaisaHelper.formatPaisa(item.totalAmountPaisa)})',
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Search Filter Bar
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by bill number, customer name, or phone...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          isDense: true,
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    ref.read(salesFilterProvider.notifier).update((s) => s.copyWith(query: ''));
                                  },
                                )
                              : null,
                        ),
                        onChanged: (val) {
                          ref.read(salesFilterProvider.notifier).update((s) => s.copyWith(query: val));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sales Table
            Expanded(
              child: salesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error loading invoices: $e')),
                data: (sales) {
                  if (sales.isEmpty) {
                    return const Card(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 54, color: AppTheme.textMuted),
                            SizedBox(height: 12),
                            Text('No sales invoices found', style: TextStyle(fontSize: 15, color: AppTheme.textMuted)),
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
                            DataColumn(label: Text('Invoice #', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Payment', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Sync', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: sales.map((s) {
                            final localDate = s.invoiceDate.toLocal();

                            return DataRow(
                              cells: [
                                DataCell(Text(dateFormat.format(localDate), style: const TextStyle(fontSize: 12))),
                                DataCell(Text(s.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(s.customerName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      if (s.customerPan != null)
                                        Text('PAN: ${s.customerPan}', style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                                    ],
                                  ),
                                ),
                                DataCell(Text(s.paymentMode, style: const TextStyle(fontSize: 12))),
                                DataCell(
                                  Text(
                                    PaisaHelper.formatPaisa(s.totalPaisa),
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: s.isVoided ? Colors.red.withOpacity(0.12) : AppTheme.accentTeal.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      s.isVoided ? 'VOIDED' : 'ISSUED',
                                      style: TextStyle(
                                        color: s.isVoided ? Colors.redAccent : AppTheme.accentTeal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    s.syncStatus.name.toUpperCase(),
                                    style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.receipt_outlined, size: 18),
                                    tooltip: 'View & Reprint Bill',
                                    color: AppTheme.primaryBlue,
                                    onPressed: () => _openDetail(s.id),
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

