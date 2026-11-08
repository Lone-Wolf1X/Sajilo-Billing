import '../../../core/utils/paisa_helper.dart';

/// Type of party in Khata (Customer or Supplier).
enum PartyType {
  customer,
  supplier,
}

/// Type of financial ledger entry.
enum KhataEntryType {
  saleCredit, // Goods sold on credit (Receivable +)
  purchaseCredit, // Goods purchased on credit (Payable +)
  paymentReceived, // Cash/Fonepay collected from customer (Receivable -)
  paymentMade, // Cash/Bank paid to supplier (Payable -)
  openingBalance, // Initial balance carried forward
  adjustment, // Manual reconciled adjustment
}

/// Summary card representation of a customer or supplier in Khata.
class PartySummary {
  final String id;
  final PartyType partyType;
  final String name;
  final String? phone;
  final String? panVat;
  final String? address;
  final int currentBalancePaisa; // For customer: >0 means owes shop. For supplier: >0 means shop owes supplier.
  final int totalCreditPaisa;
  final int totalSettledPaisa;
  final DateTime? lastTransactionDate;

  const PartySummary({
    required this.id,
    required this.partyType,
    required this.name,
    this.phone,
    this.panVat,
    this.address,
    required this.currentBalancePaisa,
    required this.totalCreditPaisa,
    required this.totalSettledPaisa,
    this.lastTransactionDate,
  });

  /// True if party has outstanding pending dues.
  bool get hasPendingDues => currentBalancePaisa > 0;

  /// Formatted balance in Rupees.
  String get formattedBalance => PaisaHelper.formatPaisa(currentBalancePaisa);

  /// Pre-built WhatsApp reminder message.
  String generateWhatsAppReminderMessage({required String shopName}) {
    final balanceRupees = (currentBalancePaisa / 100.0).toStringAsFixed(2);
    return 'नमस्ते $name ज्यू, $shopName मा तपाईंको उधारो बाँकी रु. $balanceRupees रहेको छ। कृपया समयमै भुक्तानी गरिदिनुहुन अनुरोध गर्दछौं। धन्यवाद!';
  }
}

/// Aggregate metrics for Khata dashboard.
class OverallKhataMetrics {
  final int totalCustomerReceivablePaisa; // कुल लिन बाँकी (उठाउनुपर्ने)
  final int totalSupplierPayablePaisa; // कुल तिर्न बाँकी
  final int customersWithDuesCount;
  final int suppliersWithDuesCount;

  const OverallKhataMetrics({
    required this.totalCustomerReceivablePaisa,
    required this.totalSupplierPayablePaisa,
    required this.customersWithDuesCount,
    required this.suppliersWithDuesCount,
  });

  String get formattedCustomerReceivable => PaisaHelper.formatPaisa(totalCustomerReceivablePaisa);
  String get formattedSupplierPayable => PaisaHelper.formatPaisa(totalSupplierPayablePaisa);
}

