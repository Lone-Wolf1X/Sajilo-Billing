import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/features/billing/domain/bill_model.dart';
import 'package:sajilo_billing/features/printing/domain/print_format.dart';
import 'package:sajilo_billing/features/printing/domain/printer_config.dart';
import 'package:sajilo_billing/features/printing/utils/esc_pos_commands.dart';
import 'package:sajilo_billing/features/printing/utils/thermal_receipt_builder.dart';

void main() {
  group('ThermalReceiptBuilder ASCII ESC/POS Tests', () {
    late BillData testBill;

    setUp(() {
      testBill = BillData(
        businessName: 'Himalayan Mart',
        businessNameNepali: 'हिमालयन मार्ट',
        panVatNumber: '601234567',
        contactNumber: '9841234567',
        shopAddress: 'New Road, Kathmandu',
        invoiceNumber: 'SB-2082-0042',
        invoiceDate: DateTime(2026, 4, 15, 14, 30),
        customerName: 'Ram Sharma',
        customerPan: '102938475',
        paymentMode: 'CASH',
        items: const [
          BillItem(
            sn: 1,
            description: 'Wai Wai Noodles',
            quantity: 5.0,
            rate: 25.0,
            amount: 125.0,
            unit: 'pkt',
          ),
          BillItem(
            sn: 2,
            description: 'Dairy Milk 50g',
            quantity: 2.0,
            rate: 100.0,
            amount: 200.0,
            unit: 'pcs',
          ),
        ],
        subtotal: 325.0,
        discountAmount: 25.0,
        taxableAmount: 300.0,
        vatAmount: 39.0,
        grandTotal: 339.0,
        inWords: 'Three Hundred Thirty Nine Rupees Only',
        qrData: 'https://nextgeninnovations.com.np/',
      );
    });

    test('Generates valid ESC/POS initialization, code page and cut commands for 80mm roll', () {
      const config = PrinterConfig(
        paperWidth: 80,
        defaultFormat: PrintFormat.thermal80,
        cutPaper: true,
        feedLines: 3,
        showFooterBranding: true,
      );

      final bytes = ThermalReceiptBuilder.buildAscii(
        bill: testBill,
        config: config,
        format: PrintFormat.thermal80,
      );

      expect(bytes, isNotEmpty);

      // Verify Initialization: ESC @ ([0x1B, 0x40])
      expect(bytes.sublist(0, 2), equals(EscPosCommands.initialize));

      // Verify Code Page Selection: ESC t 0 (CP437)
      expect(bytes.sublist(2, 5), equals(EscPosCommands.selectCodePageCP437));

      // Verify content contains business name and invoice number in ASCII
      final textContent = latin1.decode(bytes);
      expect(textContent, contains('HIMALAYAN MART'));
      expect(textContent, contains('PAN / VAT: 601234567'));
      expect(textContent, contains('SB-2082-0042'));
      expect(textContent, contains('Wai Wai Noodles'));
      expect(textContent, contains('Dairy Milk 50g'));
      expect(textContent, contains('GRAND TOTAL:'));
      expect(textContent, contains('Rs. 339.00'));
      expect(textContent, contains('NextGen Innovations'));

      // Verify Partial Paper Cut sequence at end: GS V 1 ([0x1D, 0x56, 0x01] = 3 bytes)
      expect(bytes.sublist(bytes.length - 3), equals(EscPosCommands.cutPartial));
    });

    test('Generates 58mm compact layout without exceeding 32 character line length', () {
      const config = PrinterConfig(
        paperWidth: 58,
        defaultFormat: PrintFormat.thermal58,
        cutPaper: false,
        feedLines: 2,
      );

      final bytes = ThermalReceiptBuilder.buildAscii(
        bill: testBill,
        config: config,
        format: PrintFormat.thermal58,
      );

      final textContent = latin1.decode(bytes);
      final lines = textContent.split('\n');

      for (final line in lines) {
        // Strip ESC/POS command sequences and control characters when checking printable line width
        final cleanLine = line
            .replaceAll(RegExp(r'\x1B.[\x00-\xFF]?|\x1D.[\x00-\xFF]?'), '')
            .replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
        expect(cleanLine.length, lessThanOrEqualTo(32), reason: 'Exceeded: "$cleanLine" (${cleanLine.length})');
      }

      // Verify in words
      expect(textContent, contains('In Words:'));
    });
  });
}

