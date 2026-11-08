import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/core/database/app_database.dart';
import 'package:sajilo_billing/core/utils/nepali_unicode_helper.dart';
import 'package:sajilo_billing/features/billing/data/html_bill_generator.dart';
import 'package:sajilo_billing/features/billing/data/sales_repository.dart';
import 'package:sajilo_billing/features/billing/domain/bill_model.dart';
import 'package:sajilo_billing/features/inventory/data/inventory_repository.dart';

void main() {
  late AppDatabase db;
  late SalesRepository salesRepo;
  late InventoryRepository inventoryRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    salesRepo = SalesRepository(db);
    inventoryRepo = InventoryRepository(db);
    await inventoryRepo.seedDevData();
  });

  tearDown(() async {
    await db.close();
  });

  group('NepaliUnicodeHelper Tests', () {
    test('transliterate translates common Nepali words phonetically', () {
      expect(NepaliUnicodeHelper.transliterate('namaste'), equals('नमस्ते'));
      expect(NepaliUnicodeHelper.transliterate('pani'), equals('पानी'));
      expect(NepaliUnicodeHelper.transliterate('dudh'), equals('दूध'));
      expect(NepaliUnicodeHelper.transliterate('khata'), equals('खाता'));
    });

    test('transliterate preserves existing Devanagari text intact', () {
      expect(NepaliUnicodeHelper.transliterate('क्यासियो घडी'), equals('क्यासियो घडी'));
    });
  });

  group('HtmlBillGenerator Tests', () {
    test('toDevanagariNumerals converts numbers accurately', () {
      expect(HtmlBillGenerator.toDevanagariNumerals('12345'), equals('१२३४५'));
      expect(HtmlBillGenerator.toDevanagariNumerals('9805678456'), equals('९८०५६७८४५६'));
      expect(HtmlBillGenerator.toDevanagariNumerals(2500), equals('२५००'));
    });

    test('generateHtml creates valid single-page HTML bill pad with items and totals', () {
      final bill = BillData.dummy(
        businessName: 'Kathmandu Watch & Electronics',
        panVatNumber: '601234567',
        contactNumber: '9841234567',
        shopAddress: 'New Road, Kathmandu',
      );

      final html = HtmlBillGenerator.generateHtml(bill, style: BillTemplateStyle.nepaliPad);

      expect(html, contains('Kathmandu Watch & Electronics'));
      expect(html, contains('pan-box'));
      expect(html, contains(HtmlBillGenerator.toDevanagariNumerals('6')));
      expect(html, contains('bill-table'));
      expect(html, contains('@page { size: auto; margin: 4mm 5mm; }'));
    });

    test('generateHtml supports all 4 styles cleanly', () {
      final bill = BillData.dummy(
        businessName: 'Kathmandu Watch & Electronics',
        panVatNumber: '601234567',
        contactNumber: '9841234567',
      );

      for (final style in BillTemplateStyle.values) {
        final html = HtmlBillGenerator.generateHtml(bill, style: style);
        expect(html, contains('bill-wrapper'));
        expect(html, contains('pan-box'));
      }
    });
  });

  group('2-Step Verified Billing Workflow Tests', () {
    test('saveDraftSale saves sale in DRAFT state without deducting stock ledger', () async {
      final items = await db.select(db.items).get();
      final casio = items.firstWhere((i) => i.sku == 'SKU-0001');
      final initialStock = casio.stockQty;

      final draftSale = await salesRepo.saveDraftSale(
        customerName: 'Bikram Thapa',
        customerPhone: '9841000000',
        lines: [
          SaleLineInput(
            itemId: casio.id,
            itemName: casio.name,
            unit: casio.unit,
            quantity: 2.0,
            ratePaisa: casio.sellingPricePaisa,
          ),
        ],
      );

      expect(draftSale.status, equals('DRAFT'));
      expect(draftSale.invoiceNumber, startsWith('DFT-'));

      // Check stock was NOT deducted yet
      final updatedItem = await (db.select(db.items)..where((t) => t.id.equals(casio.id))).getSingle();
      expect(updatedItem.stockQty, equals(initialStock));

      // Check no sale ledger entry yet
      final ledgerEntries = await (db.select(db.stockLedger)..where((t) => t.refId.equals(draftSale.id))).get();
      expect(ledgerEntries, isEmpty);
    });

    test('verifyDraftSale finalizes draft sale, assigns official fiscal invoice #, and deducts stock', () async {
      final items = await db.select(db.items).get();
      final casio = items.firstWhere((i) => i.sku == 'SKU-0001');
      final initialStock = casio.stockQty;

      // 1. Save draft
      final draftSale = await salesRepo.saveDraftSale(
        customerName: 'Sunil Shrestha',
        customerPhone: '9841112233',
        lines: [
          SaleLineInput(
            itemId: casio.id,
            itemName: casio.name,
            unit: casio.unit,
            quantity: 3.0,
            ratePaisa: casio.sellingPricePaisa,
          ),
        ],
      );
      expect(draftSale.status, equals('DRAFT'));

      // 2. Validate & Verify
      final verifiedSale = await salesRepo.verifyDraftSale(draftSale.id);

      expect(verifiedSale.status, equals('VERIFIED'));
      expect(verifiedSale.invoiceNumber, isNot(startsWith('DFT-')));
      expect(verifiedSale.invoiceNumber, contains('-'));

      // Stock should now be deducted by 3.0
      final updatedItem = await (db.select(db.items)..where((t) => t.id.equals(casio.id))).getSingle();
      expect(updatedItem.stockQty, equals(initialStock - 3.0));

      // Stock ledger entry recorded
      final ledger = await (db.select(db.stockLedger)..where((t) => t.refId.equals(draftSale.id))).get();
      expect(ledger.length, equals(1));
      expect(ledger.first.qtyChange, equals(-3.0));
      expect(ledger.first.reason, equals('SALE'));
    });
  });
}
