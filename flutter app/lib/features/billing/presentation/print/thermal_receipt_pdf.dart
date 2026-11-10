import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../printing/domain/print_format.dart';
import 'receipt_data.dart';

/// Generates printable PDF documents for POS receipts (80mm, 58mm, or A4).
class ThermalReceiptPdf {
  /// Generate a PDF document from [ReceiptData] for the requested [PrintFormat].
  static Future<pw.Document> generateDocument(
    ReceiptData data, {
    PrintFormat format = PrintFormat.thermal80,
  }) async {
    // Load Unicode Devanagari fonts so Nepali characters render properly
    final regularFontData =
        await rootBundle.load('assets/fonts/NotoSansDevanagari-Regular.ttf');
    final boldFontData =
        await rootBundle.load('assets/fonts/NotoSansDevanagari-Bold.ttf');

    final ttfRegular = pw.Font.ttf(regularFontData);
    final ttfBold = pw.Font.ttf(boldFontData);

    final pdf = pw.Document();

    switch (format) {
      case PrintFormat.thermal58:
        pdf.addPage(
          _buildThermalPage(
            data,
            ttfRegular,
            ttfBold,
            pageFormat: const PdfPageFormat(
              58 * PdfPageFormat.mm,
              double.infinity,
              marginAll: 2 * PdfPageFormat.mm,
            ),
            is58mm: true,
          ),
        );
        break;

      case PrintFormat.thermal80:
        pdf.addPage(
          _buildThermalPage(
            data,
            ttfRegular,
            ttfBold,
            pageFormat: const PdfPageFormat(
              80 * PdfPageFormat.mm,
              double.infinity,
              marginAll: 3 * PdfPageFormat.mm,
            ),
            is58mm: false,
          ),
        );
        break;

      case PrintFormat.a4Pdf:
        pdf.addPage(
          _buildA4Page(
            data,
            ttfRegular,
            ttfBold,
          ),
        );
        break;
    }

    return pdf;
  }

  /// Thermal roll page (58mm or 80mm)
  static pw.Page _buildThermalPage(
    ReceiptData data,
    pw.Font ttfRegular,
    pw.Font ttfBold, {
    required PdfPageFormat pageFormat,
    required bool is58mm,
  }) {
    final fontSizeTitle = is58mm ? 9.5 : 12.0;
    final fontSizeHeader = is58mm ? 7.5 : 9.0;
    final fontSizeSmall = is58mm ? 6.0 : 7.0;

    return pw.Page(
      pageFormat: pageFormat,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // Company Header
            pw.Center(
              child: pw.Text(
                data.companyNameNepali ?? data.companyName ?? 'SAISA RETAIL STORE',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: ttfBold,
                  fontSize: fontSizeTitle,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            if (data.companyName != null && data.companyNameNepali != null)
              pw.Center(
                child: pw.Text(
                  data.companyName!,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: ttfRegular,
                    fontSize: fontSizeHeader,
                  ),
                ),
              ),
            if (data.companyAddress != null)
              pw.Center(
                child: pw.Text(
                  data.companyAddress!,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: ttfRegular,
                    fontSize: fontSizeSmall,
                  ),
                ),
              ),
            if (data.companyPanVat != null)
              pw.Center(
                child: pw.Text(
                  'PAN / VAT: ${data.companyPanVat}',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: ttfBold,
                    fontSize: fontSizeSmall,
                  ),
                ),
              ),

            pw.SizedBox(height: 3),
            pw.Center(
              child: pw.Text(
                data.isPendingSync
                    ? '*** PENDING SYNC (अभ्यास बिल) ***'
                    : 'कर बिजक (TAX INVOICE)',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: ttfBold,
                  fontSize: fontSizeHeader,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            if (data.isPendingSync) ...[
              pw.SizedBox(height: 2),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 0.5, style: pw.BorderStyle.dashed),
                ),
                child: pw.Text(
                  'OFFLINE BILL: Not yet verified by IRD / SAISA backend.',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(font: ttfRegular, fontSize: fontSizeSmall),
                ),
              ),
            ],

            pw.SizedBox(height: 3),
            _dashedDivider(),

            // Meta Info
            _kvThermal('Invoice No:', data.invoiceNumber, ttfRegular, ttfBold, fontSizeSmall),
            _kvThermal('Date:', data.invoiceDate, ttfRegular, ttfRegular, fontSizeSmall),
            _kvThermal('Customer:', data.customerName, ttfRegular, ttfBold, fontSizeSmall),
            if (data.customerPan != null && data.customerPan!.isNotEmpty)
              _kvThermal('Cust PAN:', data.customerPan!, ttfRegular, ttfRegular, fontSizeSmall),

