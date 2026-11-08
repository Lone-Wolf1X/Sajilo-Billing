import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syntech_nepali_calendar/syntech_nepali_calendar.dart';

import '../../../core/database/app_database.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/nepali_validators.dart';
import '../../../core/utils/paisa_helper.dart';
import '../../business/presentation/business_provider.dart';
import '../../inventory/presentation/inventory_provider.dart';
import '../data/pdf_bill_generator.dart';
import '../data/sales_repository.dart';
import '../domain/bill_model.dart';
import 'sales_provider.dart';
import '../../printing/data/printer_repository.dart';
import '../../printing/domain/receipt_printer.dart';
import '../../printing/presentation/print_button.dart';

class PosBillingScreen extends ConsumerStatefulWidget {
  const PosBillingScreen({super.key});

  @override
  ConsumerState<PosBillingScreen> createState() => _PosBillingScreenState();
}

class _PosBillingScreenState extends ConsumerState<PosBillingScreen> {
  final _customerNameController = TextEditingController(text: 'Cash Customer / नगद ग्राहक');
  final _customerPhoneController = TextEditingController();
  final _customerPanController = TextEditingController();
  final _billDiscountController = TextEditingController(text: '0');
  final _tenderedController = TextEditingController(text: '0');

  // Active Cart Lines
  final List<SaleLineInput> _cartLines = [];

  // Item Search / Selection
  Item? _selectedItem;
  final _qtyController = TextEditingController(text: '1');
  final _rateController = TextEditingController();
  final _discountController = TextEditingController(text: '0');

  bool _isVatBill = false;
  String _paymentMode = 'CASH';
  bool _isSaving = false;
  String? _stockErrorMessage;

  // Bill Date Settings
  bool _isAutoDate = true;
  DateTime _selectedInvoiceDate = DateTime.now();

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerPanController.dispose();
    _billDiscountController.dispose();
    _tenderedController.dispose();
    _qtyController.dispose();
    _rateController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _onItemSelected(Item? item) {
    setState(() {
      _selectedItem = item;
      _stockErrorMessage = null;
      if (item != null) {
        _rateController.text = PaisaHelper.toRupees(item.sellingPricePaisa).toStringAsFixed(2);
      }
    });
  }

  void _addItemToCart() {
    if (_selectedItem == null) return;

    final qty = double.tryParse(_qtyController.text) ?? 0.0;
    if (qty <= 0) {
      setState(() => _stockErrorMessage = 'Quantity must be greater than 0');
      return;
    }

    // Check stock availability
    if (_selectedItem!.stockQty < qty) {
      setState(() {
        _stockErrorMessage =
            'Insufficient stock for "${_selectedItem!.name}". Available: ${_selectedItem!.stockQty} ${_selectedItem!.unit}';
      });
      return;
    }

    final rateRupees = double.tryParse(_rateController.text) ?? 0.0;
    if (rateRupees <= 0) {
      setState(() => _stockErrorMessage = 'Rate must be greater than 0');
      return;
    }

    final ratePaisa = PaisaHelper.toPaisa(rateRupees);
    final discRupees = double.tryParse(_discountController.text) ?? 0.0;
    final discPaisa = PaisaHelper.toPaisa(discRupees);

    final line = SaleLineInput(
      itemId: _selectedItem!.id,
      itemName: _selectedItem!.name,
      unit: _selectedItem!.unit,
      quantity: qty,
      ratePaisa: ratePaisa,
      discountPaisa: discPaisa,
      isVatApplicable: _isVatBill,
    );

    setState(() {
      _cartLines.add(line);
      _selectedItem = null;
      _qtyController.text = '1';
      _rateController.clear();
      _discountController.text = '0';
      _stockErrorMessage = null;
    });
  }

  void _removeCartLine(int index) {
    setState(() => _cartLines.removeAt(index));
  }

  void _clearCart() {
    setState(() {
      _cartLines.clear();
      _selectedItem = null;
      _billDiscountController.text = '0';
      _tenderedController.text = '0';
      _stockErrorMessage = null;
    });
  }

