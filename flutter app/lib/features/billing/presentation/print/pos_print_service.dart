import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../../printing/domain/print_format.dart';
import 'receipt_data.dart';
import 'thermal_receipt_pdf.dart';

/// Service to handle POS receipt previewing and printing.
class PosPrintService {
  /// Prompt the user with format choices (80mm, 58mm, A4) or print with default.
  static Future<void> showPrintDialog({
    required BuildContext context,
    required ReceiptData receiptData,
    PrintFormat defaultFormat = PrintFormat.thermal80,
  }) async {
    final chosenFormat = await showDialog<PrintFormat>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.print, color: Color(0xFF0D9488)),
            SizedBox(width: 8),
            Text('Print Receipt / बिल छपाई', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Invoice: ${receiptData.invoiceNumber}', style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('Total: Rs. ${receiptData.totals.totalAmount}', style: const TextStyle(color: Color(0xFF0F172A))),
            const SizedBox(height: 16),
            const Text('Select Print Format / ढाँचा छान्नुहोस्:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            const SizedBox(height: 8),
            _formatTile(ctx, PrintFormat.thermal80, 'Thermal 80mm (3-inch POS Standard)', Icons.receipt),
            _formatTile(ctx, PrintFormat.thermal58, 'Thermal 58mm (2-inch Roll)', Icons.receipt_long),
            _formatTile(ctx, PrintFormat.a4Pdf, 'A4 Full Page (कर बिजक)', Icons.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel / रद्द गर्नुहोस्'),
          ),
        ],
      ),
    );

    if (chosenFormat != null) {
      await printBill(receiptData, format: chosenFormat);
    }
  }

  static Widget _formatTile(BuildContext ctx, PrintFormat format, String title, IconData icon) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: const Color(0xFF1E3A8A)),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      onTap: () => Navigator.pop(ctx, format),
    );
  }

  /// Direct print method without dialog prompt
  static Future<void> printBill(
    ReceiptData receiptData, {
    PrintFormat format = PrintFormat.thermal80,
  }) async {
    final doc = await ThermalReceiptPdf.generateDocument(receiptData, format: format);
    final pdfBytes = await doc.save();

    await Printing.layoutPdf(
      name: 'Receipt_${receiptData.invoiceNumber}.pdf',
      onLayout: (pageFormat) async => pdfBytes,
    );
  }
}

