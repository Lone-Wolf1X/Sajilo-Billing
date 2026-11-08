import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/paisa_helper.dart';
import '../domain/bill_model.dart';

enum BillTemplateStyle {
  nepaliPad('nepali_pad', 'Nepali Traditional Pad / नेपाली बिल प्याड'),
  englishPad('english_pad', 'English Traditional Pad / अंग्रेजी बिल प्याड'),
  nepaliWhiteRed('nepali_white_red', 'Nepali White-Red / नेपाली सेतो-रातो'),
  englishWhiteRed('english_white_red', 'English White-Red / अंग्रेजी सेतो-रातो');

  final String id;
  final String label;
  const BillTemplateStyle(this.id, this.label);
}

class HtmlBillGenerator {
  HtmlBillGenerator._();

  static const List<String> _devanagariDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];

  /// Converts an English integer or string with digits to Nepali Devanagari numerals
  static String toDevanagariNumerals(dynamic input) {
    final str = input.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final codeUnit = str.codeUnitAt(i);
      if (codeUnit >= 48 && codeUnit <= 57) {
        buffer.write(_devanagariDigits[codeUnit - 48]);
      } else {
        buffer.write(str[i]);
      }
    }
    return buffer.toString();
  }

  /// Generates self-contained HTML for printing or previewing
  static String generateHtml(BillData bill, {BillTemplateStyle style = BillTemplateStyle.nepaliPad}) {
    final isNepali = style == BillTemplateStyle.nepaliPad || style == BillTemplateStyle.nepaliWhiteRed;
    final isPad = style == BillTemplateStyle.nepaliPad || style == BillTemplateStyle.englishPad;

    // Convert logo bytes to Base64
    final String? logoSrc = bill.logoBytes != null && bill.logoBytes!.isNotEmpty
        ? 'data:image/png;base64,${base64Encode(bill.logoBytes!)}'
        : null;

    final primaryColor = isPad ? '#561131' : '#c62828';
    final paperBg = isPad ? '#f2bac9' : '#ffffff';
    final borderColor = isPad ? '#561131' : '#c62828';

    final invoiceNum = isNepali && isPad ? toDevanagariNumerals(bill.invoiceNumber) : bill.invoiceNumber;
    final formattedDate = bill.invoiceDate.toIso8601String().split('T').first;
    final displayDate = isNepali && isPad ? toDevanagariNumerals(formattedDate) : formattedDate;

    // 9-digit PAN split
    final panStr = (bill.panVatNumber).padRight(9, ' ').substring(0, 9);
    final panBoxesHtml = panStr.split('').map((char) {
      final disp = isNepali && isPad && char.trim().isNotEmpty ? toDevanagariNumerals(char) : char;
      return '<span class="pan-box">$disp</span>';
    }).join('');

    // Table rows
    final rowsBuffer = StringBuffer();
    for (int i = 0; i < bill.items.length; i++) {
      final item = bill.items[i];
      final sn = isNepali && isPad ? toDevanagariNumerals(i + 1) : '${i + 1}';
      final qty = isNepali && isPad ? toDevanagariNumerals(item.quantity) : '${item.quantity}';
      final rate = isNepali && isPad
          ? toDevanagariNumerals(item.rate.toStringAsFixed(2))
          : item.rate.toStringAsFixed(2);
      final amt = isNepali && isPad
          ? toDevanagariNumerals(item.amount.toStringAsFixed(2))
          : item.amount.toStringAsFixed(2);

      rowsBuffer.write('''
        <tr class="item-row">
          <td class="col-sn">$sn</td>
          <td class="col-desc">${item.description}</td>
          <td class="col-qty">$qty ${item.unit}</td>
          <td class="col-rate">$rate</td>
          <td class="col-total">$amt</td>
        </tr>
      ''');
    }

    // Spacer rows to give physical receipt pad look (min 6 rows total)
    final remainingRows = 6 - bill.items.length;
    for (int i = 0; i < remainingRows; i++) {
      rowsBuffer.write('''
        <tr class="item-row spacer-row">
          <td class="col-sn">&nbsp;</td>
          <td class="col-desc">&nbsp;</td>
          <td class="col-qty">&nbsp;</td>
          <td class="col-rate">&nbsp;</td>
          <td class="col-total">&nbsp;</td>
        </tr>
      ''');
    }

    final grandTotalStr = isNepali && isPad
        ? toDevanagariNumerals(bill.grandTotal.toStringAsFixed(2))
        : bill.grandTotal.toStringAsFixed(2);

    final inWords = PaisaHelper.paisaToWords(PaisaHelper.toPaisa(bill.grandTotal));

    return '''<!DOCTYPE html>
<html lang="${isNepali ? 'ne' : 'en'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${bill.invoiceNumber} - ${bill.businessName}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Mukta:wght@400;600;700;800&family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
  <style>
    :root {
      --primary: $primaryColor;
      --paper-bg: $paperBg;
      --border: $borderColor;
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      background: #2b2f3a;
      font-family: ${isNepali ? "'Mukta', sans-serif" : "'Inter', sans-serif"};
      color: var(--primary);
      display: flex;
      flex-direction: column;
      align-items: center;
      min-height: 100vh;
      padding: 20px 10px;
    }
    .print-actions {
      display: flex;
      gap: 12px;
      margin-bottom: 16px;
      background: #ffffff;
      padding: 10px 20px;
      border-radius: 30px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.25);
    }
    .btn {
      font-family: inherit;
      font-size: 14px;
      font-weight: 700;
      padding: 8px 18px;
      border-radius: 20px;
      border: 1px solid #ddd;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background: #f8fafc;
      color: #1e293b;
    }
    .btn-primary { background: var(--primary); color: #fff; border-color: var(--primary); }
    .bill-wrapper {
      width: 100%;
      max-width: 580px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.4);
      background: var(--paper-bg);
      border: 1px solid var(--border);
      padding: 20px 24px 16px 24px;
    }
    .header-logo { text-align: center; margin-bottom: 8px; }
    .header-logo img { max-height: 48px; max-width: 140px; object-fit: contain; }
    .company-title {
      text-align: center;
      font-size: 24px;
      font-weight: 800;
      line-height: 1.2;
      margin-bottom: 2px;
    }
    .company-address { text-align: center; font-size: 14px; font-weight: 600; margin-bottom: 12px; }
    .info-grid { display: flex; flex-direction: column; gap: 6px; font-size: 14px; font-weight: 600; margin-bottom: 12px; }
    .info-row { display: flex; align-items: baseline; width: 100%; }
    .info-row-between { display: flex; justify-content: space-between; align-items: baseline; width: 100%; }
    .field-label { white-space: nowrap; margin-right: 6px; font-weight: 700; }
    .dotted-line { flex: 1; border-bottom: 1px dotted var(--primary); padding-left: 6px; min-height: 14px; }
    .pan-boxes { display: inline-flex; border: 1px solid var(--primary); margin-left: 8px; }
    .pan-box { width: 24px; height: 24px; border-right: 1px solid var(--primary); display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; }
    .pan-box:last-child { border-right: none; }
    
    .bill-table { width: 100%; border-collapse: collapse; border: 1px solid var(--primary); margin-bottom: 12px; }
    .bill-table th, .bill-table td { border: 1px solid var(--primary); padding: 5px 6px; font-size: 13.5px; }
    .bill-table th { background: rgba(0,0,0,0.03); font-weight: 700; }
    .col-sn { width: 40px; text-align: center; }
    .col-desc { text-align: left; }
    .col-qty { width: 75px; text-align: center; }
    .col-rate { width: 85px; text-align: right; }
    .col-total { width: 100px; text-align: right; font-weight: 700; }
    .spacer-row td { height: 22px; border-top: none; border-bottom: none; }
    .total-row td { font-weight: 800; font-size: 15px; }

    .bill-footer { display: flex; justify-content: space-between; align-items: flex-end; margin-top: 14px; padding-top: 8px; }
    .signature { text-align: center; font-size: 13px; font-weight: 700; border-top: 1px dotted var(--primary); width: 140px; padding-top: 4px; }

    @page { size: auto; margin: 4mm 5mm; }
    @media print {
      body { background: transparent !important; padding: 0 !important; }
      .print-actions { display: none !important; }
      .bill-wrapper { box-shadow: none !important; border: 1px solid var(--primary) !important; max-width: 100% !important; margin: 0 auto !important; }
    }
  </style>
</head>
<body>
  <div class="print-actions">
    <button class="btn btn-primary" onclick="window.print()">🖨️ ${isNepali ? 'प्रिन्ट गर्नुहोस् (Print)' : 'Print Bill'}</button>
    <button class="btn" onclick="window.close()">${isNepali ? 'बन्द गर्नुहोस्' : 'Close'}</button>
  </div>

  <div class="bill-wrapper">
    ${logoSrc != null ? '<div class="header-logo"><img src="$logoSrc" alt="Logo" /></div>' : ''}
    <div class="company-title">${bill.businessName}</div>
    <div class="company-address">${bill.shopAddress ?? ''} | ${bill.contactNumber}</div>

    <div class="info-grid">
      <div class="info-row-between">
        <div class="info-row" style="flex: 0 0 48%;">
          <span class="field-label">${isNepali ? 'बिल नं. :' : 'Bill No. :'}</span>
          <span class="dotted-line">$invoiceNum</span>
        </div>
        <div class="info-row" style="flex: 0 0 48%;">
          <span class="field-label">${isNepali ? 'मिति :' : 'Date :'}</span>
          <span class="dotted-line">$displayDate</span>
        </div>
      </div>
      <div class="info-row">
        <span class="field-label">${isNepali ? 'पान नं.' : 'PAN No.'}</span>
        <div class="pan-boxes">$panBoxesHtml</div>
      </div>
      <div class="info-row">
        <span class="field-label">${isNepali ? 'ग्राहकको नाम :' : "Customer's Name :"}</span>
        <span class="dotted-line">${bill.customerName}</span>
      </div>
    </div>

    <table class="bill-table">
      <thead>
        <tr>
          <th class="col-sn">${isNepali ? 'क्र.सं.' : 'S.N.'}</th>
          <th class="col-desc">${isNepali ? 'विवरण' : 'Particulars'}</th>
          <th class="col-qty">${isNepali ? 'परिमाण' : 'Qty'}</th>
          <th class="col-rate">${isNepali ? 'दर' : 'Rate'}</th>
          <th class="col-total">${isNepali ? 'जम्मा' : 'Total'}</th>
        </tr>
      </thead>
      <tbody>
        ${rowsBuffer.toString()}
        <tr class="total-row">
          <td colspan="4" style="text-align: right; padding-right: 12px;">${isNepali ? 'कुल जम्मा (Total):' : 'Grand Total:'}</td>
          <td class="col-total">Rs. $grandTotalStr</td>
        </tr>
      </tbody>
    </table>

    <div style="font-size: 12.5px; font-weight: 600; margin-bottom: 8px;">
      <b>${isNepali ? 'अक्षरेपी :' : 'In Words :'}</b> $inWords
    </div>

    <div class="bill-footer">
      <div style="font-size: 11px; font-weight: 500; opacity: 0.85;">
        ${isNepali ? 'धन्यवाद ! फेरि आउनुहोला ।' : 'Thank you for your visit!'}
      </div>
      <div class="signature">
        ${isNepali ? 'हस्ताक्षर (Authorized)' : 'Authorized Signature'}
      </div>
    </div>
  </div>
</body>
</html>''';
  }

  /// Opens the rendered HTML in the system default browser for instant Ctrl+P printing
  static Future<String?> printOrPreviewHtml(
    BillData bill, {
    BillTemplateStyle style = BillTemplateStyle.nepaliPad,
  }) async {
    final html = generateHtml(bill, style: style);

    if (kIsWeb) {
      // On web, open as a blob/data URI or new tab
      final uri = Uri.dataFromString(html, mimeType: 'text/html', encoding: utf8);
      await launchUrl(uri);
      return 'web_preview';
    }

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/invoice_${bill.invoiceNumber}_${style.id}.html');
    await file.writeAsString(html);

    final uri = Uri.file(file.path);
    await launchUrl(uri);
    return file.path;
  }
}