  Future<void> _completeCheckout() async {
    if (_cartLines.isEmpty) {
      setState(() => _stockErrorMessage = 'Cart is empty. Please add items to generate bill.');
      return;
    }

    // Validate PAN if customer entered one
    final panVal = _customerPanController.text.trim();
    if (panVal.isNotEmpty) {
      final panErr = NepaliValidators.validatePanVat(panVal);
      if (panErr != null) {
        setState(() => _stockErrorMessage = panErr);
        return;
      }
    }

    setState(() {
      _isSaving = true;
      _stockErrorMessage = null;
    });

    final salesRepo = ref.read(salesRepositoryProvider);
    final businessRepo = ref.read(businessRepositoryProvider);

    try {
      final billDiscountPaisa = PaisaHelper.toPaisa(double.tryParse(_billDiscountController.text) ?? 0.0);
      final tenderedPaisa = PaisaHelper.toPaisa(double.tryParse(_tenderedController.text) ?? 0.0);

      final sale = await salesRepo.createSale(
        customerName: _customerNameController.text.trim(),
        customerPhone: _customerPhoneController.text.trim().isEmpty ? null : _customerPhoneController.text.trim(),
        customerPan: _customerPanController.text.trim().isEmpty ? null : _customerPanController.text.trim(),
        invoiceDate: _isAutoDate ? null : _selectedInvoiceDate,
        lines: _cartLines,
        billDiscountPaisa: billDiscountPaisa,
        tenderedPaisa: tenderedPaisa,
        paymentMode: _paymentMode,
      );

      final profile = await businessRepo.getCurrentProfile();
      if (profile != null) {
        // Fetch saved line items
        final details = await salesRepo.getSaleDetails(sale.id);
        if (details != null) {
          Uint8List? logoBytes;
          if (profile.logoPath != null) {
            final f = File(profile.logoPath!);
            if (await f.exists()) logoBytes = await f.readAsBytes();
          }

          final billData = BillData.fromSaleRecord(
            profile: profile,
            sale: details.sale,
            saleItems: details.items,
            logoBytes: logoBytes,
          );

          final pdfDoc = await PdfBillGenerator.generateDocument(billData);
          final pdfBytes = await pdfDoc.save();

          await PdfBillGenerator.saveToAppDocuments(billData, pdfBytes);

          // Check for auto-print thermal receipt configuration
          try {
            final printerConfig = await ref.read(printerConfigProvider.future);
            if (printerConfig.autoPrintAfterSale) {
              await ReceiptPrinter.instance.printReceipt(
                billData,
                printerConfig.defaultFormat,
                printerConfig,
              );
            }
          } catch (printErr) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sale saved, but auto-printing failed: $printErr'),
                  backgroundColor: AppTheme.dangerRed,
                ),
              );
            }
          }

