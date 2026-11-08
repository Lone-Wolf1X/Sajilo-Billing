import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/paisa_helper.dart';
import '../../../business/presentation/business_provider.dart';
import '../../data/html_bill_generator.dart';
import '../../data/sales_repository.dart';
import '../../domain/bill_model.dart';
import '../sales_provider.dart';
import '../../../printing/data/printer_repository.dart';
import '../../../printing/domain/print_format.dart';
import '../../../printing/domain/receipt_printer.dart';

class SaleDetailDialog extends ConsumerStatefulWidget {
  final String saleId;

  const SaleDetailDialog({super.key, required this.saleId});

  @override
  ConsumerState<SaleDetailDialog> createState() => _SaleDetailDialogState();
}

class _SaleDetailDialogState extends ConsumerState<SaleDetailDialog> {
  bool _isProcessing = false;
  late Future<SaleWithItems?> _saleDetailsFuture;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  void _loadDetails() {
    _saleDetailsFuture = ref.read(salesRepositoryProvider).getSaleDetails(widget.saleId);
  }

  Future<void> _verifyDraft() async {
    setState(() => _isProcessing = true);
    try {
      final salesRepo = ref.read(salesRepositoryProvider);
      final verifiedSale = await salesRepo.verifyDraftSale(widget.saleId);
      ref.invalidate(salesStreamProvider);
      if (mounted) {
        setState(() {
          _loadDetails();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invoice ${verifiedSale.invoiceNumber} verified & issued!'),
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
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _printHtmlBill(SaleWithItems data, BillTemplateStyle style) async {
    final profile = await ref.read(businessRepositoryProvider).getCurrentProfile();
    if (profile != null) {
      Uint8List? logoBytes;
      if (!kIsWeb && profile.logoPath != null) {
        try {
          final f = File(profile.logoPath!);
          if (await f.exists()) logoBytes = await f.readAsBytes();
        } catch (_) {}
      }
      final billData = BillData.fromSaleRecord(
        profile: profile,
        sale: data.sale,
        saleItems: data.items,
        logoBytes: logoBytes,
      );
      await HtmlBillGenerator.printOrPreviewHtml(billData, style: style);
    }
  }

  Future<void> _voidSale(String invoiceNumber) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Void Sale Invoice / बिजक रद्द'),
        content: Text(
          'Voiding invoice "$invoiceNumber" will reverse all stock deductions in the stock ledger and mark the invoice as cancelled.\n\nDo you want to proceed?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirm Void'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);
    final salesRepo = ref.read(salesRepositoryProvider);

    try {
      await salesRepo.voidSale(widget.saleId, reason: 'Voided by cashier / customer cancelled');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sale voided and stock restored to inventory!'), backgroundColor: AppTheme.accentTeal),
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

  Future<void> _reprintBill(SaleWithItems details, [PrintFormat? overrideFormat]) async {
    final profile = await ref.read(businessRepositoryProvider).getCurrentProfile();
    if (profile == null) return;

    Uint8List? logoBytes;
    if (profile.logoPath != null) {
      final f = File(profile.logoPath!);
      if (await f.exists()) logoBytes = await f.readAsBytes();
    }

    final billData = BillData.fromSaleRecord(
      profile: profile,
      sale: details.sale,
      saleItems: details.items,
      logoBytes: logoBytes,
    );

    try {
      final config = await ref.read(printerConfigProvider.future);
      final format = overrideFormat ?? config.defaultFormat;
      await ReceiptPrinter.instance.printReceipt(billData, format, config);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invoice ${billData.invoiceNumber} sent to printer (${format.label})'),
            backgroundColor: AppTheme.accentTeal,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Print failed: $e'), backgroundColor: AppTheme.dangerRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 660),
        child: FutureBuilder<SaleWithItems?>(
          future: _saleDetailsFuture,
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
                child: Center(child: Text('Sale record not found')),
              );
            }

            final s = data.sale;
            final localDate = s.invoiceDate.toLocal();

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.receipt_long, color: AppTheme.primaryBlue),
                          const SizedBox(width: 10),
                          Text(
                            'Tax Invoice / कर बिजक: ${s.invoiceNumber}',
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

                  // Metadata banner
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
                              Text('Customer: ${s.customerName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              if (s.customerPan != null)
                                Text('PAN: ${s.customerPan}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                              if (s.customerPhone != null)
                                Text('Phone: ${s.customerPhone}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                              Text('Date: ${dateFormat.format(localDate)}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: s.isVoided ? Colors.red.withOpacity(0.12) : AppTheme.accentTeal.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: s.isVoided ? Colors.redAccent : AppTheme.accentTeal,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              s.isVoided ? 'VOIDED / रद्द' : 'VALID INVOICE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: s.isVoided ? Colors.redAccent : AppTheme.accentTeal,
                              ),
                            ),
                            Text('Payment: ${s.paymentMode}', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
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

                  // Bottom Totals & Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (s.status == 'DRAFT') ...[
                            ElevatedButton.icon(
                              onPressed: _isProcessing ? null : _verifyDraft,
                              icon: const Icon(Icons.check_circle_outline, size: 16),
                              label: const Text('Validate & Issue Bill'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentTeal,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                          if (!s.isVoided) ...[
                            OutlinedButton.icon(
                              onPressed: _isProcessing ? null : () => _voidSale(s.invoiceNumber),
                              icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 16),
                              label: const Text('Void Sale / रद्द', style: TextStyle(color: Colors.redAccent)),
                            ),
                          ],
                          // HTML Print Options
                          PopupMenuButton<BillTemplateStyle>(
                            tooltip: 'Print HTML Bill / नयाँ बिल ढाँचा',
                            onSelected: (style) => _printHtmlBill(data, style),
                            itemBuilder: (ctx) => BillTemplateStyle.values.map((style) {
                              return PopupMenuItem(
                                value: style,
                                child: Text(style.label),
                              );
                            }).toList(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFF561131),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.print_outlined, color: Colors.white, size: 16),
                                  SizedBox(width: 6),
                                  Text('HTML Bill', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _reprintBill(data),
                                icon: const Icon(Icons.print, size: 16),
                                label: const Text('Reprint'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryBlue,
                                  foregroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryBlue,
                                  borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                                ),
                                child: PopupMenuButton<PrintFormat>(
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                  tooltip: 'Select Format',
                                  onSelected: (fmt) => _reprintBill(data, fmt),
                                  itemBuilder: (ctx) => [
                                    const PopupMenuItem(
                                      value: PrintFormat.thermal80,
                                      child: Text('Thermal 80mm Roll (३ इन्च)'),
                                    ),
                                    const PopupMenuItem(
                                      value: PrintFormat.thermal58,
                                      child: Text('Thermal 58mm Roll (२ इन्च)'),
                                    ),
                                    const PopupMenuItem(
                                      value: PrintFormat.a4Pdf,
                                      child: Text('A4/A5 PDF Bill'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Subtotal: ${PaisaHelper.formatPaisa(s.subtotalPaisa)}', style: const TextStyle(fontSize: 12)),
                          if (s.discountPaisa > 0)
                            Text('Discount: - ${PaisaHelper.formatPaisa(s.discountPaisa)}', style: const TextStyle(fontSize: 12)),
                          if (s.vatPaisa > 0)
                            Text('VAT (13%): ${PaisaHelper.formatPaisa(s.vatPaisa)}', style: const TextStyle(fontSize: 12)),
                          Text(
                            'Grand Total: ${PaisaHelper.formatPaisa(s.totalPaisa)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryBlue),
                          ),
                        ],
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

