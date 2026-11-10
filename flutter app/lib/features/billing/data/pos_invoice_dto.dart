import '../application/pos_cart_calculator.dart';

/// Builds the JSON payload matching SAISA's CreateSalesInvoiceRequest.
class PosInvoiceDtoBuilder {
  /// Build payload for POST /api/v1/sales-invoices
  static Map<String, dynamic> build({
    required String invoiceNumber,
    required String invoiceDate, // "YYYY-MM-DD"
    required int customerId,
    required int warehouseId,
    required List<PosCartLine> lines,
    required String idempotencyKey,
    String? notes,
  }) {
    final items = lines.map((l) {
      return {
        'itemId': int.parse(l.itemId),
        'description': l.name,
        'quantity': l.quantity.toStringAsFixed(4),
        'unitPrice': l.unitPrice.toStringAsFixed(4),
        'taxRate': l.taxRate.toStringAsFixed(4),
      };
    }).toList();

    return {
      'invoiceNumber': invoiceNumber,
      'invoiceDate': invoiceDate,
      'customerId': customerId,
      'warehouseId': warehouseId,
      'notes': notes,
      'idempotencyKey': idempotencyKey,
      'lines': items,
    };
  }
}

