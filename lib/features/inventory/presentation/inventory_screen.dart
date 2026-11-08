import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/database/app_database.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/paisa_helper.dart';
import 'inventory_provider.dart';
import 'widgets/item_form_dialog.dart';
import 'widgets/stock_adjustment_dialog.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openItemDialog([Item? item]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ItemFormDialog(existingItem: item),
    );
  }

  void _openAdjustmentDialog(Item item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StockAdjustmentDialog(item: item),
    );
  }

  Future<void> _deleteItem(Item item) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteProduct),
        content: Text('${l10n.confirmDeleteProduct}\n\n"${item.name}"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repo = ref.read(inventoryRepositoryProvider);
      await repo.deleteItem(item.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item archived successfully'), backgroundColor: AppTheme.accentTeal),
        );
      }
    }
  }

  Future<void> _seedDefaultItems() async {
    final repo = ref.read(inventoryRepositoryProvider);
    await repo.seedDevData();
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.sampleProductsLoaded), backgroundColor: AppTheme.accentTeal),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final itemsAsync = ref.watch(itemsStreamProvider);
    final filter = ref.watch(inventoryFilterProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Controls
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.inventory,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.inventorySubtitle,
                        style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _seedDefaultItems,
                  icon: const Icon(Icons.auto_fix_high, size: 16),
                  label: Text(l10n.seedSampleProducts),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _openItemDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.addProduct),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(140, 42)),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Search and Filter Bar
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    // Search Input
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: l10n.searchProducts,
                          prefixIcon: const Icon(Icons.search, size: 20),
                          isDense: true,
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    ref
                                        .read(inventoryFilterProvider.notifier)
                                        .update((s) => s.copyWith(searchQuery: ''));
                                  },
                                )
                              : null,
                        ),
                        onChanged: (val) {
                          ref
                              .read(inventoryFilterProvider.notifier)
                              .update((s) => s.copyWith(searchQuery: val));
                        },
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Category Dropdown Filter
                    Expanded(
                      flex: 3,
                      child: categoriesAsync.when(
                        loading: () => const SizedBox(),
                        error: (_, __) => const SizedBox(),
                        data: (cats) {
                          return DropdownButtonFormField<String?>(
                            value: filter.categoryId,
                            decoration: const InputDecoration(
                              labelText: 'Category Filter',
                              isDense: true,
                            ),
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Categories')),
                              ...cats.map((c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c.name, overflow: TextOverflow.ellipsis),
                                  )),
                            ],
                            onChanged: (catId) {
                              ref.read(inventoryFilterProvider.notifier).update((s) =>
                                  s.copyWith(categoryId: catId, clearCategory: catId == null));
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Low-Stock Filter Toggle
                    FilterChip(
                      selected: filter.lowStockOnly,
                      showCheckmark: true,
                      avatar: const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange),
                      label: const Text('Low Stock Only', style: TextStyle(fontSize: 13)),
                      onSelected: (val) {
                        ref
                            .read(inventoryFilterProvider.notifier)
                            .update((s) => s.copyWith(lowStockOnly: val));
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Products Table View
            Expanded(
              child: itemsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error loading inventory: $e')),
                data: (items) {
                  if (items.isEmpty) {
                    return Card(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.inventory_2_outlined, size: 54, color: AppTheme.textMuted),
                            const SizedBox(height: 12),
                            Text(
                              l10n.noProductsFound,
                              style: const TextStyle(fontSize: 15, color: AppTheme.textMuted),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _seedDefaultItems,
                              icon: const Icon(Icons.download, size: 16),
                              label: Text(l10n.seedSampleProducts),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          columnSpacing: 24,
                          headingRowColor: MaterialStateProperty.all(AppTheme.backgroundLight),
                          columns: const [
                            DataColumn(label: Text('Item Name / नाम', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('SKU / Code', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Unit', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Cost Price', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                            DataColumn(label: Text('Selling Price', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                            DataColumn(label: Text('Current Stock', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                            DataColumn(label: Text('Actions / कार्य', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: items.map((item) {
                            final isLowStock = item.stockQty <= item.lowStockThreshold;

                            return DataRow(
                              cells: [
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      if (item.nepaliName != null)
                                        Text(
                                          item.nepaliName!,
                                          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                        ),
                                    ],
                                  ),
                                ),
                                DataCell(Text(item.sku, style: const TextStyle(fontSize: 12))),
                                DataCell(Text(item.unit)),
                                DataCell(Text(PaisaHelper.formatPaisa(item.purchasePricePaisa))),
                                DataCell(
                                  Text(
                                    PaisaHelper.formatPaisa(item.sellingPricePaisa),
                                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${item.stockQty} ${item.unit}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isLowStock ? Colors.redAccent : AppTheme.textDark,
                                        ),
                                      ),
                                      if (isLowStock) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'LOW',
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.tune, size: 18),
                                        tooltip: 'Stock Adjustment (मौज्दात समायोजन)',
                                        color: AppTheme.accentTeal,
                                        onPressed: () => _openAdjustmentDialog(item),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined, size: 18),
                                        tooltip: 'Edit Details',
                                        color: AppTheme.primaryBlue,
                                        onPressed: () => _openItemDialog(item),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 18),
                                        tooltip: 'Archive / Delete',
                                        color: Colors.redAccent,
                                        onPressed: () => _deleteItem(item),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

