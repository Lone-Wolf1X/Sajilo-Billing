import 'package:printing/printing.dart';
import '../../billing/data/pdf_bill_generator.dart';
import '../../billing/domain/bill_model.dart';
import '../data/network_receipt_printer.dart';
import '../data/usb_receipt_printer_io.dart';
import 'print_format.dart';
import 'printer_config.dart';
import 'receipt_printer.dart';

/// Desktop implementation of [ReceiptPrinter] supporting Network (TCP 9100) and USB printers.
class DesktopReceiptPrinter implements ReceiptPrinter {
  final _network = NetworkReceiptPrinter();
  final _usb = UsbReceiptPrinter();

  @override
  Future<void> printReceipt(BillData bill, PrintFormat format, PrinterConfig config) async {
    // Standard A4 / A5 PDF generation fallback
    if (format == PrintFormat.a4Pdf) {
      final doc = await PdfBillGenerator.generateDocument(bill);
      final pdfBytes = await doc.save();
      await Printing.layoutPdf(
        onLayout: (pdfFormat) async => pdfBytes,
        name: '${bill.invoiceNumber}.pdf',
      );
      return;
    }

    // Thermal ESC/POS roll printing
    if (config.isNetwork) {
      await _network.printReceipt(bill, format, config);
    } else {
      await _usb.printReceipt(bill, format, config);
    }
  }

  @override
  Future<bool> testConnection(PrinterConfig config) async {
    if (config.isNetwork) {
      return _network.testConnection(config);
    } else {
      return _usb.testConnection(config);
    }
  }
}

ReceiptPrinter getReceiptPrinterInstance() => DesktopReceiptPrinter();

