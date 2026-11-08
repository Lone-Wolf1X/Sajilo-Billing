import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../billing/data/pdf_bill_generator.dart';
import '../../billing/domain/bill_model.dart';
import '../domain/print_format.dart';
import '../domain/printer_config.dart';
import '../domain/receipt_printer.dart';

/// Web implementation of [ReceiptPrinter].
/// Web browsers cannot send raw ESC/POS socket bytes; falls back to browser printing.
class WebReceiptPrinter implements ReceiptPrinter {
  @override
  Future<void> printReceipt(BillData bill, PrintFormat format, PrinterConfig config) async {
    if (format == PrintFormat.a4Pdf) {
      final doc = await PdfBillGenerator.generateDocument(bill);
      final pdfBytes = await doc.save();
      await Printing.layoutPdf(
        onLayout: (pdfFormat) async => pdfBytes,
        name: '${bill.invoiceNumber}.pdf',
      );
      return;
    }

    // Thermal roll format via browser print dialog
    final pageFormat = format == PrintFormat.thermal58
        ? const PdfPageFormat(58 * PdfPageFormat.mm, double.infinity, marginAll: 4 * PdfPageFormat.mm)
        : const PdfPageFormat(80 * PdfPageFormat.mm, double.infinity, marginAll: 5 * PdfPageFormat.mm);
    final pdfBytes = await _generateRollPdf(bill, format, pageFormat, config);

    await Printing.layoutPdf(
      onLayout: (pdfFormat) async => pdfBytes,
      name: '${bill.invoiceNumber}_thermal.pdf',
      format: pageFormat,
    );
  }

  @override
  Future<bool> testConnection(PrinterConfig config) async {
    // Browsers rely on the OS print dialog
    return true;
  }

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

