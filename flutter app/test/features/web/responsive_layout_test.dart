import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:sajilo_billing/core/database/app_database.dart';
import 'package:sajilo_billing/core/database/database_provider.dart';
import 'package:sajilo_billing/shared/widgets/desktop_app_shell.dart';
import 'package:drift/native.dart';

Widget createTestApp({required Widget child, required double width, double height = 800}) {
  return ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(AppDatabase(NativeDatabase.memory())),
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
  testWidgets('At width 1200 the extended sidebar NavigationRail shows', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestApp(
      child: const DesktopAppShell(),
      width: 1200,
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    final railFinder = find.byType(NavigationRail);
    expect(railFinder, findsOneWidget);

    final rail = tester.widget<NavigationRail>(railFinder);
    expect(rail.extended, isTrue);
  });

  testWidgets('At width 550 the compact drawer navigation shows', (tester) async {
    tester.view.physicalSize = const Size(550, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestApp(
      child: const DesktopAppShell(),
      width: 550,
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // At compact width, NavigationRail is omitted in favor of AppBar and Drawer
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(AppBar), findsOneWidget);

    // Open the drawer
    final ScaffoldState scaffoldState = tester.firstState(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(Drawer), findsOneWidget);
  });
}
