import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syntech_nepali_calendar/syntech_nepali_calendar.dart';

import '../../../core/database/app_database.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/nepali_unicode_helper.dart';
import '../../../core/utils/nepali_validators.dart';
import '../../../core/utils/paisa_helper.dart';
import '../../business/presentation/business_provider.dart';
import '../../inventory/presentation/inventory_provider.dart';
import '../data/html_bill_generator.dart';
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

  bool _isNepaliScript = false;
  final _qtyFocusNode = FocusNode();

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
    _qtyFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    try {
      const typeGroup = XTypeGroup(
        label: 'images',
        extensions: <String>['jpg', 'jpeg', 'png', 'webp'],
      );
      final file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
      if (file != null) {
        final repo = ref.read(businessRepositoryProvider);
        final persistedPath = await repo.persistLogoFile(file.path);
        final profile = await repo.getCurrentProfile();
        if (profile != null) {
          await repo.saveBusinessProfile(
            businessName: profile.businessName,
            businessNameNepali: profile.businessNameNepali,
            panVatNumber: profile.panVatNumber,
            contactNumber: profile.contactNumber,
            shopAddress: profile.shopAddress,
            logoPath: persistedPath,
          );
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Shop logo updated and linked to bill templates!'),
              backgroundColor: AppTheme.accentTeal,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update logo: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  void _onItemSelected(Item? item) {
    setState(() {
      _selectedItem = item;
      _stockErrorMessage = null;
      if (item != null) {
        _rateController.text = PaisaHelper.toRupees(item.sellingPricePaisa).toStringAsFixed(2);
        // Automatically focus on quantity so cashier can just type qty and hit enter
        _qtyController.selection = TextSelection(baseOffset: 0, extentOffset: _qtyController.text.length);
        _qtyFocusNode.requestFocus();
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

  Future<void> _completeCheckout({bool isDraft = false}) async {
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
        status: isDraft ? 'DRAFT' : 'VERIFIED',
      );

      if (isDraft) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bill saved as DRAFT (${sale.invoiceNumber})! You can validate & verify it in Sales Register.'),
              backgroundColor: Colors.orange.shade800,
            ),
          );
          _clearCart();
        }
        return;
      }

      final profile = await businessRepo.getCurrentProfile();
      if (profile != null) {
        // Fetch saved line items
        final details = await salesRepo.getSaleDetails(sale.id);
        if (details != null) {
          Uint8List? logoBytes;
          if (!kIsWeb && profile.logoPath != null) {
            try {
              final f = File(profile.logoPath!);
              if (await f.exists()) logoBytes = await f.readAsBytes();
            } catch (_) {
              // Ignore logo loading error
            }
          }

          final billData = BillData.fromSaleRecord(
            profile: profile,
            sale: details.sale,
            saleItems: details.items,
            logoBytes: logoBytes,
          );

          Uint8List? pdfBytes;
          try {
            final pdfDoc = await PdfBillGenerator.generateDocument(billData);
            pdfBytes = await pdfDoc.save();
            await PdfBillGenerator.saveToAppDocuments(billData, pdfBytes);
          } catch (pdfErr) {
            debugPrint('Non-fatal: Bill PDF caching failed: $pdfErr');
          }

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
            _showInvoiceSuccessModal(billData, pdfBytes ?? Uint8List(0));
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
            Text('Invoice ${billData.invoiceNumber} Verified & Issued!'),
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
          // HTML Print Options Popup
          PopupMenuButton<BillTemplateStyle>(
            tooltip: 'Print HTML Bill / नयाँ बिल ढाँचा',
            onSelected: (style) async {
              await HtmlBillGenerator.printOrPreviewHtml(billData, style: style);
            },
            itemBuilder: (ctx) => BillTemplateStyle.values.map((s) {
              return PopupMenuItem(
                value: s,
                child: Row(
                  children: [
                    Icon(
                      s.id.contains('pad') ? Icons.receipt_long : Icons.article,
                      color: s.id.contains('pad') ? const Color(0xFF561131) : const Color(0xFFC62828),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(s.label),
                  ],
                ),
              );
            }).toList(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF561131),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.print_outlined, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text('Print HTML Bill', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
                ],
              ),
            ),
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
    final profileAsync = ref.watch(businessProfileStreamProvider);

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

    final shopLogoPath = profileAsync.valueOrNull?.logoPath;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 950;

              final leftSection = Padding(
                padding: EdgeInsets.all(isNarrow ? 12.0 : 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with Title, Language Toggle, and Logo Action
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isNepaliScript
                                  ? 'बिक्री काउन्टर (POS) / Billing'
                                  : 'Billing Counter (POS) / बिक्री काउन्टर',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isNepaliScript
                                  ? 'छिटो र भरपर्दो बिलिङ तथा स्टक अडिट'
                                  : 'Fast retail checkout with automatic stock audit',
                              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                            ),
                          ],
                        ),

                        Wrap(
                          spacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // English ⇄ Nepali Script Toggle
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.backgroundLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppTheme.borderSubtle),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () => setState(() => _isNepaliScript = false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: !_isNepaliScript ? AppTheme.primaryBlue : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '🇬🇧 English',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: !_isNepaliScript ? Colors.white : AppTheme.textMuted,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () => setState(() => _isNepaliScript = true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: _isNepaliScript ? AppTheme.primaryBlue : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '🇳🇵 नेपाली',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: _isNepaliScript ? Colors.white : AppTheme.textMuted,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Shop Logo Button / Indicator
                            InkWell(
                              onTap: _pickLogo,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.backgroundLight,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.borderSubtle),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.photo_camera_outlined, size: 16, color: AppTheme.primaryBlue),
                                    const SizedBox(width: 6),
                                    Text(
                                      shopLogoPath != null ? 'Logo Active' : 'Upload Logo',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            if (_cartLines.isNotEmpty)
                              TextButton.icon(
                                onPressed: _clearCart,
                                icon: const Icon(Icons.delete_sweep, color: Colors.redAccent, size: 18),
                                label: const Text('Clear', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Item Search and Add Bar (Instant Autocomplete)
                    Card(
                      color: AppTheme.backgroundLight,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: isNarrow
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildItemSearchAutocomplete(itemsAsync),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _qtyController,
                                          focusNode: _qtyFocusNode,
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          decoration: InputDecoration(
                                            labelText: _isNepaliScript ? 'परिमाण (Qty)' : 'Qty',
                                            suffixText: _selectedItem?.unit ?? '',
                                            isDense: true,
                                          ),
                                          onFieldSubmitted: (_) => _addItemToCart(),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _rateController,
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          decoration: InputDecoration(
                                            labelText: _isNepaliScript ? 'दर (Rate)' : 'Rate (Rs.)',
                                            prefixText: 'Rs. ',
                                            isDense: true,
                                          ),
                                          onFieldSubmitted: (_) => _addItemToCart(),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _discountController,
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          decoration: InputDecoration(
                                            labelText: _isNepaliScript ? 'छुट (Disc)' : 'Disc (Rs.)',
                                            isDense: true,
                                          ),
                                          onFieldSubmitted: (_) => _addItemToCart(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: _addItemToCart,
                                    icon: const Icon(Icons.add_shopping_cart, size: 16),
                                    label: Text(_isNepaliScript ? 'सामान थप्नुहोस् (Add)' : 'Add Item to Bill'),
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
                                    child: _buildItemSearchAutocomplete(itemsAsync),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 90,
                                    child: TextFormField(
                                      controller: _qtyController,
                                      focusNode: _qtyFocusNode,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        labelText: _isNepaliScript ? 'परिमाण' : 'Qty',
                                        suffixText: _selectedItem?.unit ?? '',
                                        isDense: true,
                                      ),
                                      onFieldSubmitted: (_) => _addItemToCart(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 110,
                                    child: TextFormField(
                                      controller: _rateController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        labelText: _isNepaliScript ? 'दर' : 'Rate (Rs.)',
                                        prefixText: 'Rs. ',
                                        isDense: true,
                                      ),
                                      onFieldSubmitted: (_) => _addItemToCart(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 95,
                                    child: TextFormField(
                                      controller: _discountController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        labelText: _isNepaliScript ? 'छुट' : 'Disc (Rs.)',
                                        isDense: true,
                                      ),
                                      onFieldSubmitted: (_) => _addItemToCart(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton.icon(
                                    onPressed: _addItemToCart,
                                    icon: const Icon(Icons.add_shopping_cart, size: 16),
                                    label: Text(_isNepaliScript ? 'थप्नुहोस्' : 'Add'),
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
        ),
      ),
    );
  }

  Widget _buildItemSearchAutocomplete(AsyncValue<List<Item>> itemsAsync) {
    return itemsAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const SizedBox(),
      data: (items) {
        return Autocomplete<Item>(
          displayStringForOption: (item) => _isNepaliScript && item.nepaliName != null
              ? '${item.nepaliName!} (${item.name})'
              : item.name,
          optionsBuilder: (TextEditingValue textEditingValue) {
            final query = textEditingValue.text.trim().toLowerCase();
            if (query.isEmpty) return const Iterable<Item>.empty();

            final queryDev = NepaliUnicodeHelper.transliterate(query).toLowerCase();

            return items.where((item) {
              final nameEn = item.name.toLowerCase();
              final nameNe = (item.nepaliName ?? '').toLowerCase();
              final sku = item.sku.toLowerCase();

              return nameEn.contains(query) ||
                  sku.contains(query) ||
                  nameNe.contains(query) ||
                  nameNe.contains(queryDev) ||
                  nameEn.startsWith(query);
            });
          },
          onSelected: _onItemSelected,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: _isNepaliScript
                    ? 'सामान खोज्नुहोस् (पहिलो अक्षर वा SKU) *'
                    : 'Search Item (First Letter / SKU) *',
                hintText: _isNepaliScript
                    ? 'जस्तै: "घडी" वा "casio" वा "0001"'
                    : 'Type first letter or SKU...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 16),
                        onPressed: () {
                          controller.clear();
                          _onItemSelected(null);
                        },
                      )
                    : null,
                isDense: true,
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280, maxWidth: 460),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: AppTheme.borderSubtle),
                    itemBuilder: (context, index) {
                      final item = options.elementAt(index);
                      final isLowStock = item.stockQty <= item.lowStockThreshold;
                      return ListTile(
                        dense: true,
                        title: Text(
                          _isNepaliScript && item.nepaliName != null
                              ? '${item.nepaliName!} (${item.name})'
                              : item.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        subtitle: Text(
                          'SKU: ${item.sku} | Stock: ${item.stockQty} ${item.unit}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isLowStock ? Colors.redAccent : AppTheme.accentTeal,
                          ),
                        ),
                        trailing: Text(
                          PaisaHelper.formatPaisa(item.sellingPricePaisa),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        onTap: () => onSelected(item),
                      );
                    },
                  ),
                ),
              ),
            );
          },
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

        // 2-Step Verified Bill Action Buttons
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _isSaving ? null : () => _completeCheckout(isDraft: false),
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline, size: 20),
              label: Text(
                _isNepaliScript
                    ? 'प्रमाणीकरण गरी बिल जारी गर्नुहोस्'
                    : 'Validate & Issue Bill',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _isSaving ? null : () => _completeCheckout(isDraft: true),
              icon: const Icon(Icons.edit_note, size: 20, color: Colors.orange),
              label: Text(
                _isNepaliScript
                    ? 'ड्राफ्टको रूपमा सुरक्षित गर्नुहोस् (Save Draft)'
                    : 'Save as Draft Bill',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
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
