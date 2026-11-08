import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/core/database/app_database.dart';
import 'package:sajilo_billing/core/platform/secure_token_store_web.dart';
import 'package:sajilo_billing/features/auth/data/local_auth_repository.dart';
import 'package:sajilo_billing/features/inventory/data/inventory_repository.dart';

void main() {
  group('Test Credentials & Products Catalog Seeding Tests', () {
    late AppDatabase db;
    late SecureTokenStoreWeb tokenStore;
    late LocalAuthRepository authRepo;
    late InventoryRepository inventoryRepo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      tokenStore = SecureTokenStoreWeb();
      authRepo = LocalAuthRepository(db, tokenStore);
      inventoryRepo = InventoryRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('Seeds default admin credentials (admin / admin123) successfully', () async {
      expect(await authRepo.hasLocalAccount(), isFalse);

      final seeded = await authRepo.seedDefaultTestAccount();
      expect(seeded, isNotNull);
      expect(seeded!.username, equals('admin'));
      expect(seeded.displayName, contains('Admin'));

      expect(await authRepo.hasLocalAccount(), isTrue);

      // Verify authenticating with seeded credentials
      final loggedIn = await authRepo.login(username: 'admin', password: 'admin123');
      expect(loggedIn.username, equals('admin'));

      // Re-seeding when account exists returns null (idempotent)
      final secondRun = await authRepo.seedDefaultTestAccount();
      expect(secondRun, isNull);
    });

    test('Rejects invalid password for seeded admin account', () async {
      await authRepo.seedDefaultTestAccount();

      expect(
        () => authRepo.login(username: 'admin', password: 'wrongpassword'),
        throwsA(isA<LocalAuthException>()),
      );
    });

    test('Seeds 80 products from products.json catalog with opening stock & categories', () async {
      // Initially no items
      final initialItems = await db.select(db.items).get();
      expect(initialItems, isEmpty);

      // Seed catalog
      await inventoryRepo.seedDevData();

      // Verify all 80 products imported
      final items = await db.select(db.items).get();
      expect(items.length, equals(80));

      // Verify business profile was created
      final profile = await (db.select(db.businessProfiles)..limit(1)).getSingleOrNull();
      expect(profile, isNotNull);
      expect(profile!.businessName, equals('Electronics & Watch Center'));

      // Check first product: Casio Digital Watch
      final casio = items.firstWhere((i) => i.sku == 'SKU-0001');
      expect(casio.name, equals('Casio Digital Watch'));
      expect(casio.stockQty, equals(10.0));
      expect(casio.sellingPricePaisa, equals(250000)); // Rs. 2500
      expect(casio.purchasePricePaisa, equals(187500)); // Rs. 1875 (75%)
      expect(casio.unit, equals('pcs'));

      // Verify Categories were created
      final categories = await db.select(db.categories).get();
      expect(categories.length, greaterThanOrEqualTo(10));
      final catNames = categories.map((c) => c.name).toSet();
      expect(catNames, contains('Watches'));
      expect(catNames, contains('Electronics'));
      expect(catNames, contains('Mobile Accessories'));

      // Verify Stock Ledger opening entries
      final ledgerEntries = await db.select(db.stockLedger).get();
      expect(ledgerEntries.length, equals(80));
      final casioLedger = ledgerEntries.firstWhere((l) => l.itemId == casio.id);
      expect(casioLedger.qtyChange, equals(10.0));
      expect(casioLedger.reason, equals('INITIAL_STOCK'));
    });
  });
}
