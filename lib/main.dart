import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'core/localization/locale_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/auth_state_notifier.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/business/presentation/business_provider.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'shared/widgets/desktop_app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SajiloBillingApp(),
    ),
  );
}

class SajiloBillingApp extends ConsumerWidget {
  const SajiloBillingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final authState = ref.watch(authStateProvider);
    final businessProfileAsync = ref.watch(businessProfileStreamProvider);

    return MaterialApp(
      title: 'Sajilo Billing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: _buildHome(authState, businessProfileAsync),
    );
  }

  Widget _buildHome(AuthState authState, AsyncValue<dynamic> businessProfileAsync) {
    switch (authState.status) {
      case AuthStatus.splash:
        return SplashScreen(
          onFinish: () {
            // authStateNotifier advances state automatically after checkInitialSession()
          },
        );
      case AuthStatus.unauthenticated:
        return const LoginScreen();
      case AuthStatus.authenticated:
        return businessProfileAsync.when(
          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Scaffold(
            body: Center(
              child: SelectableText('Error initializing local database: $error'),
            ),
          ),
          data: (profile) {
            // If no business profile has been configured, show the first-run onboarding wizard
            if (profile == null) {
              return const OnboardingScreen();
            }
            // Otherwise navigate to the desktop app shell
            return const DesktopAppShell();
          },
        );
    }
  }
}
