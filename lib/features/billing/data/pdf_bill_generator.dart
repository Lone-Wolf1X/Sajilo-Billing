import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/bill_model.dart';

class PdfBillGenerator {
  /// Builds the bilingual PDF document with embedded Devanagari font.
  static Future<pw.Document> generateDocument(BillData data) async {
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

    pdf.addPage(
      pw.Page(
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
              // ---------------- Header: Shop & Tax Identity ----------------
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (logoImage != null) ...[
                    pw.Container(
                      width: 58,
                      height: 58,
                      margin: const pw.EdgeInsets.only(right: 14),
                      child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                    ),
                  ],
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          data.businessName,
                          style: pw.TextStyle(
                            font: ttfBold,
                            fontSize: 18,
                            color: PdfColors.blue900,
                          ),
                        ),
                        if (data.shopAddress != null && data.shopAddress!.isNotEmpty)
                          pw.Text(
                            data.shopAddress!,
                            style: pw.TextStyle(font: ttfRegular, fontSize: 10, color: PdfColors.grey700),
                          ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'PAN/VAT (प्यान/भ्याट नं.): ${data.panVatNumber}  |  Phone (फोन): ${data.contactNumber}',
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
                        pw.Text(
                          'TAX INVOICE',
                          style: pw.TextStyle(font: ttfBold, fontSize: 12, color: PdfColors.blue900),
                        ),
                        pw.Text(
                          'कर बिजक',
                          style: pw.TextStyle(font: ttfBold, fontSize: 11, color: PdfColors.blue900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(thickness: 1, color: PdfColors.grey400),
              pw.SizedBox(height: 6),

              // ---------------- Bill Metadata Row ----------------
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: 'Customer (ग्राहक): ',
                              style: pw.TextStyle(font: ttfBold, fontSize: 9.5),
                            ),
                            pw.TextSpan(
                              text: data.customerName,
                              style: pw.TextStyle(font: ttfRegular, fontSize: 9.5),
                            ),
                          ],
                        ),
                      ),
                      if (data.customerPan != null && data.customerPan!.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.RichText(
                          text: pw.TextSpan(
                            children: [
                              pw.TextSpan(
                                text: 'Buyer PAN (खरिदकर्ता प्यान): ',
                                style: pw.TextStyle(font: ttfBold, fontSize: 9.5),
                              ),
                              pw.TextSpan(
                                text: data.customerPan!,
                                style: pw.TextStyle(font: ttfRegular, fontSize: 9.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: 'Bill No (बिल नं.): ',
                              style: pw.TextStyle(font: ttfBold, fontSize: 9.5),
                            ),
                            pw.TextSpan(
                              text: data.invoiceNumber,
                              style: pw.TextStyle(font: ttfRegular, fontSize: 9.5),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: 'Date (मिति): ',
                              style: pw.TextStyle(font: ttfBold, fontSize: 9.5),
                            ),
                            pw.TextSpan(
                              text: dateFormat.format(data.invoiceDate),
                              style: pw.TextStyle(font: ttfRegular, fontSize: 9.5),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: 'Payment Mode (भुक्तानी): ',
                              style: pw.TextStyle(font: ttfBold, fontSize: 9.5),
                            ),
                            pw.TextSpan(
                              text: data.paymentMode,
                              style: pw.TextStyle(font: ttfRegular, fontSize: 9.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 12),

              // ---------------- Items Table ----------------
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                columnWidths: {
                  0: const pw.FixedColumnWidth(36), // S.N.
                  1: const pw.FlexColumnWidth(5), // Particulars
                  2: const pw.FixedColumnWidth(44), // Qty
                  3: const pw.FixedColumnWidth(64), // Rate
                  4: const pw.FixedColumnWidth(74), // Amount
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _buildHeaderCell('क्र.सं.\nS.N.', ttfBold, align: pw.TextAlign.center),
                      _buildHeaderCell('विवरण\nParticulars', ttfBold, align: pw.TextAlign.left),
                      _buildHeaderCell('परिमाण\nQty', ttfBold, align: pw.TextAlign.center),
                      _buildHeaderCell('दर (रु.)\nRate (Rs.)', ttfBold, align: pw.TextAlign.right),
                      _buildHeaderCell('रकम (रु.)\nAmount (Rs.)', ttfBold, align: pw.TextAlign.right),
                    ],
                  ),
                  // Item Rows
                  ...data.items.map((item) {
                    return pw.TableRow(
                      children: [
                        _buildCell('${item.sn}', ttfRegular, align: pw.TextAlign.center),
                        _buildCell(item.description, ttfRegular, align: pw.TextAlign.left),
                        _buildCell('${item.quantity} ${item.unit}', ttfRegular, align: pw.TextAlign.center),
                        _buildCell(currencyFormat.format(item.rate), ttfRegular, align: pw.TextAlign.right),
                        _buildCell(currencyFormat.format(item.amount), ttfRegular, align: pw.TextAlign.right),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 10),

              // ---------------- Financial Calculations ----------------
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Left side: In Words and QR Code
                  pw.Expanded(
                    flex: 6,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.RichText(
                          text: pw.TextSpan(
                            children: [
                              pw.TextSpan(
                                text: 'In Words (अक्षरेपी): ',
                                style: pw.TextStyle(font: ttfBold, fontSize: 9.5),
                              ),
                              pw.TextSpan(
                                text: data.inWords,
                                style: pw.TextStyle(font: ttfRegular, fontSize: 9.5, color: PdfColors.grey800),
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 14),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.all(3),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
                              ),
                              child: pw.BarcodeWidget(
                                barcode: pw.Barcode.qrCode(),
                                data: data.qrData,
                                width: 72,
                                height: 72,
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'Bill Verification QR',
                                  style: pw.TextStyle(font: ttfBold, fontSize: 9),
                                ),
                                pw.Text(
                                  'बिजक प्रमाणीकरण क्यूआर',
                                  style: pw.TextStyle(font: ttfRegular, fontSize: 8.5, color: PdfColors.grey700),
                                ),
                                pw.SizedBox(height: 2),
                                pw.Text(
                                  'Scan for digital audit',
                                  style: pw.TextStyle(font: ttfRegular, fontSize: 7.5, color: PdfColors.grey600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 14),
                  // Right side: Totals Table
                  pw.Expanded(
                    flex: 4,
                    child: pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                      columnWidths: {
                        0: const pw.FlexColumnWidth(5),
                        1: const pw.FlexColumnWidth(5),
                      },
                      children: [
                        _buildTotalRow('उप-जम्मा / Subtotal', currencyFormat.format(data.subtotal), ttfRegular, ttfRegular),
                        _buildTotalRow('छुट / Discount', '- ${currencyFormat.format(data.discountAmount)}', ttfRegular, ttfRegular),
                        _buildTotalRow('करयोग्य रकम / Taxable', currencyFormat.format(data.taxableAmount), ttfRegular, ttfRegular),
                        _buildTotalRow('१३% भ्याट / 13% VAT', currencyFormat.format(data.vatAmount), ttfRegular, ttfRegular),
                        _buildTotalRow(
                          'कुल जम्मा / Grand Total',
                          'Rs. ${currencyFormat.format(data.grandTotal)}',
                          ttfBold,
                          ttfBold,
                          bgColor: PdfColors.grey200,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Spacer(),

              // ---------------- Footer Signatures & Greeting ----------------
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'हाम्रो सेवा प्रयोग गर्नुभएकोमा धन्यवाद!',
                        style: pw.TextStyle(font: ttfBold, fontSize: 10, color: PdfColors.grey800),
                      ),
                      pw.Text(
                        'Thank you for your visit!',
                        style: pw.TextStyle(font: ttfRegular, fontSize: 9, color: PdfColors.grey600),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 140,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(color: PdfColors.grey700, width: 1)),
                        ),
                        padding: const pw.EdgeInsets.only(top: 4),
                        child: pw.Column(
                          children: [
                            pw.Text(
                              'Authorized Signatory',
                              style: pw.TextStyle(font: ttfBold, fontSize: 9),
                              textAlign: pw.TextAlign.center,
                            ),
                            pw.Text(
                              'अधिकृत हस्ताक्षर',
                              style: pw.TextStyle(font: ttfRegular, fontSize: 8.5),
                              textAlign: pw.TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeaderCell(String text, pw.Font font, {required pw.TextAlign align}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(font: font, fontSize: 8.5, color: PdfColors.blue900),
      ),
    );
  }

  static pw.Widget _buildCell(String text, pw.Font font, {required pw.TextAlign align}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(font: font, fontSize: 9),
      ),
    );
  }

  static pw.TableRow _buildTotalRow(
    String label,
    String value,
    pw.Font labelFont,
    pw.Font valueFont, {
    PdfColor? bgColor,
  }) {
    return pw.TableRow(
      decoration: bgColor != null ? pw.BoxDecoration(color: bgColor) : null,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: pw.Text(
            label,
            style: pw.TextStyle(font: labelFont, fontSize: 8.5),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: pw.Text(
            value,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(font: valueFont, fontSize: 8.5),
          ),
        ),
      ],
    );
  }

  /// Saves the generated bill PDF to the local application documents directory.
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

  /// Prompts user to export the generated PDF to a chosen local destination.
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
