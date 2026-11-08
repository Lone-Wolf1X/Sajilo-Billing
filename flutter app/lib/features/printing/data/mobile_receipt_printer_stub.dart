import '../../billing/domain/bill_model.dart';
import '../domain/print_format.dart';
import '../domain/printer_config.dart';
import '../domain/receipt_printer.dart';

/// Stub for future Bluetooth mobile thermal printer integration (Step 7).
class MobileReceiptPrinterStub implements ReceiptPrinter {
  @override
  Future<void> printReceipt(BillData bill, PrintFormat format, PrinterConfig config) async {
    throw UnsupportedError('Bluetooth mobile printing is scheduled for Step 7.');
  }

  @override
  Future<bool> testConnection(PrinterConfig config) async {
    return false;
  }
}

