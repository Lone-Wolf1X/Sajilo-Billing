import 'dart:typed_data';

import '../../../core/database/app_database.dart';
import '../../../core/utils/paisa_helper.dart';

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
  final String? businessNameNepali;
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
    this.businessNameNepali,
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

  /// Factory creating [BillData] from real Drift SQLite database records.
  factory BillData.fromSaleRecord({
    required BusinessProfile profile,
    required Sale sale,
    required List<SaleItem> saleItems,
    Uint8List? logoBytes,
  }) {
    final billItems = List.generate(saleItems.length, (index) {
      final item = saleItems[index];
      return BillItem(
        sn: index + 1,
        description: item.itemName,
        quantity: item.quantity,
        unit: item.unit,
        rate: PaisaHelper.toRupees(item.ratePaisa),
        amount: PaisaHelper.toRupees(item.lineTotalPaisa),
      );
    });

    final subtotal = PaisaHelper.toRupees(sale.subtotalPaisa);
    final discount = PaisaHelper.toRupees(sale.discountPaisa);
    final taxable = PaisaHelper.toRupees(sale.taxablePaisa);
    final vat = PaisaHelper.toRupees(sale.vatPaisa);
    final grandTotal = PaisaHelper.toRupees(sale.totalPaisa);

    final verificationQr =
        'SAJILO|INV:${sale.invoiceNumber}|TOT:${grandTotal.toStringAsFixed(2)}|PAN:${profile.panVatNumber}|D:${sale.invoiceDate.toIso8601String().substring(0, 10)}';

    return BillData(
      businessName: profile.businessName,
      businessNameNepali: profile.businessNameNepali,
      panVatNumber: profile.panVatNumber,
      contactNumber: profile.contactNumber,
      shopAddress: profile.shopAddress,
      logoBytes: logoBytes,
      invoiceNumber: sale.invoiceNumber,
      invoiceDate: sale.invoiceDate.toLocal(),
      customerName: sale.customerName,
      customerPan: sale.customerPan,
      paymentMode: sale.paymentMode,
      items: billItems,
      subtotal: subtotal,
      discountAmount: discount,
      taxableAmount: taxable,
      vatAmount: vat,
      grandTotal: grandTotal,
      inWords: PaisaHelper.paisaToWords(sale.totalPaisa),
      qrData: verificationQr,
    );
  }

  /// Factory to generate dummy bill for testing Phase 1
  factory BillData.dummy({
    required String businessName,
    String? businessNameNepali,
    required String panVatNumber,
    required String contactNumber,
    String? shopAddress,
    Uint8List? logoBytes,
  }) {
    final now = DateTime.now();
    const invoiceNumber = 'SB-2082-0042';

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
