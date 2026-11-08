import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:syntech_nepali_calendar/syntech_nepali_calendar.dart';

import '../../billing/domain/bill_model.dart';
import '../domain/print_format.dart';
import '../domain/printer_config.dart';
import 'esc_pos_commands.dart';

/// Renders bilingual receipts with embedded Devanagari text as ESC/POS raster bit-images (`GS v 0`).
class DevanagariRasterRenderer {
  /// Default thermal resolutions:
  /// 58mm roll: 384 dots width (48 bytes)
  /// 80mm roll: 576 dots width (72 bytes)
  static int getPixelWidth(PrintFormat format) {
    return format == PrintFormat.thermal58 ? 384 : 576;
  }

  /// Builds ESC/POS bytes by drawing the bill on a Canvas and converting to raster bitmap.
  static Future<Uint8List> renderBillToEscPos({
    required BillData bill,
    required PrinterConfig config,
    required PrintFormat format,
  }) async {
    final width = getPixelWidth(format);
    final widthBytes = width ~/ 8;

    // 1. Measure and draw the bill to a Picture
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Initial white background
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), 10000), bgPaint);

    // Running Y offset cursor
    double y = 10.0;
    const padding = 12.0;
    final contentWidth = width - (padding * 2);

    void drawText(
      String text, {
      double fontSize = 14,
      bool isBold = false,
      TextAlign align = TextAlign.left,
      Color color = Colors.black,
    }) {
      final span = TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'NotoSansDevanagari',
        ),
      );
      final tp = TextPainter(
        text: span,
        textAlign: align,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: contentWidth);

      double x = padding;
      if (align == TextAlign.center) {
        x = padding + (contentWidth - tp.width) / 2;
      } else if (align == TextAlign.right) {
        x = padding + contentWidth - tp.width;
      }

      tp.paint(canvas, Offset(x, y));
      y += tp.height + 4;
    }

    void drawTwoCol(String left, String right, {bool isBold = false, double fontSize = 13}) {
      final leftSpan = TextSpan(
        text: left,
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'NotoSansDevanagari',
        ),
      );
      final rightSpan = TextSpan(
        text: right,
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'NotoSansDevanagari',
        ),
      );

      final leftTp = TextPainter(text: leftSpan, textDirection: TextDirection.ltr)..layout(maxWidth: contentWidth * 0.6);
      final rightTp = TextPainter(text: rightSpan, textDirection: TextDirection.ltr, textAlign: TextAlign.right)
        ..layout(maxWidth: contentWidth * 0.4);

      leftTp.paint(canvas, Offset(padding, y));
      rightTp.paint(canvas, Offset(padding + contentWidth - rightTp.width, y));
      y += (leftTp.height > rightTp.height ? leftTp.height : rightTp.height) + 4;
    }

    void drawDivider([double thickness = 1.0]) {
      y += 4;
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = thickness;
      canvas.drawLine(Offset(padding, y), Offset(padding + contentWidth, y), paint);
      y += 8;
    }

    // --- Header ---
    if (config.showNepaliHeader && bill.businessNameNepali != null && bill.businessNameNepali!.trim().isNotEmpty) {
      drawText(bill.businessNameNepali!, fontSize: 20, isBold: true, align: TextAlign.center);
    }
    drawText(bill.businessName, fontSize: 16, isBold: true, align: TextAlign.center);

    if (bill.shopAddress != null && bill.shopAddress!.isNotEmpty) {
      drawText(bill.shopAddress!, fontSize: 12, align: TextAlign.center);
    }
    drawText('PAN / VAT: ${bill.panVatNumber}', fontSize: 12, isBold: true, align: TextAlign.center);
    if (bill.contactNumber.isNotEmpty) {
      drawText('सम्पर्क / Tel: ${bill.contactNumber}', fontSize: 12, align: TextAlign.center);
    }

    drawDivider(1.5);

    // --- Invoice Title & Dates ---
    final isVat = bill.vatAmount > 0;
    final title = isVat ? 'कर बिजक / TAX INVOICE' : 'संक्षिप्त कर बिजक / ABBREVIATED TAX INVOICE';
    drawText(title, fontSize: 13, isBold: true, align: TextAlign.center);
    drawDivider(0.8);

    drawTwoCol('बिल नं / Invoice No:', bill.invoiceNumber, isBold: true);

    // Bikram Sambat Date
    final bsDate = NepaliDateFormat('yyyy-MM-dd', Language.nepali).format(bill.invoiceDate.toNepaliDateTime());
    final adDate = '${bill.invoiceDate.year}-${bill.invoiceDate.month.toString().padLeft(2, '0')}-${bill.invoiceDate.day.toString().padLeft(2, '0')}';
    drawTwoCol('मिती / BS Date:', 'वि.सं. $bsDate');
    drawTwoCol('AD Date:', adDate);
    drawTwoCol('भुक्तानी / Payment:', bill.paymentMode);

    if (bill.customerName.isNotEmpty && bill.customerName.toLowerCase() != 'walk-in' && bill.customerName != 'नगद ग्राहक') {
      drawTwoCol('ग्राहक / Customer:', bill.customerName);
      if (bill.customerPan != null && bill.customerPan!.isNotEmpty) drawTwoCol('खरीदकर्ता प्यान:', bill.customerPan!);
    }

    drawDivider(1.2);

    // --- Line Items Table Header ---
    drawTwoCol('विवरण / Item (Qty x Rate)', 'जम्मा / Total', isBold: true, fontSize: 12);
    drawDivider(0.6);

    for (int i = 0; i < bill.items.length; i++) {
      final item = bill.items[i];
      final lineDesc = '${item.sn}. ${item.description} (${item.quantity} ${item.unit} x Rs. ${item.rate.toStringAsFixed(2)})';
      final lineTotal = 'Rs. ${item.amount.toStringAsFixed(2)}';
      drawTwoCol(lineDesc, lineTotal, fontSize: 12);
    }

    drawDivider(1.0);

    // --- Calculations ---
    drawTwoCol('उप-जम्मा / Subtotal:', 'Rs. ${bill.subtotal.toStringAsFixed(2)}');
    if (bill.discountAmount > 0) {
      drawTwoCol('छुट / Discount:', '- Rs. ${bill.discountAmount.toStringAsFixed(2)}');
    }
    if (isVat) {
      drawTwoCol('करयोग्य रकम / Taxable:', 'Rs. ${bill.taxableAmount.toStringAsFixed(2)}');
      drawTwoCol('१३% भ्याट / 13% VAT:', 'Rs. ${bill.vatAmount.toStringAsFixed(2)}');
    }

    drawDivider(1.5);
    drawTwoCol('कुल जम्मा / Grand Total:', 'Rs. ${bill.grandTotal.toStringAsFixed(2)}', isBold: true, fontSize: 16);
    drawDivider(1.5);

    if (bill.inWords.isNotEmpty) {
      drawText('अक्षरूपी: ${bill.inWords}', fontSize: 11);
      drawDivider(0.8);
    }

    // --- Footer & NextGen Branding ---
    y += 6;
    drawText('धन्यवाद! फेरि पाल्नुहोला ।', fontSize: 13, align: TextAlign.center);
    drawText('Thank you for your visit!', fontSize: 11, align: TextAlign.center);

    if (config.showFooterBranding) {
      drawDivider(0.5);
      drawText('Powered by Sajilo Billing | NextGen Innovations', fontSize: 10, isBold: true, align: TextAlign.center);
      drawText('https://nextgeninnovations.com.np/ | नेपालमा निर्मित', fontSize: 9.5, align: TextAlign.center);
    }

    y += 20; // Bottom margin

    // Final height in pixels (must be integer)
    final height = y.ceil();

    // End picture recording
    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);

    if (byteData == null) {
      throw Exception('Failed to render receipt to image buffer');
    }

    final rgbaBytes = byteData.buffer.asUint8List();

    // 2. Convert RGBA buffer to monochrome 1-bit ESC/POS raster buffer
    final rasterBytes = _rgbaToMonochromeRaster(rgbaBytes, width, height);

    // 3. Assemble ESC/POS package
    final builder = BytesBuilder();
    builder.add(EscPosCommands.initialize);
    builder.add(EscPosCommands.rasterBitImageHeader(
      widthBytes: widthBytes,
      heightPixels: height,
      density: 0,
    ));
    builder.add(rasterBytes);

    // Feed lines & cut
    builder.add(EscPosCommands.feedLines(config.feedLines));
    if (config.cutPaper) {
      builder.add(EscPosCommands.cutPartial);
    }

    return builder.toBytes();
  }

  /// Converts 32-bit RGBA pixel array to 1-bit per pixel monochrome bitmap for ESC/POS raster.
  /// 1 = black dot, 0 = white paper.
  static Uint8List _rgbaToMonochromeRaster(Uint8List rgba, int width, int height) {
    final widthBytes = width ~/ 8;
    final rasterBuffer = Uint8List(widthBytes * height);

    for (int y = 0; y < height; y++) {
      for (int byteX = 0; byteX < widthBytes; byteX++) {
        int byteValue = 0;
        for (int bit = 0; bit < 8; bit++) {
          final x = (byteX * 8) + bit;
          final pixelIndex = (y * width + x) * 4;

          final r = rgba[pixelIndex];
          final g = rgba[pixelIndex + 1];
          final b = rgba[pixelIndex + 2];
          final a = rgba[pixelIndex + 3];

          // Compute luminance (0 = black, 255 = white)
          final luminance = a < 50 ? 255 : (r * 0.299 + g * 0.587 + b * 0.114);

          // ESC/POS raster: 1 = black, 0 = white
          if (luminance < 140) {
            byteValue |= (1 << (7 - bit));
          }
        }
        rasterBuffer[y * widthBytes + byteX] = byteValue;
      }
    }

    return rasterBuffer;
  }
}

