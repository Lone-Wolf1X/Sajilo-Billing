import '../../application/pos_billing_service.dart';
import '../../application/pos_cart_calculator.dart';

/// Unified receipt model for printing.
/// Works for both synced (server invoice number) and pending (local number) bills.
class ReceiptData {
  final String invoiceNumber;
  final bool isPendingSync;
  final String invoiceDate; // ISO date
  final String customerName;
  final String? customerPan;
  final List<ReceiptLine> lines;
  final PosCartTotals totals;
  final String? companyName;
  final String? companyNameNepali;
  final String? companyPanVat;
  final String? companyAddress;

  const ReceiptData({
    required this.invoiceNumber,
    required this.isPendingSync,
    required this.invoiceDate,
    required this.customerName,
    this.customerPan,
    required this.lines,
    required this.totals,
    this.companyName,
    this.companyNameNepali,
    this.companyPanVat,
    this.companyAddress,
  });
}

class ReceiptLine {
  final String name;
  final String sku;
  final double quantity;
  final double unitPrice;
  final String lineTotal;
  final String lineTax;

  const ReceiptLine({
    required this.name,
    required this.sku,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.lineTax,
  });
}

/// Factory methods for building ReceiptData
class ReceiptDataBuilder {
  /// From a submitted bill result (works for both synced + queued).
  static ReceiptData fromBillResult({
    required PosBillResult result,
    required List<PosCartLine> cartLines,
    required String customerName,
    String? customerPan,
    String? companyName,
    String? companyNameNepali,
    String? companyPanVat,
    String? companyAddress,
    required String invoiceDate,
  }) {
    final receiptLines = cartLines.map((l) {
      final totals = PosCartCalculator.computeLine(l);
      return ReceiptLine(
        name: l.name,
        sku: l.sku,
        quantity: l.quantity,
        unitPrice: l.unitPrice,
        lineTotal: totals.lineTotal,
        lineTax: totals.lineTax,
      );
    }).toList();

    return ReceiptData(
      invoiceNumber: result.serverInvoiceNumber ?? result.localNumber,
      isPendingSync: !result.syncSucceeded,
      invoiceDate: invoiceDate,
      customerName: customerName,
      customerPan: customerPan,
      lines: receiptLines,
      totals: result.totals,
      companyName: companyName,
      companyNameNepali: companyNameNepali,
      companyPanVat: companyPanVat,
      companyAddress: companyAddress,
    );
  }

  /// From a full backend invoice response (for reprint).
  static ReceiptData fromServerInvoice({
    required Map<String, dynamic> invoiceJson,
    required String customerName,
    String? customerPan,
    String? companyName,
    String? companyNameNepali,
    String? companyPanVat,
    String? companyAddress,
  }) {
    final linesJson = (invoiceJson['lines'] as List<dynamic>? ?? []);
    final lines = linesJson.map((l) {
      final m = l as Map<String, dynamic>;
      return ReceiptLine(
        name: m['description'] as String? ?? '—',
        sku: '${m['itemId'] ?? ''}',
        quantity: double.tryParse(m['quantity']?.toString() ?? '0') ?? 0,
        unitPrice: double.tryParse(m['unitPrice']?.toString() ?? '0') ?? 0,
        lineTotal: m['lineTotal']?.toString() ?? '0.0000',
        lineTax: m['lineTax']?.toString() ?? '0.0000',
      );
    }).toList();

    return ReceiptData(
      invoiceNumber: invoiceJson['invoiceNumber'] as String? ?? '—',
      isPendingSync: false,
      invoiceDate: (invoiceJson['invoiceDate'] as String? ?? '').split('T').first,
      customerName: customerName,
      customerPan: customerPan,
      lines: lines,
      totals: PosCartTotals(
        subtotal: invoiceJson['subtotal']?.toString() ?? '0.0000',
        discountTotal: '0.0000',
        taxableAmount: invoiceJson['subtotal']?.toString() ?? '0.0000',
        taxAmount: invoiceJson['taxAmount']?.toString() ?? '0.0000',
        totalAmount: invoiceJson['totalAmount']?.toString() ?? '0.0000',
      ),
      companyName: companyName,
      companyNameNepali: companyNameNepali,
      companyPanVat: companyPanVat,
      companyAddress: companyAddress,
    );
  }
}

