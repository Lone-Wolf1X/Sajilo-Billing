import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/paisa_helper.dart';
import '../../inventory/presentation/inventory_provider.dart';
import '../data/purchase_repository.dart';
import 'purchase_provider.dart';

class PurchaseEntryScreen extends ConsumerStatefulWidget {
  const PurchaseEntryScreen({super.key});

  @override
  ConsumerState<PurchaseEntryScreen> createState() => _PurchaseEntryScreenState();
}

class _PurchaseEntryScreenState extends ConsumerState<PurchaseEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _supplierNameController = TextEditingController();
  final _supplierPhoneController = TextEditingController();
  final _supplierPanController = TextEditingController();
  final _billNumberController = TextEditingController();
  final _remarksController = TextEditingController();

  final DateTime _purchaseDate = DateTime.now();
  String? _selectedSupplierId;

  // Active Line Items
  final List<PurchaseLineInput> _lines = [];

  // Current Item Input Row
  Item? _selectedItem;
  final _qtyController = TextEditingController(text: '1');
  final _rateController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  bool _vatApplicable = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _supplierNameController.dispose();
    _supplierPhoneController.dispose();
    _supplierPanController.dispose();
    _billNumberController.dispose();
    _remarksController.dispose();
    _qtyController.dispose();
    _rateController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _onItemSelected(Item? item) {
    setState(() {
      _selectedItem = item;
      if (item != null) {
        _rateController.text = PaisaHelper.toRupees(item.purchasePricePaisa).toStringAsFixed(2);
      }
    });
  }

  void _addLine() {
    if (_selectedItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an item first'), backgroundColor: Colors.orange),
      );
      return;
    }

    final qty = double.tryParse(_qtyController.text) ?? 0.0;
    if (qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantity must be greater than 0'), backgroundColor: Colors.orange),
      );
      return;
    }

    final rateRupees = double.tryParse(_rateController.text) ?? 0.0;
    if (rateRupees <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rate must be greater than 0'), backgroundColor: Colors.orange),
      );
      return;
    }

    final ratePaisa = PaisaHelper.toPaisa(rateRupees);
    final discRupees = double.tryParse(_discountController.text) ?? 0.0;
    final discPaisa = PaisaHelper.toPaisa(discRupees);

    final line = PurchaseLineInput(
      itemId: _selectedItem!.id,
      itemName: _selectedItem!.name,
      unit: _selectedItem!.unit,
      quantity: qty,
      ratePaisa: ratePaisa,
      discountPaisa: discPaisa,
      isVatApplicable: _vatApplicable,
    );

    if (line.discountPaisa > line.grossPaisa) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Discount cannot exceed line total'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      _lines.add(line);
      _selectedItem = null;
      _qtyController.text = '1';
      _rateController.clear();
      _discountController.text = '0';
    });
  }

  void _removeLine(int index) {
    setState(() => _lines.removeAt(index));
  }

  Future<void> _submitPurchase() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one line item to save purchase'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final repo = ref.read(purchaseRepositoryProvider);

    try {
      await repo.createPurchase(
        supplierId: _selectedSupplierId,
        supplierName: _supplierNameController.text.trim(),
        supplierPan: _supplierPanController.text.trim().isEmpty ? null : _supplierPanController.text.trim(),
        billNumber: _billNumberController.text.trim().isEmpty ? null : _billNumberController.text.trim(),
        purchaseDate: _purchaseDate,
        lines: _lines,
        remarks: _remarksController.text.trim().isEmpty ? null : _remarksController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Purchase entry saved and stock updated successfully!'),
            backgroundColor: AppTheme.accentTeal,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving purchase: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final suppliersAsync = ref.watch(suppliersStreamProvider);
    final itemsAsync = ref.watch(itemsStreamProvider);

    final subtotalPaisa = _lines.fold<int>(0, (sum, l) => sum + l.grossPaisa);
    final discountPaisa = _lines.fold<int>(0, (sum, l) => sum + l.discountPaisa);
    final taxablePaisa = _lines.fold<int>(0, (sum, l) => sum + l.taxablePaisa);
    final vatPaisa = _lines.fold<int>(0, (sum, l) => sum + l.vatPaisa);
    final grandTotalPaisa = _lines.fold<int>(0, (sum, l) => sum + l.lineTotalPaisa);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Stock Purchase Entry / नयाँ खरिद दाखिला'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Supplier & Invoice Metadata Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Supplier Details / आपूर्तिकर्ता विवरण',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: suppliersAsync.when(
                              loading: () => const LinearProgressIndicator(),
                              error: (_, __) => const SizedBox(),
                              data: (suppliers) {
                                return Autocomplete<Supplier>(
                                  displayStringForOption: (s) => s.name,
                                  optionsBuilder: (textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return suppliers;
                                    }
                                    return suppliers.where((s) => s.name
                                        .toLowerCase()
                                        .contains(textEditingValue.text.toLowerCase()));
                                  },
                                  onSelected: (Supplier s) {
                                    setState(() {
                                      _selectedSupplierId = s.id;
                                      _supplierNameController.text = s.name;
                                      _supplierPhoneController.text = s.phone ?? '';
                                      _supplierPanController.text = s.panVat ?? '';
                                    });
                                  },
                                  fieldViewBuilder:
                                      (context, controller, focusNode, onFieldSubmitted) {
                                    if (_supplierNameController.text.isNotEmpty &&
                                        controller.text.isEmpty) {
                                      controller.text = _supplierNameController.text;
                                    }
                                    return TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      decoration: const InputDecoration(
                                        labelText: 'Supplier Name *',
                                        hintText: 'e.g. Nepal Wholesale Distributors',
                                      ),
                                      onChanged: (val) {
                                        _supplierNameController.text = val;
                                        _selectedSupplierId = null;
                                      },
                                      validator: (v) =>
                                          (v == null || v.trim().isEmpty) ? 'Supplier name is required' : null,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _supplierPanController,
                              keyboardType: TextInputType.number,
                              maxLength: 9,
                              decoration: const InputDecoration(
                                labelText: 'Supplier PAN (Optional)',
                                hintText: '9 digits',
                                counterText: '',
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _billNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Supplier Bill / Invoice #',
                                hintText: 'e.g. INV-8821',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Line Item Entry Strip
              Card(
                color: AppTheme.backgroundLight,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Products to Purchase / सामान थप्नुहोस्',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: itemsAsync.when(
                              loading: () => const LinearProgressIndicator(),
                              error: (_, __) => const SizedBox(),
                              data: (items) {
                                return DropdownButtonFormField<Item>(
                                  value: _selectedItem,
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Select Item *',
                                    isDense: true,
                                  ),
                                  items: items.map((i) {
                                    return DropdownMenuItem(
                                      value: i,
                                      child: Text(
                                        '${i.name} [Stock: ${i.stockQty} ${i.unit}]',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: _onItemSelected,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _qtyController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: 'Qty *',
                                suffixText: _selectedItem?.unit ?? '',
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _rateController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Rate (Rs.) *',
                                prefixText: 'Rs. ',
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _discountController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Discount (Rs.)',
                                prefixText: 'Rs. ',
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              Checkbox(
                                value: _vatApplicable,
                                onChanged: (v) => setState(() => _vatApplicable = v ?? false),
                              ),
                              const Text('13% VAT', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _addLine,
                            icon: const Icon(Icons.add_shopping_cart, size: 16),
                            label: const Text('Add'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentTeal,
                              minimumSize: const Size(90, 44),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Items Table
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_lines.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(
                          child: Text(
                            'No items added yet. Select products above to populate this purchase invoice.',
                            style: TextStyle(color: AppTheme.textMuted),
                          ),
                        ),
                      )
                    else
                      DataTable(
                        columnSpacing: 20,
                        headingRowColor: MaterialStateProperty.all(AppTheme.backgroundLight),
                        columns: const [
                          DataColumn(label: Text('S.N.', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Item Description', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                          DataColumn(label: Text('Rate', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                          DataColumn(label: Text('Gross', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                          DataColumn(label: Text('Discount', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                          DataColumn(label: Text('VAT (13%)', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                          DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                          DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: List.generate(_lines.length, (index) {
                          final l = _lines[index];
                          return DataRow(
                            cells: [
                              DataCell(Text('${index + 1}')),
                              DataCell(Text(l.itemName, style: const TextStyle(fontWeight: FontWeight.w600))),
                              DataCell(Text('${l.quantity} ${l.unit}')),
                              DataCell(Text(PaisaHelper.formatPaisa(l.ratePaisa))),
                              DataCell(Text(PaisaHelper.formatPaisa(l.grossPaisa))),
                              DataCell(Text(PaisaHelper.formatPaisa(l.discountPaisa))),
                              DataCell(Text(PaisaHelper.formatPaisa(l.vatPaisa))),
                              DataCell(
                                Text(
                                  PaisaHelper.formatPaisa(l.lineTotalPaisa),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                                  onPressed: () => _removeLine(index),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Summary Box and Remarks
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: _remarksController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Purchase Remarks (Optional)',
                            hintText: 'e.g. Paid via Cheque, received in good condition',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 4,
                    child: Card(
                      color: AppTheme.backgroundLight,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            _buildSummaryRow('Subtotal / उप-जम्मा:', PaisaHelper.formatPaisa(subtotalPaisa)),
                            const SizedBox(height: 6),
                            _buildSummaryRow('Discount / छुट:', '- ${PaisaHelper.formatPaisa(discountPaisa)}'),
                            const SizedBox(height: 6),
                            _buildSummaryRow('Taxable / करयोग्य रकम:', PaisaHelper.formatPaisa(taxablePaisa)),
                            const SizedBox(height: 6),
                            _buildSummaryRow('VAT (13%) / भ्याट:', PaisaHelper.formatPaisa(vatPaisa)),
                            const Divider(color: AppTheme.borderSubtle, height: 20),
                            _buildSummaryRow(
                              'Grand Total / कुल जम्मा:',
                              PaisaHelper.formatPaisa(grandTotalPaisa),
                              isBold: true,
                              textColor: AppTheme.primaryBlue,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _isSaving ? null : _submitPurchase,
                              icon: const Icon(Icons.check_circle_outline),
                              label: _isSaving
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text('Save Purchase & Update Stock'),
                              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: textColor ?? AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}
