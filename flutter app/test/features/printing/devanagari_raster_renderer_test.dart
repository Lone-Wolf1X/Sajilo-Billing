import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/features/billing/domain/bill_model.dart';
import 'package:sajilo_billing/features/printing/domain/print_format.dart';
import 'package:sajilo_billing/features/printing/domain/printer_config.dart';
import 'package:sajilo_billing/features/printing/utils/devanagari_raster_renderer.dart';
import 'package:sajilo_billing/features/printing/utils/esc_pos_commands.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DevanagariRasterRenderer ESC/POS Graphics Tests', () {
    final testBill = BillData(
      businessName: 'Kathmandu Store',
      businessNameNepali: 'काठमाडौँ स्टोर प्रा.लि.',
      panVatNumber: '987654321',
      contactNumber: '9841112233',
      shopAddress: 'न्युरोड, काठमाडौँ',
      invoiceNumber: 'SB-RASTER-001',
      invoiceDate: DateTime(2026, 4, 15, 12, 0),
      customerName: 'श्याम श्रेष्ठ',
      paymentMode: 'FONEPAY',
      items: const [
        BillItem(
          sn: 1,
          description: 'चिउरा (Chiwura 1kg)',
          quantity: 2.0,
          rate: 120.0,
          amount: 240.0,
          unit: 'kg',
        ),
      ],
      subtotal: 240.0,
      discountAmount: 0.0,
      taxableAmount: 240.0,
      vatAmount: 0.0,
      grandTotal: 240.0,
      inWords: 'Two Hundred Forty Rupees Only',
      qrData: 'https://nextgeninnovations.com.np/',
    );

    test('Renders Devanagari raster ESC/POS bytes with GS v 0 header for 58mm (384 px / 48 bytes)', () async {
      const config = PrinterConfig(
        paperWidth: 58,
        enableRasterNepali: true,
        cutPaper: true,
      );

      final bytes = await DevanagariRasterRenderer.renderBillToEscPos(
        bill: testBill,
        config: config,
        format: PrintFormat.thermal58,
      );

      expect(bytes, isNotEmpty);

      // Verify Initialization: ESC @
      expect(bytes.sublist(0, 2), equals(EscPosCommands.initialize));

      // Verify GS v 0 raster header: [0x1D, 0x76, 0x30, 0x00]
      expect(bytes[2], equals(0x1D));
      expect(bytes[3], equals(0x76));
      expect(bytes[4], equals(0x30));
      expect(bytes[5], equals(0x00));

      // Check xL and xH for 384 pixels / 8 = 48 bytes
      final xL = bytes[6];
      final xH = bytes[7];
      final widthBytes = xL + (xH << 8);
      expect(widthBytes, equals(48));

      // Check yL and yH (height in pixels > 100)
      final yL = bytes[8];
      final yH = bytes[9];
      final heightPixels = yL + (yH << 8);
      expect(heightPixels, greaterThan(100));

      // Verify partial cut command at end: GS V 1 ([0x1D, 0x56, 0x01] = 3 bytes)
      expect(bytes.sublist(bytes.length - 3), equals(EscPosCommands.cutPartial));
    });

    test('Renders 80mm roll with 576 dots (72 bytes) width', () async {
      const config = PrinterConfig(
        paperWidth: 80,
        enableRasterNepali: true,
        cutPaper: false,
      );

      final bytes = await DevanagariRasterRenderer.renderBillToEscPos(
        bill: testBill,
        config: config,
        format: PrintFormat.thermal80,
      );

      expect(bytes, isNotEmpty);

      // Check xL and xH for 576 pixels / 8 = 72 bytes
      final xL = bytes[6];
      final xH = bytes[7];
      final widthBytes = xL + (xH << 8);
      expect(widthBytes, equals(72));
    });
  });
}

