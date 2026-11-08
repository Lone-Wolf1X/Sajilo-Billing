import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'bill_pdf_printer.dart';

BillPdfPrinter getBillPdfPrinterInstance() => BillPdfPrinterWeb();

class BillPdfPrinterWeb implements BillPdfPrinter {
  @override
  Future<bool> printOrPreview({
    required Uint8List bytes,
    required String documentName,
  }) async {
    // printing package on Web automatically delegates to browser print preview / dialog
    return await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => bytes,
      name: documentName,
    );
  }
}

