import 'dart:async';
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
import '../../features/sync/presentation/sync_queue_viewer_dialog.dart';
import '../../features/admin/presentation/users_management_screen.dart';

class DesktopAppShell extends ConsumerStatefulWidget {
  const DesktopAppShell({super.key});

  @override
  ConsumerState<DesktopAppShell> createState() => _DesktopAppShellState();
}

class _DesktopAppShellState extends ConsumerState<DesktopAppShell> {
  int _selectedIndex = 0;
  Timer? _autoSyncTimer;

  @override
  void initState() {
    super.initState();
    // Run background sync every 30 seconds
    _autoSyncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      final auth = ref.read(authStateProvider).valueOrNull;
      if (auth != null) {
        ref.read(syncQueueServiceProvider).processPending().then((_) {
          ref.invalidate(pendingSyncCountProvider);
        });
      }
    });
  }

  @override
  void dispose() {
    _autoSyncTimer?.cancel();
    super.dispose();
  }

  void _navigateToIndex(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final authUser = ref.watch(authStateProvider).value;
    final isCashier = authUser != null && authUser.hasRole('CASHIER') && !authUser.isAdmin;
    final isAdmin = authUser?.isAdmin ?? false;

    final List<Widget> pages;
    final List<NavigationRailDestination> destinations;

    if (isCashier) {
      pages = const [
        PosBillingScreen(),
        SalesHistoryScreen(),
        SettingsScreen(),
      ];
      destinations = const [
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
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings (सेटिङ)'),
        ),
      ];
    } else {
      pages = [
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
        if (isAdmin) const UsersManagementScreen(),
      ];

      destinations = [
        const NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard / मुख्य पृष्ठ'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.point_of_sale_outlined),
          selectedIcon: Icon(Icons.point_of_sale),
          label: Text('POS Billing (बिक्री)'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: Text('Sales Register (बिजक)'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.local_shipping_outlined),
          selectedIcon: Icon(Icons.local_shipping),
          label: Text('Purchases (खरिद)'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2),
          label: Text('Inventory (सामान)'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book),
          label: Text('Khata (उधारो खाता)'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.business_outlined),
          selectedIcon: Icon(Icons.business),
          label: Text('Business Info (व्यापार)'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.backup_table_outlined),
          selectedIcon: Icon(Icons.backup_table),
          label: Text('Backup / Restore'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings (सेटिङ)'),
        ),
        if (isAdmin)
          const NavigationRailDestination(
            icon: Icon(Icons.manage_accounts_outlined),
            selectedIcon: Icon(Icons.manage_accounts),
            label: Text('Users (प्रयोगकर्ताहरू)'),
          ),
      ];
    }

    final safeIndex = _selectedIndex.clamp(0, pages.length - 1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isCompact = width < 600;
        final isExtended = width >= 900;

        final contentArea = Column(
          children: [
            const SyncPausedBanner(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  const Icon(Icons.desktop_windows, size: 16, color: AppTheme.textMuted),
                  const SizedBox(width: 8),
                  Text(
                    destinations[safeIndex].label is Text
                        ? (destinations[safeIndex].label as Text).data ?? ''
                        : '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const Spacer(),
                  const SyncStatusBadge(),
                ],
              ),
            ),
            Expanded(child: pages[safeIndex]),
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
                      selected: safeIndex == idx,
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
                selectedIndex: safeIndex,
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

class SyncStatusBadge extends ConsumerWidget {
  const SyncStatusBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingSyncCountProvider);
    return pendingAsync.maybeWhen(
      data: (count) => InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showDialog(
          context: context,
          builder: (_) => const SyncQueueViewerDialog(),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: count == 0 ? const Color(0xFFE6F4EA) : const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: count == 0
                  ? const Color(0xFF34A853).withOpacity(0.3)
                  : const Color(0xFFF59E0B).withOpacity(0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                count == 0 ? Icons.cloud_done : Icons.cloud_upload,
                size: 14,
                color: count == 0 ? const Color(0xFF137333) : const Color(0xFFB45309),
              ),
              const SizedBox(width: 5),
              Text(
                count == 0 ? 'All Synced' : '$count Pending',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: count == 0 ? const Color(0xFF137333) : const Color(0xFFB45309),
                ),
              ),
            ],
          ),
        ),
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

