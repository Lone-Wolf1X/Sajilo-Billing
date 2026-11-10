import '../../../core/api/saisa_api_client.dart';
import '../application/pos_cart_calculator.dart';
import 'pos_invoice_dto.dart';

class PosInvoiceRepository {
  final SaisaApiClient _api;
  PosInvoiceRepository(this._api);

  /// Create a sales invoice on SAISA backend.
  /// Returns the server response including `invoiceNumber` and `id`.
  Future<Map<String, dynamic>> createInvoice({
    required String invoiceNumber,
    required String invoiceDate,
    required int customerId,
    required int warehouseId,
    required List<PosCartLine> lines,
    required String idempotencyKey,
    String? notes,
  }) async {
    final payload = PosInvoiceDtoBuilder.build(
      invoiceNumber: invoiceNumber,
      invoiceDate: invoiceDate,
      customerId: customerId,
      warehouseId: warehouseId,
      lines: lines,
      idempotencyKey: idempotencyKey,
      notes: notes,
    );
    return await _api.post<Map<String, dynamic>>('/sales-invoices', data: payload);
  }
}
