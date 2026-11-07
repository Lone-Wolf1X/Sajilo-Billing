import 'dart:typed_data';

class BillItem {
  final int sn;
  final String description;
  final double quantity;
  final String unit;
  final double rate;
  final double amount;

  const BillItem({
    required this.sn,
    required this.description,
    required this.quantity,
    this.unit = 'pcs',
    required this.rate,
    required this.amount,
  });
}

class BillData {
  // Business identity
  final String businessName;
  final String panVatNumber;
  final String contactNumber;
  final String? shopAddress;
  final Uint8List? logoBytes;

  // Invoice identifiers
  final String invoiceNumber;
  final DateTime invoiceDate;
  final String customerName;
  final String? customerPan;
  final String paymentMode;

  // Items
  final List<BillItem> items;

  // Financial summary
  final double subtotal;
  final double discountAmount;
  final double taxableAmount;
  final double vatAmount;
  final double grandTotal;
  final String inWords;

  // QR string
  final String qrData;

  const BillData({
    required this.businessName,
    required this.panVatNumber,
    required this.contactNumber,
    this.shopAddress,
    this.logoBytes,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.customerName,
    this.customerPan,
    this.paymentMode = 'CASH',
    required this.items,
    required this.subtotal,
    required this.discountAmount,
    required this.taxableAmount,
    required this.vatAmount,
    required this.grandTotal,
    required this.inWords,
    required this.qrData,
  });

  /// Factory to generate dummy bill for testing Phase 1
  factory BillData.dummy({
    required String businessName,
    required String panVatNumber,
    required String contactNumber,
    String? shopAddress,
    Uint8List? logoBytes,
  }) {
    final now = DateTime.now();
    const invoiceNumber = 'SB-2081-0042';

    final items = [
      const BillItem(
        sn: 1,
        description: 'Basmati Rice 25kg (बासमती चामल)',
        quantity: 1,
        unit: 'bag',
        rate: 2450.0,
        amount: 2450.0,
      ),
      const BillItem(
        sn: 2,
        description: 'Sunflower Cooking Oil (सूर्यमुखी तेल १ लि.)',
        quantity: 2,
        unit: 'ltr',
        rate: 220.0,
        amount: 440.0,
      ),
      const BillItem(
        sn: 3,
        description: 'Tata Salt 1kg (नुन)',
        quantity: 3,
        unit: 'pkt',
        rate: 28.0,
        amount: 84.0,
      ),
      const BillItem(
        sn: 4,
        description: 'Wai Wai Noodles (चाउचाउ कार्टुन)',
        quantity: 1,
        unit: 'box',
        rate: 600.0,
        amount: 600.0,
      ),
    ];

    final subtotal = items.fold<double>(0.0, (acc, item) => acc + item.amount);
    const discount = 150.0;
    final taxable = subtotal - discount;
    final vat = taxable * 0.13;
    final grandTotal = taxable + vat;

    final verificationString = 'SAJILO|INV:$invoiceNumber|TOT:${grandTotal.toStringAsFixed(2)}|PAN:$panVatNumber|V:OK98';

    return BillData(
      businessName: businessName,
      panVatNumber: panVatNumber,
      contactNumber: contactNumber,
      shopAddress: shopAddress ?? 'Kathmandu, Nepal',
      logoBytes: logoBytes,
      invoiceNumber: invoiceNumber,
      invoiceDate: now,
      customerName: 'Ram Bahadur Shrestha',
      customerPan: '300124567',
      paymentMode: 'Cash / नगद',
      items: items,
      subtotal: subtotal,
      discountAmount: discount,
      taxableAmount: taxable,
      vatAmount: vat,
      grandTotal: grandTotal,
      inWords: 'Three Thousand Eight Hundred Sixty Seven Rupees & Ninety Two Paisa Only',
      qrData: verificationString,
    );
  }
}

