import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sajilo_billing/core/database/app_database.dart';
import 'package:sajilo_billing/core/database/database_provider.dart';
import 'package:sajilo_billing/features/inventory/data/inventory_repository.dart';
import 'package:sajilo_billing/features/inventory/presentation/inventory_provider.dart';
import 'package:sajilo_billing/features/inventory/presentation/inventory_screen.dart';

void main() {
  testWidgets('InventoryScreen builds and renders without errors', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    final repo = InventoryRepository(db);
    await repo.seedDevData();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          inventoryRepositoryProvider.overrideWithValue(repo),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: Scaffold(body: InventoryScreen()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(InventoryScreen), findsOneWidget);
    await db.close();
  });
}
