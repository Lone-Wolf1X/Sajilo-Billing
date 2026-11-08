import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../billing/domain/bill_model.dart';
import '../domain/print_format.dart';
import '../domain/printer_config.dart';

/// USB thermal receipt printer implementation for Desktop platforms.
class UsbReceiptPrinter {
  /// Sends the receipt to the OS-enumerated USB thermal printer.
  Future<void> printReceipt(BillData bill, PrintFormat format, PrinterConfig config) async {
    final printers = await Printing.listPrinters();
    Printer? targetPrinter;

    if (config.usbPrinterName != null && config.usbPrinterName!.isNotEmpty) {
      targetPrinter = printers.cast<Printer?>().firstWhere(
            (p) => p?.name.toLowerCase() == config.usbPrinterName!.toLowerCase(),
            orElse: () => null,
          );
    }

    if (targetPrinter == null) {
      if (printers.isNotEmpty) {
        targetPrinter = printers.first;
      } else {
        throw Exception('No USB or local printers found. Please connect your thermal printer.');
      }
    }

    // Determine roll format dimensions
    final pageFormat = format == PrintFormat.thermal58
        ? const PdfPageFormat(58 * PdfPageFormat.mm, double.infinity, marginAll: 4 * PdfPageFormat.mm)
        : const PdfPageFormat(80 * PdfPageFormat.mm, double.infinity, marginAll: 5 * PdfPageFormat.mm);

    // Generate bilingual receipt PDF rendered to roll width
    final pdfBytes = await _generateRollPdf(bill, format, pageFormat, config);

    final copies = config.printCopies.clamp(1, 3);
    for (int i = 0; i < copies; i++) {
      final success = await Printing.directPrintPdf(
        printer: targetPrinter,
        onLayout: (format) async => pdfBytes,
        name: '${bill.invoiceNumber}_thermal.pdf',
        format: pageFormat,
      );

      if (!success) {
        throw Exception('Printing to USB device "${targetPrinter.name}" failed.');
      }
    }
  }

  /// Tests if the selected USB printer is visible to the operating system.
  Future<bool> testConnection(PrinterConfig config) async {
    if (config.usbPrinterName == null || config.usbPrinterName!.isEmpty) {
      return false;
    }
    final printers = await Printing.listPrinters();
    return printers.any((p) => p.name.toLowerCase() == config.usbPrinterName!.toLowerCase());
  }

  /// Generates a roll-formatted PDF for USB printers using the standard Devanagari font.
  static Future<Uint8List> _generateRollPdf(
    BillData bill,
    PrintFormat format,
    PdfPageFormat pageFormat,
    PrinterConfig config,
  ) async {
    final doc = pw.Document();
    final fontData = await rootBundle.load('assets/fonts/NotoSansDevanagari-Regular.ttf');
    final font = pw.Font.ttf(fontData);

    doc.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        build: (pw.Context context) {
          final isVat = bill.vatAmount > 0;
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              if (config.showNepaliHeader && bill.businessNameNepali != null && bill.businessNameNepali!.isNotEmpty)
                pw.Text(
                  bill.businessNameNepali!,
                  style: pw.TextStyle(font: font, fontSize: 13, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
              pw.Text(
                bill.businessName,
                style: pw.TextStyle(font: font, fontSize: 11, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              if (bill.shopAddress != null && bill.shopAddress!.isNotEmpty)
                pw.Text(bill.shopAddress!, style: pw.TextStyle(font: font, fontSize: 8), textAlign: pw.TextAlign.center),
              pw.Text('PAN: ${bill.panVatNumber}', style: pw.TextStyle(font: font, fontSize: 8), textAlign: pw.TextAlign.center),
              pw.Divider(thickness: 0.8),
              pw.Text(isVat ? 'TAX INVOICE' : 'ABBREVIATED TAX INVOICE',
                  style: pw.TextStyle(font: font, fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
              pw.Text('Bill No: ${bill.invoiceNumber}', style: pw.TextStyle(font: font, fontSize: 8)),
              pw.Text('Payment: ${bill.paymentMode}', style: pw.TextStyle(font: font, fontSize: 8)),
              pw.Divider(thickness: 0.5),
              ...bill.items.map((it) => pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Text('${it.sn}. ${it.description} (${it.quantity} ${it.unit})',
                            style: pw.TextStyle(font: font, fontSize: 8)),
                      ),
                      pw.Text('Rs. ${it.amount.toStringAsFixed(2)}', style: pw.TextStyle(font: font, fontSize: 8)),
                    ],
                  )),
              pw.Divider(thickness: 0.8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('GRAND TOTAL:', style: pw.TextStyle(font: font, fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Rs. ${bill.grandTotal.toStringAsFixed(2)}',
                      style: pw.TextStyle(font: font, fontSize: 10, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text('Thank you! धन्यवाद!', style: pw.TextStyle(font: font, fontSize: 8), textAlign: pw.TextAlign.center),
            ],
          );
        },
      ),
    );

    return doc.save();
  }
}

