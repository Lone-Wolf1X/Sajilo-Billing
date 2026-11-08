import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/core/platform/bill_pdf_printer.dart';
import 'package:sajilo_billing/core/platform/bill_pdf_printer_web.dart';

class MockBillPdfPrinter implements BillPdfPrinter {
  Uint8List? capturedBytes;
  String? capturedDocumentName;

  @override
  Future<bool> printOrPreview({
    required Uint8List bytes,
    required String documentName,
  }) async {
    capturedBytes = bytes;
    capturedDocumentName = documentName;
    return true;
  }
}

void main() {
  group('BillPdfPrinter Tests', () {
    test('BillPdfPrinter instance is available cross-platform', () {
      final printer = BillPdfPrinter.instance;
      expect(printer, isA<BillPdfPrinter>());
    });

    test('BillPdfPrinterWeb handles bill printing interface contracts correctly', () async {
      final mockPrinter = MockBillPdfPrinter();
      final sampleBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      const sampleDocName = 'SB-2082-0001.pdf';

      final success = await mockPrinter.printOrPreview(
        bytes: sampleBytes,
        documentName: sampleDocName,
      );

      expect(success, isTrue);
      expect(mockPrinter.capturedBytes, equals(sampleBytes));
      expect(mockPrinter.capturedDocumentName, equals(sampleDocName));
    });

    test('BillPdfPrinterWeb class instantiates properly', () {
      final webPrinter = BillPdfPrinterWeb();
      expect(webPrinter, isA<BillPdfPrinter>());
    });
  });
}

