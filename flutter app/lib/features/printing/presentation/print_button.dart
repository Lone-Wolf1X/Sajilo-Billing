import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../billing/data/pdf_bill_generator.dart';
import '../../billing/domain/bill_model.dart';
import '../data/printer_repository.dart';
import '../domain/print_format.dart';
import '../domain/receipt_printer.dart';

/// Versatile print button with primary default format action and secondary dropdown options.
class PrintButton extends ConsumerStatefulWidget {
  final BillData bill;
  final VoidCallback? onPrintSuccess;

  const PrintButton({
    super.key,
    required this.bill,
    this.onPrintSuccess,
  });

  @override
  ConsumerState<PrintButton> createState() => _PrintButtonState();
}

class _PrintButtonState extends ConsumerState<PrintButton> {
  bool _isPrinting = false;

  Future<void> _handlePrint(PrintFormat format) async {
    setState(() => _isPrinting = true);
    try {
      final config = await ref.read(printerConfigProvider.future);
      await ReceiptPrinter.instance.printReceipt(widget.bill, format, config);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bill sent to printer (${format.label})'),
            backgroundColor: AppTheme.accentTeal,
            duration: const Duration(seconds: 2),
          ),
        );
        widget.onPrintSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Printing failed: $e'),
            backgroundColor: AppTheme.dangerRed,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(printerConfigProvider);

    return configAsync.when(
      loading: () => const ElevatedButton(onPressed: null, child: Text('Loading...')),
      error: (_, __) => ElevatedButton.icon(
        onPressed: () => _handlePrint(PrintFormat.a4Pdf),
        icon: const Icon(Icons.print),
        label: const Text('Print Bill'),
      ),
      data: (config) {
        final defaultFormat = config.defaultFormat;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: _isPrinting ? null : () => _handlePrint(defaultFormat),
              icon: _isPrinting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Icon(defaultFormat.isThermal ? Icons.receipt_long : Icons.print, size: 18),
              label: Text(_isPrinting ? 'Printing...' : 'Print (${defaultFormat.paperWidthMm}mm)'),
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
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                tooltip: 'Select Print Format',
                onSelected: (action) async {
                  switch (action) {
                    case 'thermal_58':
                      await _handlePrint(PrintFormat.thermal58);
                      break;
                    case 'thermal_80':
                      await _handlePrint(PrintFormat.thermal80);
                      break;
                    case 'a4_pdf':
                      await _handlePrint(PrintFormat.a4Pdf);
                      break;
                    case 'export_pdf':
                      final doc = await PdfBillGenerator.generateDocument(widget.bill);
                      final bytes = await doc.save();
                      await PdfBillGenerator.exportPdf(widget.bill, bytes);
                      break;
                  }
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'thermal_80',
                    child: Row(
                      children: [
                        Icon(Icons.receipt_long, size: 18, color: AppTheme.primaryBlue),
                        SizedBox(width: 8),
                        Text('Thermal 80mm Roll (३ इन्च)'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'thermal_58',
                    child: Row(
                      children: [
                        Icon(Icons.receipt, size: 18, color: AppTheme.primaryBlue),
                        SizedBox(width: 8),
                        Text('Thermal 58mm Roll (२ इन्च)'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'a4_pdf',
                    child: Row(
                      children: [
                        Icon(Icons.description_outlined, size: 18, color: AppTheme.primaryBlue),
                        SizedBox(width: 8),
                        Text('Full Page A4/A5 PDF Bill'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'export_pdf',
                    child: Row(
                      children: [
                        Icon(Icons.download, size: 18, color: AppTheme.accentTeal),
                        SizedBox(width: 8),
                        Text('Save / Export PDF to File'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

