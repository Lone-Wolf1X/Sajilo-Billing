import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/paisa_helper.dart';
import '../inventory_provider.dart';

class ItemFormDialog extends ConsumerStatefulWidget {
  final Item? existingItem;

  const ItemFormDialog({super.key, this.existingItem});

  @override
  ConsumerState<ItemFormDialog> createState() => _ItemFormDialogState();
}

class _ItemFormDialogState extends ConsumerState<ItemFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _nepaliNameController;
  late TextEditingController _skuController;
  late TextEditingController _costPriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _initialStockController;
  late TextEditingController _thresholdController;

  String? _selectedCategoryId;
  String _selectedUnit = 'pcs';
  bool _isSaving = false;

  bool get isEditing => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.existingItem;
    _nameController = TextEditingController(text: item?.name ?? '');
    _nepaliNameController = TextEditingController(text: item?.nepaliName ?? '');
    _skuController = TextEditingController(
      text: item?.sku ?? 'SKU-${DateTime.now().millisecondsSinceEpoch % 100000}',
    );
    _costPriceController = TextEditingController(
      text: item != null ? PaisaHelper.toRupees(item.purchasePricePaisa).toStringAsFixed(2) : '',
    );
    _sellingPriceController = TextEditingController(
      text: item != null ? PaisaHelper.toRupees(item.sellingPricePaisa).toStringAsFixed(2) : '',
    );
    _initialStockController = TextEditingController(
      text: item != null ? item.stockQty.toString() : '0',
    );
    _thresholdController = TextEditingController(
      text: item != null ? item.lowStockThreshold.toString() : '5',
    );
    _selectedCategoryId = item?.categoryId;
    _selectedUnit = item?.unit ?? 'pcs';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nepaliNameController.dispose();
    _skuController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    _initialStockController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final repo = ref.read(inventoryRepositoryProvider);

    try {
      final costPaisa = PaisaHelper.toPaisa(double.tryParse(_costPriceController.text) ?? 0.0);
      final sellingPaisa = PaisaHelper.toPaisa(double.tryParse(_sellingPriceController.text) ?? 0.0);
      final threshold = double.tryParse(_thresholdController.text) ?? 5.0;

      if (isEditing) {
        await repo.updateItem(
          id: widget.existingItem!.id,
          name: _nameController.text.trim(),
          nepaliName: _nepaliNameController.text.trim(),
          sku: _skuController.text.trim(),
          categoryId: _selectedCategoryId,
          unit: _selectedUnit,
          purchasePricePaisa: costPaisa,
          sellingPricePaisa: sellingPaisa,
          lowStockThreshold: threshold,
        );
      } else {
        final initialStock = double.tryParse(_initialStockController.text) ?? 0.0;
        await repo.addItem(
          name: _nameController.text.trim(),
          nepaliName: _nepaliNameController.text.trim(),
          sku: _skuController.text.trim(),
          categoryId: _selectedCategoryId,
          unit: _selectedUnit,
          purchasePricePaisa: costPaisa,
          sellingPricePaisa: sellingPaisa,
          initialStock: initialStock,
          lowStockThreshold: threshold,
        );
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final unitsAsync = ref.watch(unitsStreamProvider);

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.of(context).pop();
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEditing ? 'Edit Product / सामान सम्पादन' : 'Add New Product / नयाँ सामान',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const Divider(color: AppTheme.borderSubtle),
                    const SizedBox(height: 16),

                    // Name fields
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Item Name (English) *',
                              hintText: 'e.g. Basmati Rice 25kg',
                            ),
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Item name is required' : null,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextFormField(
                            controller: _nepaliNameController,
                            decoration: const InputDecoration(
                              labelText: 'Nepali Name (नेपाली नाम)',
                              hintText: 'उदा. बासमती चामल',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // SKU & Category
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _skuController,
                            decoration: const InputDecoration(
                              labelText: 'SKU / Barcode *',
                              hintText: 'e.g. RICE-BAS-25',
                            ),
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'SKU is required' : null,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: categoriesAsync.when(
                            loading: () => const LinearProgressIndicator(),
                            error: (_, __) => const SizedBox(),
                            data: (cats) {
                              return DropdownButtonFormField<String?>(
                                value: _selectedCategoryId,
                                decoration: const InputDecoration(
                                  labelText: 'Category (वर्ग)',
                                ),
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('No Category')),
                                  ...cats.map((c) => DropdownMenuItem(
                                        value: c.id,
                                        child: Text(c.nepaliName != null ? '${c.name} (${c.nepaliName})' : c.name),
                                      )),
                                ],
                                onChanged: (v) => setState(() => _selectedCategoryId = v),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Unit & Pricing
                    Row(
                      children: [
                        Expanded(
                          child: unitsAsync.when(
                            loading: () => const LinearProgressIndicator(),
                            error: (_, __) => const SizedBox(),
                            data: (units) {
                              return DropdownButtonFormField<String>(
                                value: units.any((u) => u.symbol == _selectedUnit) ? _selectedUnit : 'pcs',
                                decoration: const InputDecoration(labelText: 'Unit *'),
                                items: units.map((u) {
                                  final label = u.nepaliSymbol != null ? '${u.symbol} (${u.nepaliSymbol})' : u.symbol;
                                  return DropdownMenuItem(value: u.symbol, child: Text(label));
                                }).toList(),
                                onChanged: (v) {
                                  if (v != null) setState(() => _selectedUnit = v);
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextFormField(
                            controller: _costPriceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Cost Price (Rs.) *',
                              prefixText: 'Rs. ',
                            ),
                            validator: (v) {
                              final num = double.tryParse(v ?? '');
                              if (num == null || num < 0) return 'Invalid cost price';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextFormField(
                            controller: _sellingPriceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Selling Price (Rs.) *',
                              prefixText: 'Rs. ',
                            ),
                            validator: (v) {
                              final num = double.tryParse(v ?? '');
                              if (num == null || num <= 0) return 'Selling price must be > 0';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Stock thresholds
                    Row(
                      children: [
                        if (!isEditing) ...[
                          Expanded(
                            child: TextFormField(
                              controller: _initialStockController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Opening Stock',
                                hintText: '0',
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                        ],
                        Expanded(
                          child: TextFormField(
                            controller: _thresholdController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Low-Stock Alert Level',
                              hintText: '5',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel / रद्द'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(minimumSize: const Size(130, 44)),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Text(isEditing ? 'Save Changes' : 'Add Item'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
