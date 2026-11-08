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
  String _statusFilter = 'ALL'; // 'ALL', 'VERIFIED', 'DRAFT'

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

  Future<void> _verifyDraft(String saleId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Validate & Issue Bill / बिल प्रमाणीकरण'),
        content: const Text(
          'This will validate item stock, assign an official sequential fiscal invoice number, and record deductions in the stock ledger.\n\nDo you want to verify this draft bill now?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Verify & Issue Bill'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final repo = ref.read(salesRepositoryProvider);
        final verifiedSale = await repo.verifyDraftSale(saleId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invoice ${verifiedSale.invoiceNumber} successfully verified & issued!'),
              backgroundColor: AppTheme.accentTeal,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to verify bill: $e'), backgroundColor: Colors.redAccent),
          );
        }
      }
    }
  }

  Widget _buildFilterChip(String status, String label) {
    final isSelected = _statusFilter == status;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _statusFilter = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppTheme.textMuted,
          ),
        ),
      ),
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
                    const SizedBox(width: 14),
                    // Status Filter Segment
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.borderSubtle),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildFilterChip('ALL', 'All / सबै'),
                          _buildFilterChip('VERIFIED', 'Verified / प्रमाणित'),
                          _buildFilterChip('DRAFT', 'Drafts / ड्राफ्ट'),
                        ],
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
                  final filteredSales = sales.where((s) {
                    if (_statusFilter == 'ALL') return true;
                    return s.status == _statusFilter;
                  }).toList();

                  if (filteredSales.isEmpty) {
                    return const Card(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 54, color: AppTheme.textMuted),
                            SizedBox(height: 12),
                            Text('No sales invoices found matching filter', style: TextStyle(fontSize: 15, color: AppTheme.textMuted)),
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
                          rows: filteredSales.map((s) {
                            final localDate = s.invoiceDate.toLocal();
                            final isDraft = s.status == 'DRAFT';

                            return DataRow(
                              cells: [
                                DataCell(Text(dateFormat.format(localDate), style: const TextStyle(fontSize: 12))),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isDraft)
                                        const Padding(
                                          padding: EdgeInsets.only(right: 4.0),
                                          child: Icon(Icons.edit_note, size: 16, color: Colors.orange),
                                        ),
                                      Text(
                                        s.invoiceNumber,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: isDraft ? Colors.deepOrange : AppTheme.textDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                                      color: s.isVoided
                                          ? Colors.red.withOpacity(0.12)
                                          : (isDraft ? Colors.orange.withOpacity(0.15) : AppTheme.accentTeal.withOpacity(0.12)),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      s.isVoided ? 'VOIDED' : (isDraft ? 'DRAFT' : 'VERIFIED'),
                                      style: TextStyle(
                                        color: s.isVoided
                                            ? Colors.redAccent
                                            : (isDraft ? Colors.deepOrange : AppTheme.accentTeal),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.5,
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
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isDraft)
                                        IconButton(
                                          icon: const Icon(Icons.check_circle_outline, size: 20, color: AppTheme.accentTeal),
                                          tooltip: 'Validate & Verify (प्रमाणीकरण गर्नुहोस्)',
                                          onPressed: () => _verifyDraft(s.id),
                                        ),
                                      IconButton(
                                        icon: const Icon(Icons.receipt_outlined, size: 18),
                                        tooltip: 'View & Reprint Bill',
                                        color: AppTheme.primaryBlue,
                                        onPressed: () => _openDetail(s.id),
                                      ),
                                    ],
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

