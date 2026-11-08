import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../../billing/domain/bill_model.dart';
import '../domain/printer_config.dart';
import '../domain/receipt_printer.dart';

/// Interactive dialog to test printer connectivity and dispatch a test receipt.
class PrinterTestDialog extends StatefulWidget {
  final PrinterConfig config;

  const PrinterTestDialog({super.key, required this.config});

  @override
  State<PrinterTestDialog> createState() => _PrinterTestDialogState();
}

class _PrinterTestDialogState extends State<PrinterTestDialog> {
  bool _isTesting = false;
  bool? _connectionSuccess;
  String? _statusMessage;
  bool _isPrintingSample = false;

  Future<void> _runConnectionTest() async {
    setState(() {
      _isTesting = true;
      _statusMessage = null;
    });

    try {
      final success = await ReceiptPrinter.instance.testConnection(widget.config);
      setState(() {
        _connectionSuccess = success;
        _statusMessage = success
            ? 'Connection established successfully to ${widget.config.isNetwork ? widget.config.ipAddress : (widget.config.usbPrinterName ?? "USB")}.'
            : 'Printer did not respond. Verify power, cables, and IP/port.';
      });
    } catch (e) {
      setState(() {
        _connectionSuccess = false;
        _statusMessage = 'Error: $e';
      });
    } finally {
      if (mounted) setState(() => _isTesting = false);
    }
  }

  Future<void> _printSampleSlip() async {
    setState(() => _isPrintingSample = true);
    try {
      final sampleBill = BillData(
        businessName: 'Sajilo Billing Test',
        businessNameNepali: 'सजिलो बिलिङ परीक्षण रसिद',
        panVatNumber: '123456789',
        contactNumber: '9800000000',
        shopAddress: 'Kathmandu, Nepal',
        invoiceNumber: 'TEST-0001',
        invoiceDate: DateTime.now(),
        customerName: 'Test Customer',
        customerPan: null,
        paymentMode: 'CASH',
        items: const [
          BillItem(
            sn: 1,
            description: 'Printer Test Item 1',
            quantity: 1.0,
            rate: 50.0,
            amount: 50.0,
            unit: 'pcs',
          ),
          BillItem(
            sn: 2,
            description: 'Thermal ESC/POS Slip',
            quantity: 2.0,
            rate: 25.0,
            amount: 50.0,
            unit: 'pcs',
          ),
        ],
        subtotal: 100.0,
        discountAmount: 0.0,
        taxableAmount: 100.0,
        vatAmount: 0.0,
        grandTotal: 100.0,
        inWords: 'One Hundred Rupees Only',
        qrData: 'https://nextgeninnovations.com.np/',
      );

      await ReceiptPrinter.instance.printReceipt(
        sampleBill,
        widget.config.defaultFormat,
        widget.config,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sample test receipt sent to printer!'),
            backgroundColor: AppTheme.accentTeal,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Print failed: $e'), backgroundColor: AppTheme.dangerRed),
        );
      }
    } finally {
      if (mounted) setState(() => _isPrintingSample = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          const Icon(Icons.print_outlined, color: AppTheme.primaryBlue),
          const SizedBox(width: 10),
          Text(l10n?.testConnection ?? 'Test Printer Connection'),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Target: ${widget.config.isNetwork ? "Network (${widget.config.ipAddress}:${widget.config.port})" : "USB (${widget.config.usbPrinterName ?? 'Default'})"}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 12),
            if (_statusMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _connectionSuccess == true
                      ? AppTheme.accentTeal.withOpacity(0.12)
                      : AppTheme.dangerRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _connectionSuccess == true ? AppTheme.accentTeal : AppTheme.dangerRed,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _connectionSuccess == true ? Icons.check_circle : Icons.error_outline,
                      color: _connectionSuccess == true ? AppTheme.accentTeal : AppTheme.dangerRed,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _statusMessage!,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: _connectionSuccess == true ? AppTheme.accentTeal : AppTheme.dangerRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
            const Text(
              'Click "Ping Connection" to verify the printer responds, or "Print Test Receipt" to feed and cut a test slip.',
              style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n?.cancel ?? 'Close'),
        ),
        OutlinedButton.icon(
          onPressed: _isTesting ? null : _runConnectionTest,
          icon: _isTesting
              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.wifi_tethering, size: 16),
          label: const Text('Ping Connection'),
        ),
        ElevatedButton.icon(
          onPressed: _isPrintingSample ? null : _printSampleSlip,
          icon: _isPrintingSample
              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Icon(Icons.receipt_long, size: 16),
          label: Text(l10n?.printTestReceipt ?? 'Print Test Slip'),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
        ),
      ],
    );
  }
}

