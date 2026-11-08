import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_billing/features/dashboard/presentation/dashboard_screen.dart';
import 'package:sajilo_billing/features/dashboard/presentation/dashboard_provider.dart';
import 'package:sajilo_billing/features/dashboard/data/dashboard_repository.dart';
import 'package:sajilo_billing/shared/widgets/desktop_app_shell.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  const mockMetrics = DashboardMetrics(
    todaySalesRevenuePaisa: 0,
    todaySalesCount: 0,
    todayPurchaseAmountPaisa: 0,
    todayPurchaseCount: 0,
    lowStockCount: 0,
    totalItemsCount: 80,
    lastBackupTime: null,
  );

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        dashboardMetricsProvider.overrideWith((ref) => mockMetrics),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: DesktopAppShell(),
      ),
    );
  }

  for (final size in [
    const Size(1440, 900),
    const Size(1200, 800),
    const Size(1024, 576),
    const Size(800, 600),
  ]) {
    testWidgets('Header and metric cards never overlap at ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final dashboardTitleFinder = find.descendant(
        of: find.byType(DashboardScreen),
        matching: find.text('Dashboard / मुख्य पृष्ठ'),
      );
      final newSaleFinder = find.text('New Sale / नयाँ बिल');
      final metricCardFinder = find.text("Today's Sales / आजको बिक्री");

      expect(dashboardTitleFinder, findsOneWidget);
      expect(newSaleFinder, findsOneWidget);
      expect(metricCardFinder, findsOneWidget);

      final titleRect = tester.getRect(dashboardTitleFinder);
      final buttonRect = tester.getRect(newSaleFinder);
      final metricRect = tester.getRect(metricCardFinder);


      expect(metricRect.top, greaterThanOrEqualTo(titleRect.bottom),
          reason: 'Metric cards must be below the title');
      expect(metricRect.top, greaterThanOrEqualTo(buttonRect.bottom),
          reason: 'Metric cards must be below quick action buttons');
    });
  }
}
