import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/database/app_database.dart';
import '../../../core/utils/paisa_helper.dart';
import '../domain/khata_models.dart';

/// PDF generator for Khata Ledger Statements and Payment Clearance Receipts
/// with embedded Noto Sans Devanagari font and fiscal QR code.
class KhataPdfGenerator {
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

  /// Builds a bilingual Party Ledger Statement PDF.
  static Future<pw.Document> generateStatementPdf({
    required BusinessProfile business,
    required PartySummary party,
    required List<PartyLedgerData> entries,
  }) async {
    final pdf = pw.Document();

    final fontRegularData = await rootBundle.load('assets/fonts/NotoSansDevanagari-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/NotoSansDevanagari-Bold.ttf');

    final ttfRegular = pw.Font.ttf(fontRegularData);
    final ttfBold = pw.Font.ttf(fontBoldData);

    final currencyFormat = NumberFormat('#,##,##0.00', 'en_IN');
    final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    final isCustomer = party.partyType == PartyType.customer;

    final balanceRupees = party.currentBalancePaisa / 100.0;
    final inWords = PaisaHelper.paisaToWords(party.currentBalancePaisa);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        theme: pw.ThemeData.withFont(base: ttfRegular, bold: ttfBold),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // Business Header
            pw.Center(
              child: pw.Text(
                business.businessName,
                style: pw.TextStyle(font: ttfBold, fontSize: 16),
              ),
            ),
            if (business.shopAddress != null && business.shopAddress!.isNotEmpty)
              pw.Center(
                child: pw.Text(
                  business.shopAddress!,
                  style: pw.TextStyle(font: ttfRegular, fontSize: 9.5, color: PdfColors.grey700),
                ),
              ),
            pw.Center(
              child: pw.Text(
                'PAN: ${business.panVatNumber} | Phone: ${business.contactNumber}',
                style: pw.TextStyle(font: ttfRegular, fontSize: 9.5),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Divider(thickness: 1, color: PdfColors.black),
            pw.SizedBox(height: 4),

            // Document Title
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  isCustomer
                      ? 'CUSTOMER KHATA STATEMENT / ग्राहक खाता विवरण'
                      : 'SUPPLIER KHATA STATEMENT / आपूर्तिकर्ता हिसाब विवरण',
                  style: pw.TextStyle(font: ttfBold, fontSize: 11),
                ),
                pw.Text(
                  'Date: $dateStr',
                  style: pw.TextStyle(font: ttfRegular, fontSize: 9),
                ),
              ],
            ),
            pw.SizedBox(height: 8),

