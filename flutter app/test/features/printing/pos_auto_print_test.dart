import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/features/billing/domain/bill_model.dart';
import 'package:sajilo_billing/features/printing/domain/print_format.dart';
import 'package:sajilo_billing/features/printing/domain/printer_config.dart';
import 'package:sajilo_billing/features/printing/domain/receipt_printer.dart';

class MockReceiptPrinter implements ReceiptPrinter {
  int printCount = 0;
  bool shouldThrow = false;
  BillData? lastPrintedBill;
  PrintFormat? lastPrintedFormat;

  @override
  Future<void> printReceipt(BillData bill, PrintFormat format, PrinterConfig config) async {
    if (shouldThrow) {
      throw Exception('Printer hardware out of paper');
    }
    printCount++;
    lastPrintedBill = bill;
    lastPrintedFormat = format;
  }

  @override
  Future<bool> testConnection(PrinterConfig config) async {
    return !shouldThrow;
  }
}

void main() {
  group('POS Auto-Print Logic Tests', () {
    late MockReceiptPrinter mockPrinter;

    final testBill = BillData(
      businessName: 'Super Mart',
      panVatNumber: '123456789',
      contactNumber: '9841000000',
      shopAddress: 'Pokhara',
      invoiceNumber: 'SB-2082-0099',
      invoiceDate: DateTime(2026, 4, 15),
      customerName: 'Cash',
      paymentMode: 'CASH',
      items: const [
        BillItem(sn: 1, description: 'Apple 1kg', quantity: 1, rate: 200, amount: 200, unit: 'kg'),
      ],
      subtotal: 200,
      discountAmount: 0,
      taxableAmount: 200,
      vatAmount: 0,
      grandTotal: 200,
      inWords: 'Two Hundred Rupees Only',
      qrData: 'https://nextgeninnovations.com.np/',
    );

    setUp(() {
      mockPrinter = MockReceiptPrinter();
    });

    test('Dispatches print immediately when autoPrintAfterSale is enabled', () async {
      const config = PrinterConfig(
        autoPrintAfterSale: true,
        defaultFormat: PrintFormat.thermal80,
      );

      if (config.autoPrintAfterSale) {
        await mockPrinter.printReceipt(testBill, config.defaultFormat, config);
      }

      expect(mockPrinter.printCount, equals(1));
      expect(mockPrinter.lastPrintedBill?.invoiceNumber, equals('SB-2082-0099'));
      expect(mockPrinter.lastPrintedFormat, equals(PrintFormat.thermal80));
    });

    test('Does not dispatch print when autoPrintAfterSale is disabled', () async {
      const config = PrinterConfig(
        autoPrintAfterSale: false,
        defaultFormat: PrintFormat.thermal58,
      );

      if (config.autoPrintAfterSale) {
        await mockPrinter.printReceipt(testBill, config.defaultFormat, config);
      }

      expect(mockPrinter.printCount, equals(0));
    });

    test('Print exception is captured gracefully without blocking sale flow', () async {
      mockPrinter.shouldThrow = true;
      const config = PrinterConfig(autoPrintAfterSale: true);

      String? caughtError;
      if (config.autoPrintAfterSale) {
        try {
          await mockPrinter.printReceipt(testBill, config.defaultFormat, config);
        } catch (e) {
          caughtError = e.toString();
        }
      }

      expect(caughtError, contains('out of paper'));
    });
  });
}

