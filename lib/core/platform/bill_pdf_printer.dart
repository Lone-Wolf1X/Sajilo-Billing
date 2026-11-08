import 'dart:typed_data';
import 'bill_pdf_printer_io.dart'
    if (dart.library.html) 'bill_pdf_printer_web.dart' as impl;

/// Cross-platform abstraction for printing and previewing generated PDF bills.
abstract class BillPdfPrinter {
  Future<bool> printOrPreview({
    required Uint8List bytes,
    required String documentName,
  });

  static BillPdfPrinter get instance => impl.getBillPdfPrinterInstance();
}

