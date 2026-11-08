import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/bill_model.dart';

enum BillTemplate {
  /// Traditional Nepali retail store bill pad (matching Nepali PAN receipt standards).
  traditionalPanBill,

  /// Formal bilingual Tax Invoice with full 13% VAT audit breakdown.
  taxInvoice,
}

class PdfBillGenerator {
  /// Converts Arabic numbers (0-9) to Nepali Devanagari digits (०-९).
  static String toNepaliDigits(String input) {
    const map = {
      '0': '०',
      '1': '१',
      '2': '२',
      '3': '३',
      '4': '४',
      '5': '५',
      '6': '६',
      '7': '७',
      '8': '८',
      '9': '९',
    };
    return input.split('').map((c) => map[c] ?? c).join();
  }

  /// Builds a PDF document using either traditional Nepali Pan Bill or formal Tax Invoice.
  static Future<pw.Document> generateDocument(
    BillData data, {
    BillTemplate template = BillTemplate.traditionalPanBill,
  }) async {
    final regularFontData =
        await rootBundle.load('assets/fonts/NotoSansDevanagari-Regular.ttf');
    final boldFontData =
        await rootBundle.load('assets/fonts/NotoSansDevanagari-Bold.ttf');

    final ttfRegular = pw.Font.ttf(regularFontData);
    final ttfBold = pw.Font.ttf(boldFontData);

    final pdf = pw.Document();

    pw.ImageProvider? logoImage;
    if (data.logoBytes != null && data.logoBytes!.isNotEmpty) {
      logoImage = pw.MemoryImage(data.logoBytes!);
    }

    final currencyFormat = NumberFormat('#,##,##0.00', 'en_US');
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    if (template == BillTemplate.traditionalPanBill) {
      pdf.addPage(
        _buildTraditionalPanBillPage(
          data,
          ttfRegular,
          ttfBold,
          logoImage,
          currencyFormat,
          dateFormat,
        ),
      );
    } else {
      pdf.addPage(
        _buildTaxInvoicePage(
          data,
          ttfRegular,
          ttfBold,
          logoImage,
          currencyFormat,
          dateFormat,
        ),
      );
    }

    return pdf;
  }

