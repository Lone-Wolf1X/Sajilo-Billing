import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/paisa_helper.dart';
import '../../../shared/widgets/responsive_card.dart';
import '../../backup/presentation/backup_provider.dart';
import '../../inventory/presentation/widgets/item_form_dialog.dart';
import '../../purchase/presentation/purchase_entry_screen.dart';
import '../../printing/presentation/printer_settings_screen.dart';
import 'dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  final VoidCallback onNavigateToSale;
  final VoidCallback onNavigateToPurchase;
  final VoidCallback onNavigateToInventory;

  const DashboardScreen({
    super.key,
    required this.onNavigateToSale,
    required this.onNavigateToPurchase,
    required this.onNavigateToInventory,
  });

  Future<void> _backupNow(BuildContext context, WidgetRef ref) async {
    try {
      final service = ref.read(backupServiceProvider);
      final path = await service.backupNow();
      ref.invalidate(dashboardMetricsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup successful: $path'), backgroundColor: AppTheme.accentTeal),
        );
      }
    } catch (e) {
      if (context.mounted && !e.toString().contains('cancelled')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup failed: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  void _openAddItemDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const ItemFormDialog(),
    ).then((_) {
      ref.invalidate(dashboardMetricsProvider);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(dashboardMetricsProvider);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Material(
      color: AppTheme.backgroundLight,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Responsive Welcome Title and Quick Actions Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Dashboard / मुख्य पृष्ठ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Real-time retail overview, daily ledger, and store metrics',
                  style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      onPressed: onNavigateToSale,
                      icon: const Icon(Icons.point_of_sale, size: 18),
                      label: const Text('New Sale / नयाँ बिल'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        minimumSize: const Size(140, 44),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) => const PurchaseEntryScreen()))
                            .then((_) => ref.invalidate(dashboardMetricsProvider));
                      },
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: const Text('New Purchase / नयाँ खरिद'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentTeal,
                        minimumSize: const Size(150, 44),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _openAddItemDialog(context, ref),
                      icon: const Icon(Icons.inventory_2_outlined, size: 18),
                      label: const Text('Add Item'),
                      style: OutlinedButton.styleFrom(minimumSize: const Size(120, 44)),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _backupNow(context, ref),
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('Backup Now'),
                      style: OutlinedButton.styleFrom(minimumSize: const Size(130, 44)),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const PrinterSettingsScreen()),
                        );
                      },
                      icon: const Icon(Icons.print_outlined, size: 18),
                      label: const Text('Printer'),
                      style: OutlinedButton.styleFrom(minimumSize: const Size(110, 44)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Top Metrics Grid
            metricsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Card(
                color: Colors.red.withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Error loading dashboard: $e', style: const TextStyle(color: Colors.redAccent)),
                ),
              ),
              data: (metrics) {
                final card1 = _buildMetricCard(
                  title: "Today's Sales / आजको बिक्री",
                  value: PaisaHelper.formatPaisa(metrics.todaySalesRevenuePaisa),
                  subtitle: '${metrics.todaySalesCount} invoices generated',
                  icon: Icons.payments_outlined,
                  iconColor: AppTheme.primaryBlue,
                  onTap: onNavigateToSale,
                );

                final card2 = _buildMetricCard(
                  title: "Today's Purchases / आजको खरिद",
                  value: PaisaHelper.formatPaisa(metrics.todayPurchaseAmountPaisa),
                  subtitle: '${metrics.todayPurchaseCount} supplier intakes',
                  icon: Icons.local_shipping_outlined,
                  iconColor: AppTheme.accentTeal,
                  onTap: onNavigateToPurchase,
                );

                final card3 = _buildMetricCard(
                  title: 'Low-Stock Alerts / न्यून मौज्दात',
                  value: '${metrics.lowStockCount} Items',
                  subtitle: metrics.lowStockCount > 0 ? 'Requires restocking immediately' : 'Inventory levels healthy',
                  icon: Icons.warning_amber_rounded,
                  iconColor: metrics.lowStockCount > 0 ? Colors.redAccent : Colors.grey,
                  badgeColor: metrics.lowStockCount > 0 ? Colors.redAccent : null,
                  onTap: onNavigateToInventory,
                );

                final card4 = _buildMetricCard(
                  title: 'Total Active Items / कुल सामान',
                  value: '${metrics.totalItemsCount} Products',
                  subtitle: 'Registered in store catalog',
                  icon: Icons.inventory_2_outlined,
                  iconColor: AppTheme.primaryBlue,
                  onTap: onNavigateToInventory,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        if (width < 650) {
                          return Column(
                            children: [
                              card1,
                              const SizedBox(height: 12),
                              card2,
                              const SizedBox(height: 12),
                              card3,
                              const SizedBox(height: 12),
                              card4,
                            ],
                          );
                        } else if (width < 1200) {
                          return Column(
                            children: [
                              Row(children: [Expanded(child: card1), const SizedBox(width: 16), Expanded(child: card2)]),
                              const SizedBox(height: 16),
                              Row(children: [Expanded(child: card3), const SizedBox(width: 16), Expanded(child: card4)]),
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Expanded(child: card1),
                              const SizedBox(width: 16),
                              Expanded(child: card2),
                              const SizedBox(width: 16),
                              Expanded(child: card3),
                              const SizedBox(width: 16),
                              Expanded(child: card4),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // Backup & Offline Status Card
                    ResponsiveCard(
                      child: LayoutBuilder(
                        builder: (context, cardConstraints) {
                          final isCompact = cardConstraints.maxWidth < 650;
                          final infoSection = Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentTeal.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.cloud_done_outlined, color: AppTheme.accentTeal, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Offline-First SQLite Storage Active',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      metrics.lastBackupTime != null
                                          ? 'Last local database backup: ${dateFormat.format(metrics.lastBackupTime!.toLocal())}'
                                          : 'No manual database backup exported yet. Click "Backup Now" to create a backup file.',
                                      style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );

                          final actionBtn = OutlinedButton.icon(
                            onPressed: () => _backupNow(context, ref),
                            icon: const Icon(Icons.download, size: 16),
                            label: const Text('Export SQLite Backup'),
                          );

                          if (isCompact) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                infoSection,
                                const SizedBox(height: 14),
                                actionBtn,
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(child: infoSection),
                              const SizedBox(width: 16),
                              actionBtn,
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    Color? badgeColor,
    VoidCallback? onTap,
  }) {
    return ResponsiveCard(
      minHeight: 125,
      onTap: onTap,
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: badgeColor ?? AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

