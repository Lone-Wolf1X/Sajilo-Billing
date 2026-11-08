import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/khata_pdf_generator.dart';
import '../../domain/khata_models.dart';
import '../khata_provider.dart';

/// Modal dialog for recording customer credit settlements or supplier payouts.
class PaymentDialog extends ConsumerStatefulWidget {
  final PartySummary party;

  const PaymentDialog({
    super.key,
    required this.party,
  });

  @override
  ConsumerState<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends ConsumerState<PaymentDialog> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String _paymentMode = 'CASH';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.party.currentBalancePaisa > 0) {
      _amountController.text = (widget.party.currentBalancePaisa / 100.0).toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _setAmount(double rupees) {
    setState(() {
      _amountController.text = rupees.toStringAsFixed(2);
    });
  }

  Future<void> _handleSave() async {
    final rupees = double.tryParse(_amountController.text.trim());
    if (rupees == null || rupees <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid payment amount.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final amountPaisa = (rupees * 100).round();
    final isCustomer = widget.party.partyType == PartyType.customer;
    final repo = ref.read(khataRepositoryProvider);

    setState(() => _isSaving = true);
    try {
      String receiptNumber;
      if (isCustomer) {
        receiptNumber = await repo.recordCustomerPayment(
          customerId: widget.party.id,
          amountPaisa: amountPaisa,
          paymentMode: _paymentMode,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
      } else {
        receiptNumber = await repo.recordSupplierPayment(
          supplierId: widget.party.id,
          amountPaisa: amountPaisa,
          paymentMode: _paymentMode,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();

        // Prompt to print / preview receipt
        _showReceiptActionDialog(receiptNumber, amountPaisa);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment recording failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showReceiptActionDialog(String receiptNumber, int amountPaisa) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 26),
            SizedBox(width: 10),
            Text('Payment Recorded Successfully'),
          ],
        ),
        content: Text(
          'Receipt #$receiptNumber has been created and party ledger updated.\n\nWould you like to print or view the money receipt?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.print, size: 18),
            label: const Text('Print Receipt'),
            onPressed: () async {
              Navigator.pop(ctx);
              final db = ref.read(databaseProvider);
              final business = await (db.select(db.businessProfiles)..limit(1)).getSingle();
              final payment = await (db.select(db.partyPayments)
                    ..where((tbl) => tbl.receiptNumber.equals(receiptNumber)))
                  .getSingle();

              final remainingBalance = widget.party.currentBalancePaisa - amountPaisa;
              final doc = await KhataPdfGenerator.generatePaymentReceiptPdf(
                business: business,
                payment: payment,
                partyName: widget.party.name,
                currentRemainingBalancePaisa: remainingBalance,
              );

              await Printing.layoutPdf(onLayout: (format) async => doc.save());
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCustomer = widget.party.partyType == PartyType.customer;
    final balanceRupees = widget.party.currentBalancePaisa / 100.0;

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            isCustomer ? Icons.payments_outlined : Icons.outbox_outlined,
            color: AppTheme.primaryBlue,
            size: 26,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isCustomer ? 'Receive Payment (उधारो असुली)' : 'Pay Supplier (आपूर्तिकर्ता भुक्तानी)',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Party Info Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.party.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        if (widget.party.phone != null)
                          Text(widget.party.phone!, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isCustomer ? 'Current Due:' : 'Payable:',
                          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                        ),
                        Text(
                          widget.party.formattedBalance,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Payment Amount Input
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Payment Amount (रकम रु.) *',
                  prefixText: 'Rs. ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),

              // Quick Amount Chips
              Wrap(
                spacing: 8,
                children: [
                  if (balanceRupees > 0)
                    ActionChip(
                      label: const Text('Full Dues (पूरा बाँकी)'),
                      onPressed: () => _setAmount(balanceRupees),
                    ),
                  if (balanceRupees > 0)
                    ActionChip(
                      label: const Text('Half (आधा)'),
                      onPressed: () => _setAmount(balanceRupees / 2.0),
                    ),
                  ActionChip(
                    label: const Text('Rs. 500'),
                    onPressed: () => _setAmount(500),
                  ),
                  ActionChip(
                    label: const Text('Rs. 1,000'),
                    onPressed: () => _setAmount(1000),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Payment Mode Selector
              const Text('Payment Mode (भुक्तानीको माध्यम):', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Cash (नगद)'),
                    selected: _paymentMode == 'CASH',
                    onSelected: (s) => setState(() => _paymentMode = 'CASH'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Fonepay / QR'),
                    selected: _paymentMode == 'FONEPAY',
                    onSelected: (s) => setState(() => _paymentMode = 'FONEPAY'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Bank (बैंक)'),
                    selected: _paymentMode == 'BANK_TRANSFER',
                    onSelected: (s) => setState(() => _paymentMode = 'BANK_TRANSFER'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Remarks / Notes
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes / Remarks (कैफियत - ऐच्छिक)',
                  hintText: 'e.g. Cleared Poush bill',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _handleSave,
          child: _isSaving
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Save & Issue Receipt'),
        ),
      ],
    );
  }
}