  /// Traditional Nepali Pan Bill Pad layout (matches Bills format reference).
  static pw.Page _buildTraditionalPanBillPage(
    BillData data,
    pw.Font ttfRegular,
    pw.Font ttfBold,
    pw.ImageProvider? logoImage,
    NumberFormat currencyFormat,
    DateFormat dateFormat,
  ) {
    final panDigits = data.panVatNumber.split('');

    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      theme: pw.ThemeData.withFont(
        base: ttfRegular,
        bold: ttfBold,
      ),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // Top Right: Mobile
            pw.Align(
              alignment: pw.Alignment.topRight,
              child: pw.Text(
                'मो. ${data.contactNumber}',
                style: pw.TextStyle(font: ttfBold, fontSize: 11),
              ),
            ),
            pw.SizedBox(height: 2),

            // Center: Business Name
            pw.Center(
              child: pw.Text(
                data.businessName,
                style: pw.TextStyle(font: ttfBold, fontSize: 20, color: PdfColors.black),
                textAlign: pw.TextAlign.center,
              ),
            ),
            if (data.shopAddress != null && data.shopAddress!.isNotEmpty) ...[
              pw.SizedBox(height: 2),
              pw.Center(
                child: pw.Text(
                  data.shopAddress!,
                  style: pw.TextStyle(font: ttfRegular, fontSize: 11),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
            pw.SizedBox(height: 12),

            // Row 1: बिल नं. & मिति
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: 'बिल नं. : ',
                        style: pw.TextStyle(font: ttfBold, fontSize: 11),
                      ),
                      pw.TextSpan(
                        text: data.invoiceNumber,
                        style: pw.TextStyle(font: ttfRegular, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: 'मिति : ',
                        style: pw.TextStyle(font: ttfBold, fontSize: 11),
                      ),
                      pw.TextSpan(
                        text: dateFormat.format(data.invoiceDate),
                        style: pw.TextStyle(font: ttfRegular, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 8),

            // Row 2: पान नं. with boxed digits
            pw.Row(
              children: [
                pw.Text(
                  'पान नं.  ',
                  style: pw.TextStyle(font: ttfBold, fontSize: 11),
                ),
                ...panDigits.map((digit) {
                  return pw.Container(
                    width: 20,
                    height: 20,
                    margin: const pw.EdgeInsets.only(right: 3),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 0.8),
                    ),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      toNepaliDigits(digit),
                      style: pw.TextStyle(font: ttfBold, fontSize: 11),
                    ),
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 8),

            // Row 3: नाम (Customer Name)
            pw.Row(
              children: [
                pw.Text('नाम : ', style: pw.TextStyle(font: ttfBold, fontSize: 11)),
                pw.Expanded(
                  child: pw.Container(
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey600, width: 0.5)),
                    ),
                    padding: const pw.EdgeInsets.only(bottom: 2),
                    child: pw.Text(
                      data.customerName,
                      style: pw.TextStyle(font: ttfRegular, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 6),

            // Row 4: ठेगाना (Customer Address / PAN)
            pw.Row(
              children: [
                pw.Text('ठेगाना / प्यान : ', style: pw.TextStyle(font: ttfBold, fontSize: 11)),
                pw.Expanded(
                  child: pw.Container(
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey600, width: 0.5)),
                    ),
                    padding: const pw.EdgeInsets.only(bottom: 2),
                    child: pw.Text(
                      data.customerPan != null ? 'Buyer PAN: ${data.customerPan}' : '-',
                      style: pw.TextStyle(font: ttfRegular, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 14),

            // ---------------- Traditional Grid Table ----------------
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.8),
              columnWidths: {
                0: const pw.FixedColumnWidth(40), // क्र.सं
                1: const pw.FlexColumnWidth(5), // विवरण
                2: const pw.FixedColumnWidth(60), // परिमाण
                3: const pw.FixedColumnWidth(70), // दर
                4: const pw.FixedColumnWidth(85), // रकम
              },
              children: [
                // Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  children: [
                    _buildCellText('क्र.सं', ttfBold, align: pw.TextAlign.center),
                    _buildCellText('विवरण', ttfBold, align: pw.TextAlign.left),
                    _buildCellText('परिमाण', ttfBold, align: pw.TextAlign.center),
                    _buildCellText('दर', ttfBold, align: pw.TextAlign.right),
                    _buildCellText('रकम', ttfBold, align: pw.TextAlign.right),
                  ],
                ),
                // Item Rows
                ...data.items.map((item) {
                  return pw.TableRow(
                    children: [
                      _buildCellText('${item.sn}', ttfRegular, align: pw.TextAlign.center),
                      _buildCellText(item.description, ttfRegular, align: pw.TextAlign.left),
                      _buildCellText('${item.quantity} ${item.unit}', ttfRegular, align: pw.TextAlign.center),
                      _buildCellText(currencyFormat.format(item.rate), ttfRegular, align: pw.TextAlign.right),
                      _buildCellText(currencyFormat.format(item.amount), ttfRegular, align: pw.TextAlign.right),
                    ],
                  );
                }),
                // Total Summary Row
                pw.TableRow(
                  children: [
                    _buildCellText('', ttfRegular, align: pw.TextAlign.center),
                    _buildCellText('', ttfRegular, align: pw.TextAlign.left),
                    _buildCellText('', ttfRegular, align: pw.TextAlign.center),
                    _buildCellText('जम्मा', ttfBold, align: pw.TextAlign.right),
                    _buildCellText(currencyFormat.format(data.grandTotal), ttfBold, align: pw.TextAlign.right),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 8),

            // In Words
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'अक्षरेपी (In Words) : ',
                    style: pw.TextStyle(font: ttfBold, fontSize: 10),
                  ),
                  pw.TextSpan(
                    text: data.inWords,
                    style: pw.TextStyle(font: ttfRegular, fontSize: 10),
                  ),
                ],
              ),
            ),
            pw.Spacer(),

            // Footer Section
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                // Terms
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('➢ भूलचुक लिने दिने ।', style: pw.TextStyle(font: ttfRegular, fontSize: 10)),
                    pw.SizedBox(height: 2),
                    pw.Text('➢ बिक्री भएको समान फिर्ता हुने छैन ।', style: pw.TextStyle(font: ttfRegular, fontSize: 10)),
                  ],
                ),
                // QR & Signatory
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(2),
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey500, width: 0.5)),
                      child: pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: data.qrData,
                        width: 54,
                        height: 54,
                      ),
                    ),
                    pw.SizedBox(width: 14),
                    pw.Container(
                      width: 130,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(top: pw.BorderSide(color: PdfColors.black, width: 0.8)),
                      ),
                      padding: const pw.EdgeInsets.only(top: 4),
                      child: pw.Text(
                        'अधिकृत हस्ताक्षर',
                        style: pw.TextStyle(font: ttfBold, fontSize: 9.5),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Formal Tax Invoice page.
  static pw.Page _buildTaxInvoicePage(
    BillData data,
    pw.Font ttfRegular,
    pw.Font ttfBold,
    pw.ImageProvider? logoImage,
    NumberFormat currencyFormat,
    DateFormat dateFormat,
  ) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      theme: pw.ThemeData.withFont(
        base: ttfRegular,
        bold: ttfBold,
      ),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // Header
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (logoImage != null)
                  pw.Container(
                    width: 58,
                    height: 58,
                    margin: const pw.EdgeInsets.only(right: 14),
                    child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                  ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        data.businessName,
                        style: pw.TextStyle(font: ttfBold, fontSize: 18, color: PdfColors.blue900),
                      ),
                      if (data.shopAddress != null && data.shopAddress!.isNotEmpty)
                        pw.Text(
                          data.shopAddress!,
                          style: pw.TextStyle(font: ttfRegular, fontSize: 10, color: PdfColors.grey700),
                        ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'PAN/VAT (प्यान/भ्याट नं.): ${data.panVatNumber}  |  Phone: ${data.contactNumber}',
                        style: pw.TextStyle(font: ttfRegular, fontSize: 10, color: PdfColors.black),
                      ),
                    ],
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.blue800, width: 1),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('TAX INVOICE', style: pw.TextStyle(font: ttfBold, fontSize: 12, color: PdfColors.blue900)),
                      pw.Text('कर बिजक', style: pw.TextStyle(font: ttfBold, fontSize: 11, color: PdfColors.blue900)),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Divider(thickness: 1, color: PdfColors.grey400),
            pw.SizedBox(height: 6),

            // Metadata Row
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Customer (ग्राहक): ${data.customerName}', style: pw.TextStyle(font: ttfRegular, fontSize: 9.5)),
                    if (data.customerPan != null && data.customerPan!.isNotEmpty)
                      pw.Text('Buyer PAN (खरिदकर्ता प्यान): ${data.customerPan}', style: pw.TextStyle(font: ttfRegular, fontSize: 9.5)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Bill No (बिल नं.): ${data.invoiceNumber}', style: pw.TextStyle(font: ttfBold, fontSize: 9.5)),
                    pw.Text('Date (मिति): ${dateFormat.format(data.invoiceDate)}', style: pw.TextStyle(font: ttfRegular, fontSize: 9.5)),
                    pw.Text('Mode: ${data.paymentMode}', style: pw.TextStyle(font: ttfRegular, fontSize: 9.5)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 12),

            // Items Table
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: {
                0: const pw.FixedColumnWidth(36),
                1: const pw.FlexColumnWidth(5),
                2: const pw.FixedColumnWidth(44),
                3: const pw.FixedColumnWidth(64),
                4: const pw.FixedColumnWidth(74),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _buildCellText('क्र.सं.\nS.N.', ttfBold, align: pw.TextAlign.center),
                    _buildCellText('विवरण\nParticulars', ttfBold, align: pw.TextAlign.left),
                    _buildCellText('परिमाण\nQty', ttfBold, align: pw.TextAlign.center),
                    _buildCellText('दर\nRate', ttfBold, align: pw.TextAlign.right),
                    _buildCellText('रकम\nAmount', ttfBold, align: pw.TextAlign.right),
                  ],
                ),
                ...data.items.map((item) {
                  return pw.TableRow(
                    children: [
                      _buildCellText('${item.sn}', ttfRegular, align: pw.TextAlign.center),
                      _buildCellText(item.description, ttfRegular, align: pw.TextAlign.left),
                      _buildCellText('${item.quantity} ${item.unit}', ttfRegular, align: pw.TextAlign.center),
                      _buildCellText(currencyFormat.format(item.rate), ttfRegular, align: pw.TextAlign.right),
                      _buildCellText(currencyFormat.format(item.amount), ttfRegular, align: pw.TextAlign.right),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 10),

            // Financial Calculations
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('In Words: ${data.inWords}', style: pw.TextStyle(font: ttfRegular, fontSize: 9.5)),
                      pw.SizedBox(height: 12),
                      pw.Row(
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.all(3),
                            decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400, width: 0.5)),
                            child: pw.BarcodeWidget(barcode: pw.Barcode.qrCode(), data: data.qrData, width: 68, height: 68),
                          ),
                          pw.SizedBox(width: 8),
                          pw.Text('Fiscal Verification QR', style: pw.TextStyle(font: ttfBold, fontSize: 9)),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 14),
                Expanded(
                  flex: 4,
                  child: pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                    children: [
                      _buildTotalRow('Subtotal', currencyFormat.format(data.subtotal), ttfRegular),
                      _buildTotalRow('Discount', '- ${currencyFormat.format(data.discountAmount)}', ttfRegular),
                      _buildTotalRow('Taxable', currencyFormat.format(data.taxableAmount), ttfRegular),
                      _buildTotalRow('13% VAT', currencyFormat.format(data.vatAmount), ttfRegular),
                      _buildTotalRow('Grand Total', 'Rs. ${currencyFormat.format(data.grandTotal)}', ttfBold, bgColor: PdfColors.grey200),
                    ],
                  ),
                ),
              ],
            ),
            pw.Spacer(),

            // Footer
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('हाम्रो सेवा प्रयोग गर्नुभएकोमा धन्यवाद!', style: pw.TextStyle(font: ttfBold, fontSize: 10)),
                pw.Container(
                  width: 140,
                  decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.grey700, width: 1))),
                  padding: const pw.EdgeInsets.only(top: 4),
                  child: pw.Text('Authorized Signatory', style: pw.TextStyle(font: ttfBold, fontSize: 9), textAlign: pw.TextAlign.center),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static pw.Widget _buildCellText(String text, pw.Font font, {required pw.TextAlign align}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: pw.Text(text, textAlign: align, style: pw.TextStyle(font: font, fontSize: 9.5)),
    );
  }

  static pw.TableRow _buildTotalRow(String label, String value, pw.Font font, {PdfColor? bgColor}) {
    return pw.TableRow(
      decoration: bgColor != null ? pw.BoxDecoration(color: bgColor) : null,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: pw.Text(label, style: pw.TextStyle(font: font, fontSize: 8.5)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: pw.Text(value, textAlign: pw.TextAlign.right, style: pw.TextStyle(font: font, fontSize: 8.5)),
        ),
      ],
    );
  }

  /// Saves PDF bytes to application documents folder.
  static Future<File> saveToAppDocuments(BillData data, Uint8List bytes) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final billsDir = Directory(p.join(docsDir.path, 'SajiloBilling', 'bills'));
    if (!await billsDir.exists()) {
      await billsDir.create(recursive: true);
    }
    final file = File(p.join(billsDir.path, '${data.invoiceNumber}.pdf'));
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Prompts user to export PDF via native desktop save dialog.
  static Future<String?> exportPdf(BillData data, Uint8List bytes) async {
    final suggestedName = '${data.invoiceNumber}.pdf';
    final location = await getSaveLocation(
      suggestedName: suggestedName,
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'PDF Document',
          extensions: ['pdf'],
        )
      ],
    );

    if (location == null) return null;

    final targetFile = File(location.path);
    await targetFile.writeAsBytes(bytes);
    return targetFile.path;
  }
}