            // Party Information Box
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
                color: PdfColors.grey100,
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Party Name: ${party.name}',
                        style: pw.TextStyle(font: ttfBold, fontSize: 10),
                      ),
                      if (party.phone != null && party.phone!.isNotEmpty)
                        pw.Text('Phone: ${party.phone}', style: const pw.TextStyle(fontSize: 9)),
                      if (party.panVat != null && party.panVat!.isNotEmpty)
                        pw.Text('PAN: ${party.panVat}', style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        isCustomer ? 'Total Due (बाँकी):' : 'Total Payable (तिर्नुपर्ने):',
                        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
                      ),
                      pw.Text(
                        'Rs. ${currencyFormat.format(balanceRupees)}',
                        style: pw.TextStyle(font: ttfBold, fontSize: 13, color: PdfColors.red900),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
          ],
        ),
        build: (context) => [
          // Table of entries
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(2.0), // Date
              1: const pw.FlexColumnWidth(2.2), // Ref
              2: const pw.FlexColumnWidth(3.8), // Particulars
              3: const pw.FlexColumnWidth(2.0), // Debit
              4: const pw.FlexColumnWidth(2.0), // Credit
              5: const pw.FlexColumnWidth(2.2), // Balance
            },
            children: [
              // Header
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildHeaderCell('Date / मिति', ttfBold),
                  _buildHeaderCell('Ref # / भौचर नं.', ttfBold),
                  _buildHeaderCell('Particulars / विवरण', ttfBold),
                  _buildHeaderCell(isCustomer ? 'Debit / लिनुपर्ने' : 'Debit / भुक्तानी', ttfBold),
                  _buildHeaderCell(isCustomer ? 'Credit / असुली' : 'Credit / खरिद', ttfBold),
                  _buildHeaderCell('Balance / बाँकी', ttfBold),
                ],
              ),
              // Rows
              ...entries.map((e) {
                final rowDate = DateFormat('yyyy-MM-dd').format(e.entryDate.toLocal());
                final amtStr = currencyFormat.format(e.amountPaisa / 100.0);
                final balStr = currencyFormat.format(e.balanceAfterPaisa / 100.0);

                final isDebit = (isCustomer && e.entryType == 'sale_credit') ||
                    (!isCustomer && e.entryType == 'payment_made');

                return pw.TableRow(
                  children: [
                    _buildDataCell(rowDate, ttfRegular),
                    _buildDataCell(e.refNumber ?? '-', ttfRegular),
                    _buildDataCell(e.notes ?? e.entryType, ttfRegular),
                    _buildDataCell(isDebit ? amtStr : '-', ttfRegular, alignRight: true),
                    _buildDataCell(!isDebit ? amtStr : '-', ttfRegular, alignRight: true),
                    _buildDataCell(balStr, ttfBold, alignRight: true),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 16),

          // Footer summary & In Words
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('In Words / अक्षरेपी: $inWords', style: pw.TextStyle(font: ttfRegular, fontSize: 9.5)),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'This is a computer-generated ledger statement from Sajilo Billing.',
                        style: pw.TextStyle(font: ttfRegular, fontSize: 8, color: PdfColors.grey600),
                      ),
                    ],
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(3),
                  decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400, width: 0.5)),
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: 'KHATA|${party.id}|${party.currentBalancePaisa}|${business.panVatNumber}',
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf;
  }

  /// Builds a single payment clearance receipt PDF.
  static Future<pw.Document> generatePaymentReceiptPdf({
    required BusinessProfile business,
    required PartyPayment payment,
    required String partyName,
    required int currentRemainingBalancePaisa,
  }) async {
    final pdf = pw.Document();

    final fontRegularData = await rootBundle.load('assets/fonts/NotoSansDevanagari-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/NotoSansDevanagari-Bold.ttf');

    final ttfRegular = pw.Font.ttf(fontRegularData);
    final ttfBold = pw.Font.ttf(fontBoldData);

    final currencyFormat = NumberFormat('#,##,##0.00', 'en_IN');
    final pDateStr = DateFormat('yyyy-MM-dd HH:mm').format(payment.paymentDate.toLocal());
    final amountRupees = payment.amountPaisa / 100.0;
    final inWords = PaisaHelper.paisaToWords(payment.amountPaisa);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.all(20),
        theme: pw.ThemeData.withFont(base: ttfRegular, bold: ttfBold),
        build: (context) => pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 1),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Header
              pw.Center(
                child: pw.Text(
                  business.businessName,
                  style: pw.TextStyle(font: ttfBold, fontSize: 14),
                ),
              ),
              if (business.shopAddress != null)
                pw.Center(
                  child: pw.Text(business.shopAddress!, style: const pw.TextStyle(fontSize: 8.5)),
                ),
              pw.Center(
                child: pw.Text('PAN: ${business.panVatNumber} | Phone: ${business.contactNumber}', style: const pw.TextStyle(fontSize: 8.5)),
              ),
              pw.SizedBox(height: 6),
              pw.Divider(thickness: 0.5),

              // Title
              pw.Center(
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  child: pw.Text(
                    'MONEY RECEIPT / रकम भुक्तानी रसिद',
                    style: pw.TextStyle(font: ttfBold, fontSize: 10),
                  ),
                ),
              ),
              pw.SizedBox(height: 10),

              // Meta
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Receipt No: ${payment.receiptNumber}', style: pw.TextStyle(font: ttfBold, fontSize: 9)),
                  pw.Text('Date: $pDateStr', style: const pw.TextStyle(fontSize: 8.5)),
                ],
              ),
              pw.SizedBox(height: 10),

              // Body
              pw.Text('Received with thanks from: $partyName', style: pw.TextStyle(font: ttfBold, fontSize: 9.5)),
              pw.SizedBox(height: 4),
              pw.Text('Amount (in figures): Rs. ${currencyFormat.format(amountRupees)}', style: pw.TextStyle(font: ttfBold, fontSize: 11, color: PdfColors.blue900)),
              pw.SizedBox(height: 4),
              pw.Text('Amount (in words): $inWords', style: const pw.TextStyle(fontSize: 9)),
              pw.SizedBox(height: 4),
              pw.Text('Payment Mode: ${payment.paymentMode.toUpperCase()}', style: const pw.TextStyle(fontSize: 9)),
              if (payment.notes != null && payment.notes!.isNotEmpty)
                pw.Text('Remarks: ${payment.notes!}', style: const pw.TextStyle(fontSize: 8.5)),
              pw.SizedBox(height: 6),
              pw.Text('Remaining Balance: Rs. ${currencyFormat.format(currentRemainingBalancePaisa / 100.0)}', style: pw.TextStyle(font: ttfBold, fontSize: 9)),

              pw.Spacer(),

              // Signatures
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: 'REC|${payment.receiptNumber}|${payment.amountPaisa}|${business.panVatNumber}',
                    width: 44,
                    height: 44,
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Container(width: 100, height: 1, color: PdfColors.black),
                      pw.SizedBox(height: 2),
                      pw.Text('Authorized Signature', style: const pw.TextStyle(fontSize: 8)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeaderCell(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: 8.5),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildDataCell(String text, pw.Font font, {bool alignRight = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: 8.5),
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
      ),
    );
  }
}

