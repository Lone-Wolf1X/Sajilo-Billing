import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_theme.dart';
import '../inventory_provider.dart';

class StockAdjustmentDialog extends ConsumerStatefulWidget {
  final Item item;

  const StockAdjustmentDialog({super.key, required this.item});

  @override
  ConsumerState<StockAdjustmentDialog> createState() => _StockAdjustmentDialogState();
}

class _StockAdjustmentDialogState extends ConsumerState<StockAdjustmentDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _newQtyController;
  late TextEditingController _notesController;

  String _selectedReason = 'Physical Audit Count (भौतिक मौज्दात गणना)';
  bool _isSaving = false;

  final _commonReasons = const [
    'Physical Audit Count (भौतिक मौज्दात गणना)',
    'Damaged Goods (क्षतिग्रस्त सामान)',
    'Expired Product (म्याद सकिएको)',
    'Wastage / Leakage (चुहावट वा खेर गएको)',
    'Initial Count Correction (सुरुवाती गणना सुधार)',
    'Other (अन्य कारण)',
  ];

  @override
  void initState() {
    super.initState();
    _newQtyController = TextEditingController(text: widget.item.stockQty.toString());
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _newQtyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final newQty = double.tryParse(_newQtyController.text);
    if (newQty == null || newQty < 0) return;

    setState(() => _isSaving = true);
    final repo = ref.read(inventoryRepositoryProvider);

    try {
      await repo.adjustStock(
        itemId: widget.item.id,
        newQty: newQty,
        reason: _selectedReason,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Adjustment failed: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final currentQty = item.stockQty;
    final enteredQty = double.tryParse(_newQtyController.text) ?? currentQty;
    final delta = enteredQty - currentQty;

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
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.tune, color: AppTheme.primaryBlue),
                          SizedBox(width: 10),
                          Text(
                            'Stock Adjustment (मौज्दात समायोजन)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(color: AppTheme.borderSubtle),
                  const SizedBox(height: 12),

                  // Item details banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        if (item.nepaliName != null)
                          Text(
                            item.nepaliName!,
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SKU: ${item.sku}',
                              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                            ),
                            Text(
                              'Current Stock: $currentQty ${item.unit}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // New Physical Stock input
                  TextFormField(
                    controller: _newQtyController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'New Physical Stock Count (${item.unit}) *',
                      suffixText: item.unit,
                      helperText: delta == 0
                          ? 'No change in quantity'
                          : delta > 0
                              ? 'Change: +$delta ${item.unit} (Increase)'
                              : 'Change: $delta ${item.unit} (Decrease)',
                      helperStyle: TextStyle(
                        color: delta > 0
                            ? AppTheme.accentTeal
                            : delta < 0
                                ? Colors.redAccent
                                : AppTheme.textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      final n = double.tryParse(v ?? '');
                      if (n == null || n < 0) return 'Enter a valid stock quantity (>= 0)';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Reason Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedReason,
                    decoration: const InputDecoration(labelText: 'Reason for Adjustment *'),
                    items: _commonReasons
                        .map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedReason = v);
                    },
                  ),
                  const SizedBox(height: 14),

                  // Notes input
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Audit Notes (Optional)',
                      hintText: 'e.g. Broken packaging discovered during shelf check',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel / रद्द'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _isSaving ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentTeal,
                          minimumSize: const Size(140, 42),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('Apply Adjustment'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
