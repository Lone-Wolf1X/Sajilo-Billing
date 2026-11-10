import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/localization/locale_provider.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/billing/presentation/pos_billing_screen.dart';
import '../../features/billing/presentation/sales_history_screen.dart';
import '../../features/purchase/presentation/purchase_screen.dart';
import '../../features/inventory/presentation/inventory_screen.dart';
import '../../features/khata/presentation/khata_screen.dart';
import '../../features/business/presentation/edit_business_screen.dart';
import '../../features/backup/presentation/backup_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/sync/presentation/sync_paused_banner.dart';

class DesktopAppShell extends ConsumerStatefulWidget {
  const DesktopAppShell({super.key});

  @override
  ConsumerState<DesktopAppShell> createState() => _DesktopAppShellState();
}

class _DesktopAppShellState extends ConsumerState<DesktopAppShell> {
  int _selectedIndex = 0;

  void _navigateToIndex(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final authUser = ref.watch(authStateProvider).value;

    final pages = [
      DashboardScreen(
        onNavigateToSale: () => _navigateToIndex(1),
        onNavigateToPurchase: () => _navigateToIndex(3),
        onNavigateToInventory: () => _navigateToIndex(4),
      ),
      const PosBillingScreen(),
      const SalesHistoryScreen(),
      const PurchaseScreen(),
      const InventoryScreen(),
      const KhataScreen(),
      const EditBusinessScreen(),
      const BackupScreen(),
      const SettingsScreen(),
    ];

    const destinations = [
      NavigationRailDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: Text('Dashboard / मुख्य पृष्ठ'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.point_of_sale_outlined),
        selectedIcon: Icon(Icons.point_of_sale),
        label: Text('POS Billing (बिक्री)'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.receipt_long_outlined),
        selectedIcon: Icon(Icons.receipt_long),
        label: Text('Sales Register (बिजक)'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.local_shipping_outlined),
        selectedIcon: Icon(Icons.local_shipping),
        label: Text('Purchases (खरिद)'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.inventory_2_outlined),
        selectedIcon: Icon(Icons.inventory_2),
        label: Text('Inventory (सामान)'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.menu_book_outlined),
        selectedIcon: Icon(Icons.menu_book),
        label: Text('Khata (उधारो खाता)'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.business_outlined),
        selectedIcon: Icon(Icons.business),
        label: Text('Business Info (व्यापार)'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.backup_table_outlined),
        selectedIcon: Icon(Icons.backup_table),
        label: Text('Backup / Restore'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: Text('Settings (सेटिङ)'),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isCompact = width < 600;
        final isExtended = width >= 900;

        final contentArea = Column(
          children: [
            const SyncPausedBanner(),
            Expanded(child: pages[_selectedIndex]),
          ],
        );

        if (isCompact) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.appTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.language),
                  onPressed: () => ref.read(localeProvider.notifier).toggleLocale(),
                  tooltip: locale.languageCode == 'en' ? 'नेपाली' : 'English',
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(color: AppTheme.primaryBlue),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.receipt_long, color: Colors.white, size: 36),
                        const SizedBox(height: 8),
                        Text(
                          l10n.appTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...List.generate(destinations.length, (idx) {
                    return ListTile(
                      leading: destinations[idx].icon,
                      title: destinations[idx].label,
                      selected: _selectedIndex == idx,
                      onTap: () {
                        Navigator.pop(context);
                        _navigateToIndex(idx);
                      },
                    );
                  }),
                ],
              ),
            ),
            body: contentArea,
          );
        }

        return Scaffold(
          body: Row(
            children: [
              // Navigation Rail (Extended on desktop >= 900, compact icons on tablet < 900)
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _navigateToIndex,
                extended: isExtended,
                minExtendedWidth: 220,
                backgroundColor: Colors.white,
                leading: SizedBox(
                  width: isExtended ? 190 : 48,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: isExtended ? 8 : 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.receipt_long, color: Colors.white, size: 24),
                        ),
                        if (isExtended) ...[
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
                      ],
                    ),
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isExtended && authUser != null) ...[
                        Container(
                          width: 190,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.borderSubtle),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.account_circle, size: 18, color: AppTheme.primaryBlue),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      authUser.displayName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    authUser.tenantCode.toUpperCase(),
                                    style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryBlue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      authUser.roles.isNotEmpty ? authUser.roles.first : 'USER',
                                      style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (isExtended)
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: const Size(190, 32),
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
                      const SizedBox(height: 6),
                      if (isExtended)
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.dangerRed,
                            minimumSize: const Size(190, 32),
                          ),
                          onPressed: () {
                            ref.read(authStateProvider.notifier).logout();
                          },
                          icon: const Icon(Icons.logout, size: 16),
                          label: const Text('Sign Out / लगआउट', style: TextStyle(fontSize: 12)),
                        )
                      else
                        IconButton(
                          tooltip: 'Sign Out / लगआउट',
                          icon: const Icon(Icons.logout, size: 20, color: AppTheme.dangerRed),
                          onPressed: () {
                            ref.read(authStateProvider.notifier).logout();
                          },
                        ),
                    ],
                  ),
                ),
                destinations: destinations,
              ),
              const VerticalDivider(thickness: 1, width: 1, color: AppTheme.borderSubtle),
              // Active Page View
              Expanded(
                child: contentArea,
              ),
            ],
          ),
        );
      },
    );
  }
}
