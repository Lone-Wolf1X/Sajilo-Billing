import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/core/database/app_database.dart';
import 'package:sajilo_billing/core/database/database_provider.dart';
import 'package:sajilo_billing/features/billing/presentation/pos_billing_screen.dart';
import 'package:sajilo_billing/features/billing/presentation/sales_provider.dart';
import 'package:sajilo_billing/features/business/presentation/business_provider.dart';
import 'package:sajilo_billing/features/dashboard/data/dashboard_repository.dart';
import 'package:sajilo_billing/features/dashboard/presentation/dashboard_provider.dart';
import 'package:sajilo_billing/features/dashboard/presentation/dashboard_screen.dart';
import 'package:sajilo_billing/features/inventory/presentation/inventory_provider.dart';

const mockMetrics = DashboardMetrics(
  todaySalesCount: 12,
  todaySalesRevenuePaisa: 4500000,
  todayPurchaseCount: 3,
  todayPurchaseAmountPaisa: 2800000,
  lowStockCount: 2,
  totalItemsCount: 45,
);

Widget createViewportTestApp({
  required Widget child,
  required double width,
  required double height,
  required AppDatabase testDb,
}) {
  return ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(testDb),
      dashboardMetricsProvider.overrideWith((ref) => Future.value(mockMetrics)),
      itemsStreamProvider.overrideWith((ref) => Stream.value([])),
      customersStreamProvider.overrideWith((ref) => Stream.value([])),
      businessProfileStreamProvider.overrideWith((ref) => Stream.value(null)),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, height)),
        child: SizedBox(
          width: width,
          height: height,
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  final viewports = [
    const Size(1280, 720), // Desktop standard
    const Size(900, 600),  // Laptop compact
    const Size(600, 800),  // Tablet portrait
    const Size(400, 800),  // Mobile / split view
  ];

  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Viewport Layout & No RenderFlex Overflow Tests', () {
    for (final size in viewports) {
      testWidgets('Dashboard renders with 0 overflow errors at ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createViewportTestApp(
          child: DashboardScreen(
            onNavigateToSale: () {},
            onNavigateToPurchase: () {},
            onNavigateToInventory: () {},
          ),
          width: size.width,
          height: size.height,
          testDb: db,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Assert no exception was thrown during layout
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        await tester.pump();
      });

      testWidgets('POS Billing Screen renders with 0 overflow errors at ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createViewportTestApp(
          child: const PosBillingScreen(),
          width: size.width,
          height: size.height,
          testDb: db,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Assert no exception was thrown during layout
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        await tester.pump();
      });
    }
  });
}
