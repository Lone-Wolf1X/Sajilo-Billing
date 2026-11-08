import 'dart:convert';
import 'dart:typed_data';

import '../../billing/domain/bill_model.dart';
import '../domain/print_format.dart';
import '../domain/printer_config.dart';
import 'devanagari_raster_renderer.dart';
import 'esc_pos_commands.dart';

/// Builds ESC/POS thermal receipt byte sequences from [BillData].
class ThermalReceiptBuilder {
  /// Builds complete ESC/POS byte sequence for a bill.
  static Future<Uint8List> build({
    required BillData bill,
    required PrinterConfig config,
    PrintFormat? overrideFormat,
  }) async {
    final format = overrideFormat ?? config.defaultFormat;

    // If Nepali raster mode is enabled and requested, generate full graphical ESC/POS
    if (config.enableRasterNepali) {
      return DevanagariRasterRenderer.renderBillToEscPos(
        bill: bill,
        config: config,
        format: format,
      );
    }

    // Default fast & robust ASCII mode
    return buildAscii(bill: bill, config: config, format: format);
  }

  /// Builds ASCII-encoded ESC/POS bytes with clean CP437 table layout.
  static Uint8List buildAscii({
    required BillData bill,
    required PrinterConfig config,
    required PrintFormat format,
  }) {
    final bytes = BytesBuilder();
    final charsPerLine = format.charsPerLine;

    // Helper closures
    void add(List<int> cmd) => bytes.add(cmd);
    void line(String s) {
      if (s.length <= charsPerLine) {
        bytes.add(latin1.encode(s));
        bytes.add(EscPosCommands.lineFeed);
        return;
      }

      // Wrap on words if possible, otherwise hard break
      final words = s.split(' ');
      var currentLine = StringBuffer();

      for (final word in words) {
        if (word.length > charsPerLine) {
          if (currentLine.isNotEmpty) {
            bytes.add(latin1.encode(currentLine.toString()));
            bytes.add(EscPosCommands.lineFeed);
            currentLine = StringBuffer();
          }
          int start = 0;
          while (start < word.length) {
            final end = (start + charsPerLine < word.length) ? start + charsPerLine : word.length;
            bytes.add(latin1.encode(word.substring(start, end)));
            bytes.add(EscPosCommands.lineFeed);
            start = end;
          }
        } else if (currentLine.isEmpty) {
          currentLine.write(word);
        } else if (currentLine.length + 1 + word.length <= charsPerLine) {
          currentLine.write(' $word');
        } else {
          bytes.add(latin1.encode(currentLine.toString()));
          bytes.add(EscPosCommands.lineFeed);
          currentLine = StringBuffer(word);
        }
      }

      if (currentLine.isNotEmpty) {
        bytes.add(latin1.encode(currentLine.toString()));
        bytes.add(EscPosCommands.lineFeed);
      }
    }
    void separator([String char = '-']) {
      line(char * charsPerLine);
    }

    // 1. Initialize Printer & Set Code Page
    add(EscPosCommands.initialize);
    add(EscPosCommands.selectCodePageCP437);
    add(EscPosCommands.lineSpacingDefault);

    // 2. Header
    add(EscPosCommands.alignCenter);
    add(EscPosCommands.boldOn);
    add(EscPosCommands.sizeDoubleHeight);
    line(bill.businessName.toUpperCase());
    add(EscPosCommands.sizeNormal);
    add(EscPosCommands.boldOff);

    if (bill.shopAddress != null && bill.shopAddress!.isNotEmpty) {
      line(bill.shopAddress!);
    }
    line('PAN / VAT: ${bill.panVatNumber}');
    if (bill.contactNumber.isNotEmpty) {
      line('Tel: ${bill.contactNumber}');
    }

    separator('=');

    // 3. Invoice Title & Meta
    final isVat = bill.vatAmount > 0;
    final invoiceTitle = isVat ? 'TAX INVOICE' : 'ABBREVIATED TAX INVOICE';
    add(EscPosCommands.boldOn);
    line(invoiceTitle);
    add(EscPosCommands.boldOff);
    separator('-');

    add(EscPosCommands.alignLeft);
    final dateStr = '${bill.invoiceDate.year}-${bill.invoiceDate.month.toString().padLeft(2, '0')}-${bill.invoiceDate.day.toString().padLeft(2, '0')}';
    line('Invoice No: ${bill.invoiceNumber}');
    line('Date: $dateStr    Time: ${bill.invoiceDate.hour.toString().padLeft(2, '0')}:${bill.invoiceDate.minute.toString().padLeft(2, '0')}');
    line('Payment Mode: ${bill.paymentMode}');

    if (bill.customerName.isNotEmpty && bill.customerName.toLowerCase() != 'walk-in' && bill.customerName != 'नगद ग्राहक') {
      line('Customer: ${bill.customerName}');
      if (bill.customerPan != null && bill.customerPan!.isNotEmpty) {
        line('Buyer PAN: ${bill.customerPan}');
      }
    }

    separator('-');

    // 4. Line Items Table
    if (charsPerLine >= 48) {
      // 80mm Layout (48 characters wide)
      line(_formatTableRow(['SN', 'Item', 'Qty', 'Rate', 'Total'], [3, 21, 6, 8, 8]));
      separator('-');

      for (int i = 0; i < bill.items.length; i++) {
        final item = bill.items[i];
        final sn = '${item.sn}';
        final name = item.description.length > 21 ? item.description.substring(0, 20) : item.description;
        final qty = '${item.quantity}';
        final rate = item.rate.toStringAsFixed(2);
        final total = item.amount.toStringAsFixed(2);

        line(_formatTableRow([sn, name, qty, rate, total], [3, 21, 6, 8, 8]));
      }
    } else {
      // 58mm Layout (32 characters wide)
      line('SN  ITEM           QTY    AMOUNT');
      separator('-');

      for (int i = 0; i < bill.items.length; i++) {
        final item = bill.items[i];
        final sn = '${item.sn}.'.padRight(3);
        final name = item.description.length > 28 ? item.description.substring(0, 27) : item.description;
        line('$sn $name');

        final qtyRate = '   ${item.quantity} x Rs.${item.rate.toStringAsFixed(2)}';
        final totalStr = 'Rs.${item.amount.toStringAsFixed(2)}';
        final spaceCount = (charsPerLine - qtyRate.length - totalStr.length).clamp(1, 32);
        line('$qtyRate${' ' * spaceCount}$totalStr');
      }
    }

    separator('-');

    // 5. Totals Section
    void addTotalRow(String label, String value, {bool isBold = false}) {
      if (isBold) add(EscPosCommands.boldOn);
      final spaceCount = (charsPerLine - label.length - value.length).clamp(1, charsPerLine);
      line('$label${' ' * spaceCount}$value');
      if (isBold) add(EscPosCommands.boldOff);
    }

    addTotalRow('Subtotal:', 'Rs. ${bill.subtotal.toStringAsFixed(2)}');
    if (bill.discountAmount > 0) {
      addTotalRow('Discount:', '- Rs. ${bill.discountAmount.toStringAsFixed(2)}');
    }
    if (isVat) {
      addTotalRow('Taxable Amount:', 'Rs. ${bill.taxableAmount.toStringAsFixed(2)}');
      addTotalRow('13% VAT:', 'Rs. ${bill.vatAmount.toStringAsFixed(2)}');
    }

    separator('=');
    add(EscPosCommands.sizeDoubleHeight);
    addTotalRow('GRAND TOTAL:', 'Rs. ${bill.grandTotal.toStringAsFixed(2)}', isBold: true);
    add(EscPosCommands.sizeNormal);
    separator('=');

    // 6. In words & QR
    if (bill.inWords.isNotEmpty) {
      line('In Words: ${bill.inWords}');
      separator('-');
    }

    // 7. Footer & Branding
    add(EscPosCommands.alignCenter);
    line('Thank you for your visit!');
    line('Please visit again.');

    if (config.showFooterBranding) {
      separator('.');
      line('Powered by Sajilo Billing');
      line('NextGen Innovations Pvt. Ltd.');
      line(charsPerLine >= 48 ? 'https://nextgeninnovations.com.np/' : 'nextgeninnovations.com.np');
      line('Made with pride in Nepal');
    }

    // 8. Feed lines & Cut Command
    add(EscPosCommands.feedLines(config.feedLines));
    if (config.cutPaper) {
      add(EscPosCommands.cutPartial);
    }

    return bytes.toBytes();
  }

  /// Formats aligned multi-column table row.
  static String _formatTableRow(List<String> columns, List<int> widths) {
    final buffer = StringBuffer();
    for (int i = 0; i < columns.length; i++) {
      final col = columns[i];
      final width = widths[i];
      final isRightAligned = i >= columns.length - 3; // Qty, Rate, Total are right-aligned

      if (isRightAligned) {
        buffer.write(col.padLeft(width));
      } else {
        buffer.write(col.padRight(width));
      }
      if (i < columns.length - 1) buffer.write(' ');
    }
    return buffer.toString();
  }
}

