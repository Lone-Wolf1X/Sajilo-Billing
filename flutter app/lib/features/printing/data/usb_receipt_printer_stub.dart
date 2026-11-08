import '../../billing/domain/bill_model.dart';
import '../domain/print_format.dart';
import '../domain/printer_config.dart';

/// Web stub for USB receipt printer.
class UsbReceiptPrinter {
  Future<void> printReceipt(BillData bill, PrintFormat format, PrinterConfig config) async {
    throw UnsupportedError('Direct USB raw printing is only available on Desktop applications.');
  }

  Future<bool> testConnection(PrinterConfig config) async {
    return false;
  }
}

