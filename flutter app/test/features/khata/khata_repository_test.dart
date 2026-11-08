import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/core/database/app_database.dart';
import 'package:sajilo_billing/features/khata/data/khata_repository.dart';

void main() {
  late AppDatabase db;
  late KhataRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = KhataRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('KhataRepository & Party Ledger Tests', () {
    test('Customer credit sales and payments accurately update running balance', () async {
      // 1. Create a customer
      final customer = await repo.getOrCreateCustomer(
        name: 'Ram Bahadur',
        phone: '9841234567',
      );
      expect(customer.id, isNotEmpty);

      // Initial balance should be 0
      expect(await repo.getCurrentBalance(customer.id), equals(0));

      // 2. Record first credit sale: Rs. 1,500.00 (150,000 paisa)
      await repo.recordCustomerCreditSale(
        customerId: customer.id,
        amountPaisa: 150000,
        saleId: 'sale-1',
        billNumber: 'SB-2082-0001',
      );

      expect(await repo.getCurrentBalance(customer.id), equals(150000));

      // 3. Record second credit sale: Rs. 500.00 (50,000 paisa)
      await repo.recordCustomerCreditSale(
        customerId: customer.id,
        amountPaisa: 50000,
        saleId: 'sale-2',
        billNumber: 'SB-2082-0002',
      );

      expect(await repo.getCurrentBalance(customer.id), equals(200000));

      // 4. Record partial payment received: Rs. 1,200.00 (120,000 paisa)
      final receiptNumber = await repo.recordCustomerPayment(
        customerId: customer.id,
        amountPaisa: 120000,
        paymentMode: 'CASH',
        notes: 'Partial settlement',
      );

      expect(receiptNumber, startsWith('REC-'));
      // Remaining balance: 200,000 - 120,000 = 80,000 paisa (Rs. 800.00)
      expect(await repo.getCurrentBalance(customer.id), equals(80000));

      // 5. Verify customer summary
      final summaries = await repo.watchCustomerSummaries().first;
      expect(summaries.length, equals(1));
      final ramSummary = summaries.first;

      expect(ramSummary.name, equals('Ram Bahadur'));
      expect(ramSummary.totalCreditPaisa, equals(200000));
      expect(ramSummary.totalSettledPaisa, equals(120000));
      expect(ramSummary.currentBalancePaisa, equals(80000));
      expect(ramSummary.hasPendingDues, isTrue);
    });

    test('Supplier credit purchases and payments track payables accurately', () async {
      // 1. Create supplier
      const supplierId = 'supp-101';
      await db.into(db.suppliers).insert(
            SuppliersCompanion.insert(
              id: supplierId,
              name: 'Himalayan Wholesale Distributors',
              phone: const Value('9851000000'),
            ),
          );

      // 2. Record credit purchase: Rs. 10,000.00 (1,000,000 paisa)
      await repo.recordSupplierCreditPurchase(
        supplierId: supplierId,
        amountPaisa: 1000000,
        purchaseId: 'purch-1',
        billNumber: 'BILL-9901',
      );

      expect(await repo.getCurrentBalance(supplierId), equals(1000000));

      // 3. Record payout to supplier: Rs. 4,000.00 (400,000 paisa)
      final payNumber = await repo.recordSupplierPayment(
        supplierId: supplierId,
        amountPaisa: 400000,
        paymentMode: 'BANK_TRANSFER',
      );

      expect(payNumber, startsWith('PAY-'));
      // Remaining payable: 1,000,000 - 400,000 = 600,000 paisa (Rs. 6,000.00)
      expect(await repo.getCurrentBalance(supplierId), equals(600000));

      // 4. Verify supplier summary
      final suppliers = await repo.watchSupplierSummaries().first;
      expect(suppliers.length, equals(1));
      expect(suppliers.first.currentBalancePaisa, equals(600000));
      expect(suppliers.first.totalCreditPaisa, equals(1000000));
      expect(suppliers.first.totalSettledPaisa, equals(400000));
    });

    test('OverallKhataMetrics aggregates customer receivables and supplier payables', () async {
      final cust = await repo.getOrCreateCustomer(name: 'Shyam Shrestha');
      await repo.recordCustomerCreditSale(
        customerId: cust.id,
        amountPaisa: 250000, // Rs. 2,500 due
        saleId: 's1',
        billNumber: 'B1',
      );

      const suppId = 'supp-abc';
      await db.into(db.suppliers).insert(
            SuppliersCompanion.insert(
              id: suppId,
              name: 'Kathmandu Supplier',
            ),
          );
      await repo.recordSupplierCreditPurchase(
        supplierId: suppId,
        amountPaisa: 500000, // Rs. 5,000 payable
        purchaseId: 'p1',
        billNumber: 'B2',
      );

      final metrics = await repo.watchOverallMetrics().first;
      expect(metrics.totalCustomerReceivablePaisa, equals(250000));
      expect(metrics.totalSupplierPayablePaisa, equals(500000));
      expect(metrics.customersWithDuesCount, equals(1));
      expect(metrics.suppliersWithDuesCount, equals(1));
    });
  });
}
