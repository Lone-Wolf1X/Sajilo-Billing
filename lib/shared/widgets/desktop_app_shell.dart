import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/localization/locale_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../features/billing/presentation/sample_bill_screen.dart';
import '../../features/business/presentation/edit_business_screen.dart';
import '../../features/backup/presentation/backup_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

class DesktopAppShell extends ConsumerStatefulWidget {
  const DesktopAppShell({super.key});

  @override
  ConsumerState<DesktopAppShell> createState() => _DesktopAppShellState();
}

class _DesktopAppShellState extends ConsumerState<DesktopAppShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    SampleBillScreen(),
    EditBusinessScreen(),
    BackupScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      body: Row(
        children: [
          // Desktop Navigation Rail
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() => _selectedIndex = index);
            },
            extended: true,
            minExtendedWidth: 220,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.receipt_long, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accentTeal.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            l10n.offlineReady,
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accentTeal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size.fromHeight(36),
                    ),
                    onPressed: () {
                      ref.read(localeProvider.notifier).toggleLocale();
                    },
                    icon: const Icon(Icons.language, size: 16),
                    label: Text(
                      locale.languageCode == 'en' ? 'नेपाली' : 'English',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.receipt_outlined),
                selectedIcon: const Icon(Icons.receipt),
                label: Text(l10n.sampleBilling),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.business_outlined),
                selectedIcon: const Icon(Icons.business),
                label: Text(l10n.businessInfo),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.backup_table_outlined),
                selectedIcon: const Icon(Icons.backup_table),
                label: Text(l10n.backupAndRestore),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: Text(l10n.settings),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: AppTheme.borderSubtle),
          // Main Content View
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
