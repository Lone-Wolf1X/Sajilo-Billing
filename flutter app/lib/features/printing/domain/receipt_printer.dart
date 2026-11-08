import '../../billing/domain/bill_model.dart';
import 'print_format.dart';
import 'printer_config.dart';
import 'receipt_printer_io.dart'
    if (dart.library.html) 'receipt_printer_web.dart' as impl;

/// Cross-platform interface for ESC/POS thermal and A4 bill printing.
abstract class ReceiptPrinter {
  /// Sends the formatted receipt to the configured printer device.
  Future<void> printReceipt(BillData bill, PrintFormat format, PrinterConfig config);

  /// Tests connectivity to the printer (Socket ping or OS enumeration).
  Future<bool> testConnection(PrinterConfig config);

  /// Retrieves the platform-appropriate receipt printer instance.
  static ReceiptPrinter get instance => impl.getReceiptPrinterInstance();
}