          if (mounted) {
            _showInvoiceSuccessModal(billData, pdfBytes);
            _clearCart();
          }
        }
      }
    } catch (e) {
      setState(() => _stockErrorMessage = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showInvoiceSuccessModal(BillData billData, Uint8List pdfBytes) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppTheme.accentTeal, size: 28),
            const SizedBox(width: 10),
            Text('Invoice ${billData.invoiceNumber} Generated!'),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer: ${billData.customerName}'),
              Text('Total Amount: Rs. ${billData.grandTotal.toStringAsFixed(2)}'),
              Text('Payment: ${billData.paymentMode}'),
              const SizedBox(height: 14),
              const Text(
                'Stock ledger updated and bill PDF archived in local documents folder.',
                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close / बन्द गर्नुहोस्'),
          ),
          OutlinedButton.icon(
            onPressed: () async {
              await PdfBillGenerator.exportPdf(billData, pdfBytes);
            },
            icon: const Icon(Icons.download, size: 16),
            label: const Text('Export PDF'),
          ),
          PrintButton(bill: billData),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(itemsStreamProvider);

    final subtotalPaisa = _cartLines.fold<int>(0, (sum, l) => sum + l.grossPaisa);
    final lineDiscountPaisa = _cartLines.fold<int>(0, (sum, l) => sum + l.discountPaisa);
    final billDiscountRupees = double.tryParse(_billDiscountController.text) ?? 0.0;
    final billDiscountPaisa = PaisaHelper.toPaisa(billDiscountRupees);
    final totalDiscountPaisa = lineDiscountPaisa + billDiscountPaisa;

    var taxablePaisa = (subtotalPaisa - totalDiscountPaisa).clamp(0, 999999999);
    var vatPaisa = _isVatBill ? (taxablePaisa * 0.13).round() : 0;
    var grandTotalPaisa = taxablePaisa + vatPaisa;

    final tenderedRupees = double.tryParse(_tenderedController.text) ?? 0.0;
    final tenderedPaisa = PaisaHelper.toPaisa(tenderedRupees);
    final changePaisa = tenderedPaisa > grandTotalPaisa ? (tenderedPaisa - grandTotalPaisa) : 0;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 1000;

          final leftSection = Padding(
            padding: EdgeInsets.all(isNarrow ? 12.0 : 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title and Clear Button
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Billing Counter (POS) / बिक्री काउन्टर',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                        SizedBox(height: 2),
                        Text('Fast retail checkout with automatic stock audit', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                      ],
                    ),
                    if (_cartLines.isNotEmpty)
                      TextButton.icon(
                        onPressed: _clearCart,
                        icon: const Icon(Icons.delete_sweep, color: Colors.redAccent, size: 18),
                        label: const Text('Clear Cart / खाली गर्नुहोस्', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Item Search and Add Bar
                Card(
                  color: AppTheme.backgroundLight,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: isNarrow
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildItemDropdown(itemsAsync),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _qtyController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        labelText: 'Qty',
                                        suffixText: _selectedItem?.unit ?? '',
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _rateController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: const InputDecoration(
                                        labelText: 'Rate (Rs.)',
                                        prefixText: 'Rs. ',
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _discountController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: const InputDecoration(
                                        labelText: 'Disc (Rs.)',
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: _addItemToCart,
                                icon: const Icon(Icons.add_shopping_cart, size: 16),
                                label: const Text('Add Item to Bill'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryBlue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: _buildItemDropdown(itemsAsync),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 85,
                                child: TextFormField(
                                  controller: _qtyController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Qty',
                                    suffixText: _selectedItem?.unit ?? '',
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 110,
                                child: TextFormField(
                                  controller: _rateController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Rate (Rs.)',
                                    prefixText: 'Rs. ',
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 95,
                                child: TextFormField(
                                  controller: _discountController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Disc (Rs.)',
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: _addItemToCart,
                                icon: const Icon(Icons.add_shopping_cart, size: 16),
                                label: const Text('Add'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryBlue,
                                  minimumSize: const Size(80, 44),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                // Inline Stock Error Notification
                if (_stockErrorMessage != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.redAccent),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _stockErrorMessage!,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),

                // Live Cart Table
                if (isNarrow)
                  SizedBox(height: 260, child: _buildCartTable())
                else
                  Expanded(child: _buildCartTable()),
              ],
            ),
          );

          final checkoutPanel = Container(
            width: isNarrow ? double.infinity : 380,
            decoration: BoxDecoration(
              color: Colors.white,
              border: isNarrow
                  ? const Border(top: BorderSide(color: AppTheme.borderSubtle))
                  : const Border(left: BorderSide(color: AppTheme.borderSubtle)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: _buildCheckoutForm(subtotalPaisa, taxablePaisa, vatPaisa, grandTotalPaisa, changePaisa),
            ),
          );

          if (isNarrow) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  leftSection,
                  checkoutPanel,
                ],
              ),
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 7, child: leftSection),
              checkoutPanel,
            ],
          );
        },
      ),
    );
  }

  Widget _buildItemDropdown(AsyncValue<List<Item>> itemsAsync) {
    return itemsAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const SizedBox(),
      data: (items) {
        return DropdownButtonFormField<Item>(
          value: _selectedItem,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Search / Select Item *',
            isDense: true,
          ),
          items: items.map((item) {
            final stockColor = item.stockQty <= item.lowStockThreshold ? Colors.redAccent : AppTheme.accentTeal;
            return DropdownMenuItem(
              value: item,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(item.name, overflow: TextOverflow.ellipsis)),
                  Text(
                    'Stock: ${item.stockQty} ${item.unit}',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: stockColor),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    PaisaHelper.formatPaisa(item.sellingPricePaisa),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: _onItemSelected,
        );
      },
    );
  }

  Widget _buildCartTable() {
    return Card(
      child: _cartLines.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_basket_outlined, size: 54, color: AppTheme.textMuted),
                    SizedBox(height: 10),
                    Text(
                      'Cart is empty. Select products above to start billing.',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 18,
                  headingRowColor: MaterialStateProperty.all(AppTheme.backgroundLight),
                  columns: const [
                    DataColumn(label: Text('S.N.', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Item Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                    DataColumn(label: Text('Rate', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                    DataColumn(label: Text('Disc', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                    DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                    DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: List.generate(_cartLines.length, (index) {
                    final line = _cartLines[index];
                    return DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(Text(line.itemName, style: const TextStyle(fontWeight: FontWeight.w600))),
                        DataCell(Text('${line.quantity} ${line.unit}')),
                        DataCell(Text(PaisaHelper.formatPaisa(line.ratePaisa))),
                        DataCell(Text(PaisaHelper.formatPaisa(line.discountPaisa))),
                        DataCell(
                          Text(
                            PaisaHelper.formatPaisa(line.lineTotalPaisa),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 18),
                            onPressed: () => _removeCartLine(index),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
    );
  }

  Widget _buildCheckoutForm(
    int subtotalPaisa,
    int taxablePaisa,
    int vatPaisa,
    int grandTotalPaisa,
    int changePaisa,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Customer & Payment / ग्राहक तथा भुक्तानी',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),

        // Invoice Date Mode Toggle & Nepali Calendar Display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_month_outlined, size: 16, color: AppTheme.primaryBlue),
                      SizedBox(width: 6),
                      Text(
                        'Bill Date / बिल मिति',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => setState(() => _isAutoDate = true),
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isAutoDate ? AppTheme.primaryBlue : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _isAutoDate ? AppTheme.primaryBlue : AppTheme.borderSubtle,
                            ),
                          ),
                          child: Text(
                            'Auto',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _isAutoDate ? Colors.white : AppTheme.textDark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => setState(() => _isAutoDate = false),
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: !_isAutoDate ? AppTheme.primaryBlue : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: !_isAutoDate ? AppTheme.primaryBlue : AppTheme.borderSubtle,
                            ),
                          ),
                          child: Text(
                            'Manual',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: !_isAutoDate ? Colors.white : AppTheme.textDark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Builder(
                builder: (context) {
                  final effectiveDate = _isAutoDate ? DateTime.now() : _selectedInvoiceDate;
                  final bsDateStr = NepaliDateFormat('yyyy-MM-dd', Language.nepali).format(effectiveDate.toNepaliDateTime());
                  final adDateStr = '${effectiveDate.year}-${effectiveDate.month.toString().padLeft(2, '0')}-${effectiveDate.day.toString().padLeft(2, '0')}';
                  return InkWell(
                    onTap: _isAutoDate ? null : () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedInvoiceDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );
                      if (picked != null) {
                        setState(() => _selectedInvoiceDate = picked);
                      }
                    },
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '$adDateStr AD',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accentTeal.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'वि.सं. $bsDateStr',
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppTheme.accentTeal),
                          ),
                        ),
                        if (!_isAutoDate)
                          const Icon(Icons.edit_calendar, size: 14, color: AppTheme.primaryBlue),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Customer Fields
        TextFormField(
          controller: _customerNameController,
          decoration: const InputDecoration(
            labelText: 'Customer Name / ग्राहकको नाम',
            prefixIcon: Icon(Icons.person_outline, size: 20),
            isDense: true,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _customerPhoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  counterText: '',
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _customerPanController,
                keyboardType: TextInputType.number,
                maxLength: 9,
                decoration: const InputDecoration(
                  labelText: 'Buyer PAN',
                  counterText: '',
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // VAT Toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderSubtle),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Issue 13% VAT Bill (कर बिजक)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              Switch(
                value: _isVatBill,
                activeColor: AppTheme.primaryBlue,
                onChanged: (val) => setState(() => _isVatBill = val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Payment Mode Choice
        const Text('Payment Mode (भुक्तानीको माध्यम):', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _buildPaymentChip('CASH', 'Cash / नगद'),
            _buildPaymentChip('FONEPAY', 'Fonepay / QR'),
            _buildPaymentChip('CREDIT', 'Credit / उधारो'),
          ],
        ),
        const SizedBox(height: 14),

        // Calculations
        _buildCalcRow('Subtotal / उप-जम्मा:', PaisaHelper.formatPaisa(subtotalPaisa)),
        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text('Bill Discount (Rs.):', style: TextStyle(fontSize: 13)),
            ),
            SizedBox(
              width: 100,
              child: TextFormField(
                controller: _billDiscountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.right,
                decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(8)),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        _buildCalcRow('Taxable Amount:', PaisaHelper.formatPaisa(taxablePaisa)),
        const SizedBox(height: 8),
        _buildCalcRow('13% VAT:', PaisaHelper.formatPaisa(vatPaisa)),
        const Divider(color: AppTheme.borderSubtle, height: 20),

        _buildCalcRow(
          'Grand Total / कुल जम्मा:',
          PaisaHelper.formatPaisa(grandTotalPaisa),
          isBold: true,
          color: AppTheme.primaryBlue,
          fontSize: 18,
        ),
        const SizedBox(height: 14),

        // Tendered and Change calculator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text('Tendered Cash (रु.):', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
            SizedBox(
              width: 120,
              child: TextFormField(
                controller: _tenderedController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  isDense: true,
                  prefixText: 'Rs. ',
                  contentPadding: EdgeInsets.all(8),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.accentTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Change Return (फिर्ता रकम):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.accentTeal),
                ),
              ),
              Text(
                PaisaHelper.formatPaisa(changePaisa),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.accentTeal),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Complete Checkout Button
        ElevatedButton.icon(
          onPressed: _isSaving ? null : _completeCheckout,
          icon: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Icon(Icons.print),
          label: const Text('Complete & Generate Bill (Enter)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            minimumSize: const Size.fromHeight(50),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentChip(String mode, String label) {
    final isSelected = _paymentMode == mode;
    return InkWell(
      onTap: () => setState(() => _paymentMode = mode),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildCalcRow(String label, String value, {bool isBold = false, Color? color, double fontSize = 13}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}