            _dashedDivider(),

            // Table Header
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 5,
                  child: pw.Text('Item / विवरण', style: pw.TextStyle(font: ttfBold, fontSize: fontSizeSmall)),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text('Qty', textAlign: pw.TextAlign.right, style: pw.TextStyle(font: ttfBold, fontSize: fontSizeSmall)),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text('Rate', textAlign: pw.TextAlign.right, style: pw.TextStyle(font: ttfBold, fontSize: fontSizeSmall)),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text('Total', textAlign: pw.TextAlign.right, style: pw.TextStyle(font: ttfBold, fontSize: fontSizeSmall)),
                ),
              ],
            ),
            _dashedDivider(),

            // Table Lines
            ...data.lines.map((l) {
              return pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 5,
                      child: pw.Text(
                        l.name,
                        style: pw.TextStyle(font: ttfRegular, fontSize: fontSizeSmall),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        l.quantity.toStringAsFixed(l.quantity % 1 == 0 ? 0 : 2),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: ttfRegular, fontSize: fontSizeSmall),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        l.unitPrice.toStringAsFixed(2),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: ttfRegular, fontSize: fontSizeSmall),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        double.parse(l.lineTotal).toStringAsFixed(2),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: ttfBold, fontSize: fontSizeSmall),
                      ),
                    ),
                  ],
                ),
              );
            }),

            _dashedDivider(),

            // Totals
            _totalRow('Subtotal (कर योग्य):', 'Rs. ${double.parse(data.totals.subtotal).toStringAsFixed(2)}', ttfRegular, fontSizeSmall),
            _totalRow('13% VAT (१३% भ्याट):', 'Rs. ${double.parse(data.totals.taxAmount).toStringAsFixed(2)}', ttfRegular, fontSizeSmall),
            _dashedDivider(),
            _totalRow('GRAND TOTAL (कुल रकम):', 'Rs. ${double.parse(data.totals.totalAmount).toStringAsFixed(2)}', ttfBold, fontSizeHeader, bold: true),
            _dashedDivider(),

            // Footer
            pw.SizedBox(height: 4),
            pw.Center(
              child: pw.Text(
                'Thank you for your visit! धन्यवाद!',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: ttfRegular, fontSize: fontSizeSmall),
              ),
            ),
            pw.Center(
              child: pw.Text(
                'Powered by SAISA Double-Entry Cloud',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: ttfRegular, fontSize: fontSizeSmall * 0.85, color: PdfColors.grey700),
              ),
            ),
            pw.SizedBox(height: 6),
          ],
        );
      },
    );
  }

  /// Full-page bilingual A4 Tax Invoice
  static pw.Page _buildA4Page(
    ReceiptData data,
    pw.Font ttfRegular,
    pw.Font ttfBold,
  ) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // Company Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      data.companyNameNepali ?? data.companyName ?? 'SAISA RETAIL STORE',
                      style: pw.TextStyle(font: ttfBold, fontSize: 18, fontWeight: pw.FontWeight.bold),
                    ),
                    if (data.companyName != null)
                      pw.Text(
                        data.companyName!,
                        style: pw.TextStyle(font: ttfRegular, fontSize: 12),
                      ),
                    if (data.companyAddress != null)
                      pw.Text(
                        data.companyAddress!,
                        style: pw.TextStyle(font: ttfRegular, fontSize: 10, color: PdfColors.grey700),
                      ),
                    if (data.companyPanVat != null)
                      pw.Text(
                        'PAN / VAT No: ${data.companyPanVat}',
                        style: pw.TextStyle(font: ttfBold, fontSize: 10),
                      ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: pw.BoxDecoration(
                        color: data.isPendingSync ? PdfColors.orange50 : PdfColors.teal50,
                        border: pw.Border.all(
                          color: data.isPendingSync ? PdfColors.orange800 : PdfColors.teal800,
                        ),
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(
                        data.isPendingSync ? 'PENDING SYNC (अभ्यास बिल)' : 'कर बिजक (TAX INVOICE)',
                        style: pw.TextStyle(
                          font: ttfBold,
                          fontSize: 12,
                          color: data.isPendingSync ? PdfColors.orange900 : PdfColors.teal900,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text('Invoice #: ${data.invoiceNumber}', style: pw.TextStyle(font: ttfBold, fontSize: 11)),
                    pw.Text('Date: ${data.invoiceDate}', style: pw.TextStyle(font: ttfRegular, fontSize: 10)),
                  ],
                ),
              ],
            ),
            pw.Divider(thickness: 1.5, color: PdfColors.teal800),
            pw.SizedBox(height: 8),

            // Customer Details Box
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Customer / खरिदकर्ता:', style: pw.TextStyle(font: ttfRegular, fontSize: 10, color: PdfColors.grey700)),
                      pw.Text(data.customerName, style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                    ],
                  ),
                  if (data.customerPan != null && data.customerPan!.isNotEmpty)
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Customer PAN / भ्याट नं:', style: pw.TextStyle(font: ttfRegular, fontSize: 10, color: PdfColors.grey700)),
                        pw.Text(data.customerPan!, style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                      ],
                    ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),

            // Table of items
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FlexColumnWidth(4),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(1.5),
                4: const pw.FlexColumnWidth(2),
                5: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _cellHeader('S.N.', ttfBold),
                    _cellHeader('Item Description / विवरण', ttfBold, align: pw.TextAlign.left),
                    _cellHeader('SKU', ttfBold, align: pw.TextAlign.left),
                    _cellHeader('Qty', ttfBold),
                    _cellHeader('Rate (Rs.)', ttfBold),
                    _cellHeader('Amount (Rs.)', ttfBold),
                  ],
                ),
                ...data.lines.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final l = entry.value;
                  return pw.TableRow(
                    children: [
                      _cell('$idx', ttfRegular),
                      _cell(l.name, ttfRegular, align: pw.TextAlign.left),
                      _cell(l.sku, ttfRegular, align: pw.TextAlign.left),
                      _cell(l.quantity.toStringAsFixed(l.quantity % 1 == 0 ? 0 : 2), ttfRegular),
                      _cell(l.unitPrice.toStringAsFixed(2), ttfRegular),
                      _cell(double.parse(l.lineTotal).toStringAsFixed(2), ttfBold),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 12),

            // Totals breakdown on bottom-right
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.SizedBox(
                  width: 250,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      _totalA4Row('Taxable Amount (कर योग्य):', double.parse(data.totals.subtotal).toStringAsFixed(2), ttfRegular),
                      _totalA4Row('13% VAT Amount (भ्याट):', double.parse(data.totals.taxAmount).toStringAsFixed(2), ttfRegular),
                      pw.Divider(color: PdfColors.grey600),
                      _totalA4Row('Grand Total (कुल रकम):', 'Rs. ${double.parse(data.totals.totalAmount).toStringAsFixed(2)}', ttfBold, isBold: true),
                    ],
                  ),
                ),
              ],
            ),

            pw.Spacer(),

            // Signatures & Footer
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 25),
                    pw.Text('---------------------------', style: pw.TextStyle(font: ttfRegular)),
                    pw.Text('Customer Signature', style: pw.TextStyle(font: ttfRegular, fontSize: 9)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.SizedBox(height: 25),
                    pw.Text('---------------------------', style: pw.TextStyle(font: ttfRegular)),
                    pw.Text('Authorized Signature', style: pw.TextStyle(font: ttfRegular, fontSize: 9)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                'This is an authorized Tax Invoice generated via SAISA Accounting System.',
                style: pw.TextStyle(font: ttfRegular, fontSize: 8, color: PdfColors.grey600),
              ),
            ),
          ],
        );
      },
    );
  }

  static pw.Widget _dashedDivider() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Divider(thickness: 0.5, borderStyle: pw.BorderStyle.dashed),
    );
  }

  static pw.Widget _kvThermal(
    String k,
    String v,
    pw.Font fontKey,
    pw.Font fontVal,
    double fontSize,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(k, style: pw.TextStyle(font: fontKey, fontSize: fontSize)),
          pw.Text(v, style: pw.TextStyle(font: fontVal, fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  static pw.Widget _totalRow(
    String k,
    String v,
    pw.Font font,
    double fontSize, {
    bool bold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(k, style: pw.TextStyle(font: font, fontSize: fontSize, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
          pw.Text(v, style: pw.TextStyle(font: font, fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  static pw.Widget _cellHeader(String text, pw.Font font, {pw.TextAlign align = pw.TextAlign.center}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(font: font, fontSize: 9, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _cell(String text, pw.Font font, {pw.TextAlign align = pw.TextAlign.center}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(font: font, fontSize: 9),
      ),
    );
  }

  static pw.Widget _totalA4Row(String k, String v, pw.Font font, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(k, style: pw.TextStyle(font: font, fontSize: isBold ? 11 : 10, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
          pw.Text(v, style: pw.TextStyle(font: font, fontSize: isBold ? 12 : 10, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}
